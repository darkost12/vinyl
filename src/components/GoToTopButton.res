@react.component
let make = (~goToTop) =>
  <div className={"scroll-top-container"} onClick={_ => goToTop()}>
    <span className={"scroll-top no-select"}> {React.string("^")} </span>
  </div>
