module Url = {
  type t = string
}

module Duration = {
  type t = string
}

module Song = {
  type t = {
    title: string,
    duration: option<Duration.t>,
  }

  let make = (title, duration) => {
    title,
    duration,
  }

  let decode = {
    open Json.Decode

    object(field => {
      title: field.required("title", string),
      duration: field.optional("duration", option(string))->Option.flatten,
    })
  }
}

module Side = {
  type t = {songs: array<Song.t>}

  let make = (songs: array<Song.t>): t => {songs: songs}

  let decode = {
    open Json.Decode

    object(field => {
      songs: field.required("songs", array(Song.decode)),
    })
  }
}

module ReleaseDate = {
  type t =
    | UpToDate(Js.Date.t)
    | UpToMonth(string, int)
    | UpToYear(int)
    | SeveralYears(array<int>)

  let toString = release =>
    switch release {
    | UpToDate(d) => Bindings.formatDate(d, Some("en-GB"))
    | UpToMonth((m, y)) => m ++ " " ++ Js.Int.toString(y)
    | UpToYear(y) => Js.Int.toString(y)
    | SeveralYears(years) => years->Array.map(y => y->Js.Int.toString)->Array.joinWith("/")
    }

  let months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ]

  let parseDate = v =>
    switch Js.String2.split(v, "-") {
    | [yearString, monthString, dayString] =>
      let year = Js.Float.fromString(yearString)
      let month = Js.Float.fromString(monthString)
      let date = Js.Float.fromString(dayString)

      if (
        Js.Float.isNaN(year) ||
        Js.Float.isNaN(month) ||
        month < 1.0 ||
        month > 12.0 ||
        Js.Float.isNaN(date) ||
        date < 1.0 ||
        date > 31.0
      ) {
        Js.log("Date is invalid: " ++ v)
        None
      } else {
        Some(UpToDate(Js.Date.makeWithYMD(~year, ~month=month -. 1.0, ~date, ())))
      }
    | [input] =>
      switch input
      ->Js.String2.split("/")
      ->Array.keepMap(part => Int.fromString(part, ~radix=10)) {
      | [] =>
        switch Js.String2.split(input, " ") {
        | [month, year] =>
          switch Int.fromString(year) {
          | Some(y) if Array.some(months, m => m == month) => Some(UpToMonth(month, y))
          | _ =>
            Js.log("Date is invalid: " ++ v)
            None
          }
        | [string] =>
          switch Int.fromString(string) {
          | Some(y) => Some(UpToYear(y))
          | _ =>
            Js.log("Date is invalid: " ++ v)
            None
          }
        | _ =>
          Js.log(
            "Unsupported date format. Expected: YYYY-MM-DD or 'Month YYYY' or YYYY or YYYY/YYYY.... Provided: " ++
            v,
          )
          None
        }
      | years => Some(SeveralYears(years))
      }
    | _ =>
      Js.log(
        "Unsupported date format. Expected: YYYY-MM-DD or 'Month YYYY' or YYYY or YYYY/YYYY..... Provided: " ++
        v,
      )
      None
    }

  let decode = value => {
    open Json.Decode

    switch parseDate(value) {
    | Some(r) => r
    | None => raise(DecodeError("Invalid date format"))
    }
  }
}

module Album = {
  type t = {
    title: string,
    artist: string,
    released: ReleaseDate.t,
    coverUrl: Url.t,
    previewUrl: option<Url.t>,
    wikiUrl: option<Url.t>,
    discogsUrl: option<Url.t>,
    genres: array<string>,
    sides: array<Side.t>,
  }

  let setAndEql = (optional: option<t>, value: t) =>
    switch optional {
    | Some({title, artist}) if title == value.title && artist == value.artist => true
    | _ => false
    }

  let make = (
    title,
    artist,
    released,
    coverUrl,
    previewUrl,
    wikiUrl,
    discogsUrl,
    genres,
    sides,
  ) => {
    title,
    artist,
    released,
    coverUrl,
    previewUrl,
    wikiUrl,
    discogsUrl,
    genres,
    sides,
  }

  let decode = {
    open Json.Decode

    object(field => {
      title: field.required("title", string),
      artist: field.required("artist", string),
      released: field.required("released", string->map(ReleaseDate.decode)),
      coverUrl: field.required("coverUrl", string),
      previewUrl: field.optional("previewUrl", string),
      wikiUrl: field.optional("wikiUrl", string),
      discogsUrl: field.optional("discogsUrl", string),
      genres: field.required("genres", array(string)),
      sides: field.required("sides", array(Side.decode)),
    })
  }
}

module Plates = {
  type t = {
    owned: array<Album.t>,
    wishlist: array<Album.t>,
  }

  let make = (owned, wishlist) => {
    owned,
    wishlist,
  }

  let decode = {
    open Json.Decode

    object(field => {
      owned: field.required("owned", array(Album.decode)),
      wishlist: field.required("wishlist", array(Album.decode)),
    })
  }
}

module Tab = {
  type t =
    | Owned
    | Wishlist

  let fromString = input =>
    switch input {
    | "owned" => Owned
    | _ => Wishlist
    }

  let toString = tab =>
    switch tab {
    | Owned => "owned"
    | Wishlist => "wishlist"
    }
}

module AlbumWithType = {
  type t = {
    album: Album.t,
    tab: Tab.t,
  }

  let make = (album, tab) => {
    album,
    tab,
  }
}

module Genres = {
  let unlessAlreadyHas = (genres, genre) =>
    switch Array.getBy(genres, g => g == genre) {
    | Some(_) => genres
    | None => Array.concat(genres, [genre])
    }

  let removeDuplicates = genres =>
    Array.reduce(genres, [], (acc, genre) => {
      unlessAlreadyHas(acc, genre)
    })

  let extract = (albums: array<Album.t>) =>
    albums->Array.flatMap(album => album.genres)->removeDuplicates->Js.Array2.sortInPlace
}
