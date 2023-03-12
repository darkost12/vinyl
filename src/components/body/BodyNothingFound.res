open Box

@react.component
let make = () => {
  <B
    bgcolor={bColor(#"secondary.main")}
    width={bStr("100%")}
    display={bStr("flex")}
    justifyContent={bStr("center")}>
    <span className="nothing"> {React.string("Oh no. Nothing found!")} </span>
  </B>
}
