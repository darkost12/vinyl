@react.component
let make = (~scrollableRef: React.ref<Js.Nullable.t<Dom.element>>) => {
  let goToTop = () => {
    switch scrollableRef.current->Js.Nullable.toOption {
    | Some(el) => Bindings.setScrollTop(el, 0)
    | None => ()
    }
  }

  <div className={"scroll-top-container no-select"} onClick={_ => goToTop()}>
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <polyline points="18 15 12 9 6 15" />
    </svg>
  </div>
}
