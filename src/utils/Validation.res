open Types

module D = Json.Decode

let apply = D.succeed
let map = D.andMap

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

let decodeDate = D.map(D.string, ~f=v => {
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
      Some(ReleaseDate.UpToDate(Js.Date.makeWithYMD(~year, ~month=month -. 1.0, ~date, ())))
    }
  | [input] =>
    switch input->Js.String2.split("/")->Array.keepMap(Int.fromString) {
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
})->D.andThen(~f=v =>
  switch v {
  | Some(v) => D.succeed(v)
  | None => D.fail("Invalid date")
  }
)

let decodeSong =
  apply((title, duration) => Song.make(title, duration))
  ->map(D.field("title", D.string))
  ->map(D.option(D.field("duration", D.string)))

let decodeSide = apply(songs => Side.make(songs))->map(D.field("songs", D.array(decodeSong)))

let decodeAlbum =
  apply((title, artist, released, coverUrl, wikiUrl, discogsUrl, genres, sides) =>
    Album.make(title, artist, released, coverUrl, wikiUrl, discogsUrl, genres, sides)
  )
  ->map(D.field("title", D.string))
  ->map(D.field("artist", D.string))
  ->map(D.field("released", decodeDate))
  ->map(D.field("coverUrl", D.string))
  ->map(D.option(D.field("previewUrl", D.string)))
  ->map(D.option(D.field("wikiUrl", D.string)))
  ->map(D.option(D.field("discogsUrl", D.string)))
  ->map(D.field("genres", D.array(D.string)))
  ->map(D.field("sides", D.array(decodeSide)))

let decode = json =>
  D.decodeValue(
    json,
    apply((owned, wishlist) => Plates.make(owned, wishlist))
    ->map(D.field("owned", D.array(decodeAlbum)))
    ->map(D.field("wishlist", D.array(decodeAlbum))),
  )
