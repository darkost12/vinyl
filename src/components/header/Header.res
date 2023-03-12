open Box

@react.component
let make = (~scrollableRef) => {
  <B
    className={"fixed"}
    bgcolor={bColor(#"primary.dark")}
    width={bStr("100%")}
    height={bStr("70px")}
    display={bStr("flex")}
    alignItems={bStr("center")}
    justifyContent={bStr("center")}
    minWidth={bStr("768px")}
    zIndex={3}>
    <HeaderMenuTabs scrollableRef />
  </B>
}
