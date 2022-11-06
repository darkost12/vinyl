%%raw("import '../../../src/index.css'")

switch ReactDOM.querySelector("#root") {
| Some(rootElement) =>
  let root = Bindings.createRoot(rootElement)
  Bindings.Root.render(root, <App />)
| None => ()
}
