open Box

let mapWithType = (entries, entryType) =>
  Array.map(entries, entry => Types.AlbumWithType.make(entry, entryType))

let filterByGenres = (albums: array<Types.Album.t>, selectedGenres) =>
  switch selectedGenres {
  | [] => albums
  | genres =>
    Array.keep(albums, a =>
      Array.some(a.genres, genre => Array.getBy(genres, g => g == genre) != None)
    )
  }

@react.component
let make = (~plates: Types.Plates.t) => {
  let {activeTab, query, genres}: StateTypes.State.t = State.useState()

  let displayedPlates = switch query {
  | "" =>
    switch activeTab {
    | Owned => plates.owned->filterByGenres(genres)->mapWithType(Owned)
    | Wishlist => plates.wishlist->filterByGenres(genres)->mapWithType(Wishlist)
    }
  | input =>
    Array.concat(
      mapWithType(plates.owned, Owned),
      mapWithType(plates.wishlist, Wishlist),
    )->Array.keep(({album}) => {
      Array.some(
        Array.concatMany([
          [album.artist, album.title, Types.ReleaseDate.toString(album.released)],
          album.genres,
          Array.flatMap(album.sides, s => Array.map(s.songs, song => song.title)),
        ]),
        s => Js.String2.includes(Js.String2.toLowerCase(s), Js.String2.toLowerCase(input)),
      )
    })
  }

  <B minHeight={bStr("100%")} paddingTop={bStr("70px")} display={bStr("flex")}>
    <B
      bgcolor={bColor(#"primary.main")}
      display={bStr("flex")}
      flexDirection={bStr("column")}
      flexGrow={bInt(1)}>
      <B
        bgcolor={bColor(#"secondary.main")}
        width={bStr("70%")}
        flexGrow={bInt(1)}
        margin={bStr("auto")}>
        {if Array.length(displayedPlates) == 0 {
          <BodyNothingFound />
        } else {
          <BodyImages displayedPlates />
        }}
      </B>
    </B>
    <Sidebar plates />
  </B>
}
