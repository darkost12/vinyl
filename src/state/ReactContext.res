module type ContextState = {
  type t

  let initial: t
}

module Make = (ContextState: ContextState) => {
  type t = ContextState.t

  let initial = ContextState.initial

  let context: React.Context.t<t> = React.createContext(ContextState.initial)

  let use = () => React.useContext(context)

  module Provider = {
    let makeProps = (~value, ~children, ()) =>
      {
        "value": value,
        "children": children,
      }

    let make = React.Context.provider(context)
  }
}
