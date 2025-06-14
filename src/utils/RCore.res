module Core = RescriptCore
module List = Core.List
module Map = Core.Map
module Set = Core.Set
module Float = Core.Float
module Int = Core.Int
module Result = Core.Result

module Array = {
  include Core.Array

  let getBy = Core.Array.find

  let removeOne = (xs: array<'a>, ~at: int) => xs->toSpliced(~start=at, ~remove=1, ~insert=[])

  let keep = Core.Array.filter

  let keepMap = Core.Array.filterMap
}

module Option = {
  include Core.Option

  let flatten = x => {
    switch x {
    | Some(Some(y)) => Some(y)
    | Some(None) | None => None
    }
  }
}
