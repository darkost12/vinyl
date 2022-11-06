open Box

@react.component
let make = (~album: Types.Album.t) => {
  let previousSidesSongs = ref(0)
  <B className={"info-songs"}>
    {album.sides
    ->Array.mapWithIndex((sideIdx, side) => {
      let sideIdxString = Int.toString(sideIdx)

      <B className="info-side" key={album.title ++ sideIdxString}>
        <span key={"side-number-" ++ sideIdxString} className={"side-number"}>
          {React.string("Side " ++ Js.String2.fromCharCode(sideIdx + 65))}
        </span>
        {
          let sideSongs = side.songs->Array.mapWithIndex((i, track) =>
            <B key={track.title ++ Int.toString(i)} className={"info-song"}>
              <span className={"song-index"}>
                {React.string(Js.Int.toString(i + previousSidesSongs.contents + 1) ++ ".")}
              </span>
              <span className={"song-title"}> {React.string(track.title)} </span>
              <span className={"song-duration"}> {React.string(track.duration)} </span>
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
