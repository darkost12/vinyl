open Box

@react.component
let make = (~album: Types.Album.t) =>
  <B className={"info-header"}>
    <B className={"info-miniature-container"}>
      <img src={album.coverUrl} className={"info-miniature no-select"} />
    </B>
    <B className={"info-gist-container"} display={bStr("absolute")}>
      <p className={"info-title info-gist"}> {React.string(album.title)} </p>
      <p className={"info-artist info-gist"}> {React.string(album.artist)} </p>
      <p className={"info-released info-gist"}>
        {React.string(Types.ReleaseDate.toString(album.released))}
      </p>
    </B>
  </B>
