open Mui

@react.component
let make = () => {
  let ({query}: StateTypes.State.t, dispatch) = State.use()
  let handleChange = value => dispatch(QueryChanged(Option.getWithDefault(value, "")))

  <Input
    value={query}
    spellCheck={false}
    startAdornment={React.string("\xa0🔍\xa0")}
    className="search-bar"
    disableUnderline=true
    onChange={e => handleChange(ReactEvent.Form.target(e)["value"])}
  />
}
