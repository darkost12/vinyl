open Mui
open Types.Tab

@react.component
let make = (~goToTop) => {
  let ({activeTab, query, genres}: StateTypes.State.t, dispatch) = State.use()
  let selectedClass = query != "" ? "faded" : ""
  let handleChange = (_, newValue) => {
    if query != "" || genres != [] {
      dispatch(QueryChanged(""))
      dispatch(GenresChanged([]))
    }

    dispatch(TabChanged(newValue->Any.unsafeToString->fromString))
    goToTop()
  }

  <Tabs
    centered=true
    value={activeTab->toString->Any.make}
    onChange=handleChange
    className={"tabs-menu"}>
    <Tab
      label={"Owned"->React.string}
      value={Any.fromString("owned")}
      classes={Mui.Tab.Classes.make(~selected=selectedClass, ())}
    />
    <Tab
      label={"Wishlist"->React.string}
      value={Any.fromString("wishlist")}
      classes={Mui.Tab.Classes.make(~selected=selectedClass, ())}
    />
  </Tabs>
}
