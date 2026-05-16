open Box

@react.component
let make = (~scrollableRef) => {
  let dispatch = State.useDispatch()
  let {sidebarOpen} = State.useState()

  <B
    bgcolor={PrimaryDark}
    width={bStr("100%")}
    height={bStr("70px")}
    display={bStr("flex")}
    alignItems={bStr("center")}
    justifyContent={bStr("center")}
    minWidth={bStr("450px")}
    zIndex={bNum(3.0)}
    position={bStr("fixed")}
  >
    <button className="sidebar-toggle-button" onClick={_ => dispatch(SidebarToggled)}>
      {if sidebarOpen {
        <svg
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          className="sidebar-toggle-icon"
        >
          <line x1="18" y1="6" x2="6" y2="18" />
          <line x1="6" y1="6" x2="18" y2="18" />
        </svg>
      } else {
        <svg
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          className="sidebar-toggle-icon"
        >
          <line x1="3" y1="6" x2="21" y2="6" />
          <line x1="3" y1="12" x2="21" y2="12" />
          <line x1="3" y1="18" x2="21" y2="18" />
        </svg>
      }}
    </button>
    <HeaderMenuTabs scrollableRef />
  </B>
}
