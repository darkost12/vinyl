open Box
module Drawer = Mui.Drawer

module BackButton = {
  @react.component
  let make = (~onClick, ~closing) => {
    let className = "info-back-button no-select" ++ (closing ? " disabled" : "")
    <button onClick className>
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <polyline points="15 18 9 12 15 6" />
      </svg>
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
  let ({highlighted}: StateTypes.State.t, dispatch) = State.use()
  let (opened, setOpened) = React.useState(_ => Types.Album.setAndEql(highlighted, album))

  let onClose = _ => {
    dispatch(HighlightedChanged(None))
    Bindings.History.pushState("/")
  }

  let onEsc = (_, _reason) => {
    dispatch(HighlightedChanged(None))
    Bindings.History.pushState("/")
  }

  React.useEffect1(() => {
    setOpened(_ => Types.Album.setAndEql(highlighted, album))
    None
  }, [highlighted])

  <Drawer
    className={"drawer"}
    anchor=Left
    transitionDuration={Mui.Transition.Time(250)}
    open_=opened
    onClose={onEsc}>
    <BackButton closing={highlighted == None} onClick={onClose} />
    <B height={bStr("auto")} width={bStr("100%")}>
      <PreviewLink url=album.previewUrl />
      <B className={"info-container"}>
        <InfoHeader album />
        <InfoSongs album />
      </B>
    </B>
  </Drawer>
}
