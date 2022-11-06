module State = {
  type t = {
    activeTab: Types.Tab.t,
    query: string,
    genres: array<string>,
    highlighted: option<Types.Album.t>,
  }

  let activeTab = ({activeTab}) => activeTab
  let query = ({query}) => query
  let highlighted = ({highlighted}) => highlighted
  let genres = ({genres}) => genres

  let initial = {activeTab: Owned, query: "", genres: [], highlighted: None}
}

module Action = {
  type t =
    | TabChanged(Types.Tab.t)
    | QueryChanged(string)
    | GenresChanged(array<string>)
    | HighlightedChanged(option<Types.Album.t>)
}
