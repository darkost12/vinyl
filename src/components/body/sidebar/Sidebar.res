open Box

@react.component
let make = (~plates) => {
  <B
    bgcolor={PrimaryMain}
    display={bStr("flex")}
    flexDirection={bStr("column")}
    width={bStr("15%")}
    minWidth={bStr("114px")}
    height={bStr("calc(100% - 70px)")}
    maxHeight={bStr("fit-content")}
    position={bStr("fixed")}>
    <SidebarSearch />
    <SidebarGenreFilter plates />
  </B>
}
