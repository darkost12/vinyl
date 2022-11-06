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

    let (position, setPosition) = React.useState(() => Bindings.scrollTop())

    let goToTop = () => {
      Bindings.setScrollTop(0)
    }

    let handleScroll = () => {
      setPosition(_ => Bindings.scrollTop())
    }

    React.useEffect0(() => {
      Bindings.addScrollListener(handleScroll)
      Some(() => Bindings.removeScrollListener(handleScroll))
    })

    <State.Context.Provider value=context>
      <Mui.ThemeProvider theme>
        <Header goToTop />
        <Body plates />
        {if position > 500 {
          <GoToTopButton goToTop />
        } else {
          React.null
        }}
      </Mui.ThemeProvider>
    </State.Context.Provider>
  | Error(error) =>
    Js.log(error)
    {React.string("Error decoding data")}
  }
}
