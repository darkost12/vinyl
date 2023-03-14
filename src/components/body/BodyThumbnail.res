@react.component
let make = (~greyscale=false, ~album: Types.Album.t) => {
  let dispatch = State.useDispatch()
  let className = "no-select " ++ "thumbnail" ++ (greyscale ? " greyscale" : "")

  <Mui.Box>
    <img
      src={album.coverUrl}
      onClick={_ => {
        dispatch(LastVisitedChanged(Some(album)))
        dispatch(HighlightedChanged(Some(album)))
        Bindings.History.pushState("/#")
      }}
      loading={#"lazy"}
      className
    />
    <Info album />
  </Mui.Box>
}
