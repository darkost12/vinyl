open Box
open Types

let defineGenres = (activeTab, plates: Plates.t) =>
  switch activeTab {
  | Tab.Owned => plates.owned
  | Wishlist => plates.wishlist
  }->Types.Genres.extract

@react.component
let make = (~plates: Types.Plates.t) => {
  let ({genres, query, activeTab}: StateTypes.State.t, dispatch) = State.use()
  let (knownGenres, setKnownGenres) = React.useState(() => defineGenres(activeTab, plates))

  let onChange = (checked, g) => {
    dispatch(
      GenresChanged(
        if checked {
          Array.concat(genres, [g])
        } else {
          Array.keep(genres, genre => genre != g)
        },
      ),
    )
  }

  React.useEffect1(() => {
    setKnownGenres(_ => defineGenres(activeTab, plates))
    None
  }, [activeTab])

  <B
    display={bStr("flex")}
    flexDirection={bStr("column")}
    margin={bStr("2% 5%")}
    overflow={bStr("scroll")}
    height={bStr("calc(100% - 120px)")}>
    {knownGenres
    ->Array.map(genre => {
      <Mui.FormControlLabel
        className={"checkbox-container"}
        key={genre}
        label={React.string(genre)}
        control={<Mui.Checkbox
          onChange={e => onChange(ReactEvent.Form.target(e)["checked"], genre)}
          disabled={query != ""}
          checked={query == "" && Array.getBy(genres, g => g == genre) != None}
        />}
      />
    })
    ->React.array}
  </B>
}
