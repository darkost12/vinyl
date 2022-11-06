open Box

@react.component
let make = (~plates) => {
  <B
    bgcolor={bColor(#"primary.main")}
    display={bStr("flex")}
    flexDirection={bStr("column")}
    width={bStr("15%")}
    height={bStr("100%")}
    minWidth={bStr("114px")}
    className="fixed">
    <SidebarSearch />
    <SidebarGenreFilter plates />
  </B>
}
