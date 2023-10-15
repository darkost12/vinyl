module Root = {
  type t

  @send external render: (t, React.element) => unit = "render"
}

@module("react-dom/client")
external createRoot: Dom.element => Root.t = "createRoot"

type intl

@new @scope("Intl")
external _dateTimeFormat: option<string> => intl = "DateTimeFormat"

@send external _format: (intl, Js.Date.t) => string = "format"

let formatDate = (date, locale) => _format(_dateTimeFormat(locale), date)

let refToOption = (ref: React.ref<Js.Nullable.t<Dom.element>>) => ref.current->Js.Nullable.toOption

let scrollTop: Dom.element => int = %raw(`
  function(el) { return el.scrollTop }
`)

let setScrollTop: (Dom.element, int) => unit = %raw(`
  function(el, offset) { el.scrollTop = offset }
`)

let setOnLoad: (Dom.element, unit => unit) => unit = %raw(`
  function(el, callback) { el.onload = callback }
`)

module History = {
  @val @scope(("window", "history"))
  external _pushState: (Js.Nullable.t<string>, Js.Nullable.t<string>, string) => unit = "pushState"

  @val @scope(("window", "history"))
  external _replaceState: (Js.Nullable.t<string>, Js.Nullable.t<string>, string) => unit =
    "replaceState"

  let pushState = (~_state=Js.Nullable.null, ~_unused=Js.Nullable.null, path) =>
    _pushState(_state, _unused, path)

  let replaceState = (~_state=Js.Nullable.null, ~_unused=Js.Nullable.null, path) =>
    _replaceState(_state, _unused, path)
}

@val external window: Dom.element = "window"

@val @scope(("window", "location"))
external _href: string = "href"
@val @scope(("window", "location"))
external _origin: string = "origin"

let relativePath = () => Js.String2.replace(_href, _origin, "")
