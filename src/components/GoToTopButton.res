@react.component
let make = (~scrollableRef: React.ref<Js.Nullable.t<Dom.element>>) => {
  let goToTop = () => {
    switch scrollableRef.current->Js.Nullable.toOption {
    | Some(el) => Bindings.setScrollTop(el, 0)
    | None => ()
    }
  }

  <div className={"scroll-top-container"} onClick={_ => goToTop()}>
    <span className={"scroll-top no-select"}> {React.string("^")} </span>
  </div>
}
