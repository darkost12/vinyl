open Mui
open Types.Tab

@react.component
let make = (~scrollableRef: React.ref<Js.Nullable.t<Dom.element>>) => {
  let ({activeTab, query, genres}: StateTypes.State.t, dispatch) = State.use()
  let selectedClass = query != "" ? "faded" : ""
  let handleChange = (_, newValue) => {
    if query != "" || genres != [] {
      dispatch(QueryChanged(""))
      dispatch(GenresChanged([]))
    }

    dispatch(TabChanged(newValue->Any.unsafeToString->fromString))
    switch scrollableRef.current->Js.Nullable.toOption {
    | Some(element) => Bindings.setScrollTop(element, 0)
    | None => ()
    }
  }

  <Tabs
    centered=false
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
