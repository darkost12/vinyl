open Box

@react.component
let make = (~album: Types.Album.t) => {
  let previousSidesSongs = ref(0)
  <B className={"info-songs"}>
    {album.sides
    ->Array.mapWithIndex((side, sideIdx) => {
      let sideIdxString = Js.Int.toString(sideIdx)

      <B className="info-side" key={album.title ++ sideIdxString}>
        <span key={"side-number-" ++ sideIdxString} className={"side-number"}>
          {React.string("Side " ++ Js.String2.fromCharCode(sideIdx + 65))}
        </span>
        {
          let sideSongs = side.songs->Array.mapWithIndex((track, i) =>
            <B className={"info-song"} key={track.title ++ Js.Int.toString(i)}>
              <span className={"song-index"}>
                {React.string(Js.Int.toString(i + previousSidesSongs.contents + 1) ++ ".")}
              </span>
              <span className={"song-title"}> {React.string(track.title)} </span>
              <span className={"song-duration"}>
                {React.string(Option.getWithDefault(track.duration, "—"))}
              </span>
            </B>
          )
          previousSidesSongs.contents = previousSidesSongs.contents + Array.length(side.songs)
          React.array(sideSongs)
        }
      </B>
    })
    ->React.array}
  </B>
}
