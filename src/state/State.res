open StateTypes

module Context = ReactContext.Make({
  type t = (State.t, Action.t => unit)

  let initial = (State.initial, _ => ())
})

let reducer = (state: State.t, action: Action.t) => {
  switch action {
  | TabChanged(tab) => {...state, activeTab: tab}
  | QueryChanged(query) => {...state, query}
  | GenresChanged(genres) => {...state, genres}
  | HighlightedChanged(highlighted) => {...state, highlighted}
  | LastVisitedChanged(lastVisited) => {...state, lastVisited}
  }
}

let use = Context.use

let useState = () => {
  let (state, _) = use()
  state
}

let useDispatch = () => {
  let (_, dispatch) = use()
  dispatch
}

let useContext = () => {
  React.useReducer(reducer, useState())
}
