open Box
module Drawer = Mui.Drawer

module BackButton = {
  @react.component
  let make = (~onClick) => {
    let (className, setClassName) = React.useState(() => "info-back-button")
    <button
      onClick={_e => {
        setClassName(_ => "disabled")
        onClick()
      }}
      className>
      {React.string("<")}
    </button>
  }
}

module PreviewLink = {
  @react.component
  let make = (~url) =>
    switch url {
    | Some(url) =>
      <a href=url target="_blank">
        <B className={"info-preview-container"}>
          <img className={"info-preview-tonearm no-select"} src={"dist/tonearm.png"} />
          <img className={"info-preview no-select"} src={"dist/plate.png"} />
        </B>
      </a>
    | None => React.null
    }
}

@react.component
let make = (~album: Types.Album.t) => {
  let (state, dispatch) = State.use()

  <Drawer
    className={"drawer"}
    anchor=#left
    transitionDuration={Drawer.TransitionDuration.int(750)}
    \"PaperProps"={{"style": {"width": "100%"}}}
    \"open"={Types.Album.setAndEql(state.highlighted, album)}
    onClose={_ => dispatch(HighlightedChanged(None))}>
    <BackButton onClick={() => dispatch(HighlightedChanged(None))} />
    <B height={bStr("auto")} width={bStr("100%")}>
      <PreviewLink url=album.previewUrl />
      <B className={"info-container"}>
        <InfoHeader album />
        <InfoSongs album />
      </B>
    </B>
  </Drawer>
}
