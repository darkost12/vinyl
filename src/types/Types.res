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
}

module Side = {
  type t = {songs: array<Song.t>}

  let make = (songs: array<Song.t>): t => {songs: songs}
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
    | UpToMonth((m, y)) => m ++ " " ++ Int.toString(y)
    | UpToYear(y) => Int.toString(y)
    | SeveralYears(years) => years->Array.joinWith("/", Int.toString)
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
