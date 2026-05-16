open Box

@react.component
let make = (~plates) => {
  let {sidebarOpen} = State.useState()

  <B
    bgcolor={PrimaryMain}
    display={bStr("flex")}
    flexDirection={bStr("column")}
    width={bStr("15%")}
    minWidth={bStr("114px")}
    height={bStr("calc(100% - 70px)")}
    maxHeight={bStr("fit-content")}
    position={bStr("fixed")}
  >
    <div className={"sidebar-drawer" ++ (sidebarOpen ? " sidebar-drawer-open" : "")}>
      <SidebarSearch />
      <SidebarGenreFilter plates />
    </div>
  </B>
}
