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

let scrollTop: unit => int = %raw(`
  function() { return window.document.documentElement.scrollTop }
`)

let setScrollTop: int => unit = %raw(`
  function(offset) { window.document.documentElement.scrollTop = offset }
`)

let addScrollListener: (unit => unit) => unit = %raw(`
  function(f) { window.addEventListener("scroll", f) }
`)

let removeScrollListener: (unit => unit) => unit = %raw(`
  function(f) { window.removeEventListener("scroll", f) }
`)
