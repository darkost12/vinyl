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

let addScrollListener: (Dom.element, unit => unit) => unit = %raw(`
  function(el, f) { el.addEventListener("scroll", f) }
`)

let removeScrollListener: (Dom.element, unit => unit) => unit = %raw(`
  function(el, f) { el.removeEventListener("scroll", f) }
`)
