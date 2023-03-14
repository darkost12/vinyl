let addEventListener: (Dom.element, string, unit => unit) => unit = %raw(`
  function(el, event, f) { el.addEventListener(event, f) }
`)

let removeEventListener: (Dom.element, string, unit => unit) => unit = %raw(`
  function(el, event, f) { el.removeEventListener(event, f) }
`)

type t = {scrollPosition: int}

let use = (~scrollableRef) => {
  let ({highlighted, lastVisited}: StateTypes.State.t, dispatch) = State.use()

  let (position, setPosition) = React.useState(() =>
    switch Bindings.refToOption(scrollableRef) {
    | Some(el) => Bindings.scrollTop(el)
    | None => 0
    }
  )

  React.useEffect2(() => {
    switch Bindings.refToOption(scrollableRef) {
    | Some(el) =>
      let handleScroll = () => setPosition(_ => Bindings.scrollTop(el))
      let handleLocationChange = () =>
        switch Bindings.relativePath() {
        | "/" => dispatch(HighlightedChanged(None))
        | "/#" if highlighted == None && lastVisited != None =>
          dispatch(HighlightedChanged(lastVisited))
        | _ if lastVisited != None => dispatch(LastVisitedChanged(None))
        | _ => ()
        }
      addEventListener(el, "scroll", handleScroll)
      addEventListener(Bindings.window, "popstate", handleLocationChange)
      Some(
        () => {
          removeEventListener(el, "scroll", handleScroll)
          removeEventListener(Bindings.window, "popstate", handleLocationChange)
        },
      )
    | None => None
    }
  }, (highlighted, lastVisited))

  {scrollPosition: position}
}
