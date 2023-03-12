let theme = Mui.Theme.create({
  open Mui.ThemeOptions
  make(
    ~palette=PaletteOptions.make(
      ~primary=Primary.make(~main="#93BFCF", ~dark="#6096B4", ()),
      ~secondary=Primary.make(~main="#BDCDD6", ~light="#FFEBB7", ()),
      (),
    ),
    (),
  )
})

@react.component
let make = () => {
  switch Validation.decode(Database.entries) {
  | Ok(plates) =>
    let context = State.useContext()
    let scrollableRef = React.useRef(Js.Nullable.null)

    <State.Context.Provider value=context>
      <Mui.ThemeProvider theme>
        <Header scrollableRef />
        <Body plates scrollableRef />
      </Mui.ThemeProvider>
    </State.Context.Provider>
  | Error(error) =>
    Js.log(error)
    {React.string("Error decoding data")}
  }
}
