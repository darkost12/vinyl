open Mui.ThemeOptions
let theme = Mui.Theme.create({
  palette: {
    primary: {main: "#93BFCF", dark: "#6096B4"},
    secondary: {main: "#BDCDD6", light: "#FFEBB7"},
    success: {main: "rgba(0, 0, 0, 0.6)"},
  },
})

@react.component
let make = () => {
  switch Database.entries->Json.decode(Types.Plates.decode) {
  | Ok(plates) =>
    let context = State.useContext()
    let scrollableRef = React.useRef(Js.Nullable.null)

    <State.Context.Provider value=context>
      <Mui.ThemeProvider theme={Theme(theme)}>
        <Header scrollableRef />
        <Body plates scrollableRef />
      </Mui.ThemeProvider>
    </State.Context.Provider>
  | Error(error) =>
    Js.log(error)
    {React.string("Error decoding data")}
  }
}
