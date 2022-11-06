@react.component
let make = (~greyscale=false, ~album: Types.Album.t) => {
  let dispatch = State.useDispatch()
  let className = "no-select " ++ "thumbnail" ++ (greyscale ? " greyscale" : "")

  <Mui.Box>
    <img
      src={album.coverUrl}
      onClick={_ => dispatch(HighlightedChanged(Some(album)))}
      loading={#"lazy"}
      className
    />
    <Info album />
  </Mui.Box>
}
