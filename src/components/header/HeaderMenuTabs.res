open Mui
open Types.Tab

@react.component
let make = (~scrollableRef: React.ref<Js.Nullable.t<Dom.element>>) => {
  let ({activeTab, query, genres}: StateTypes.State.t, dispatch) = State.use()
  let selectedClass = query == "" ? "" : "faded"
  let handleChange = (_, newValue) => {
    if query != "" || genres != [] {
      dispatch(QueryChanged(""))
      dispatch(GenresChanged([]))
    }

    dispatch(TabChanged(newValue->fromString))
    switch scrollableRef.current->Js.Nullable.toOption {
    | Some(element) => Bindings.setScrollTop(element, 0)
    | None => ()
    }
  }

  <Tabs
    textColor={Inherit}
    centered=false
    value={activeTab->toString}
    onChange=handleChange
    className={"tabs-menu"}
  >
    <Tab
      className="left"
      label={"Owned"->React.string}
      value={"owned"}
      classes={selected: selectedClass}
    />
    <Tab
      className="right"
      label={"Wishlist"->React.string}
      value={"wishlist"}
      classes={selected: selectedClass}
    />
  </Tabs>
}
