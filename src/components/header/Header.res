open Box

@react.component
let make = (~scrollableRef) => {
  <B
    bgcolor={PrimaryDark}
    width={bStr("100%")}
    height={bStr("70px")}
    display={bStr("flex")}
    alignItems={bStr("center")}
    justifyContent={bStr("center")}
    minWidth={bStr("450px")}
    zIndex={bNum(3.0)}
    position={bStr("fixed")}>
    <HeaderMenuTabs scrollableRef />
  </B>
}
