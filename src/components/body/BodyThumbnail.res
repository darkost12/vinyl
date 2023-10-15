open Box

let setOnLoad = (imgRef: ReactV3.React.ref<Js.Nullable.t<Dom.element>>, callback: unit => unit) => {
  switch imgRef.current->Js.Nullable.toOption {
  | Some(el) => Bindings.setOnLoad(el, callback)
  | None => ()
  }
}

@react.component
let make = (~greyscale=false, ~album: Types.Album.t) => {
  let dispatch = State.useDispatch()
  let (loading, setLoading) = React.useState(() => true)
  let className =
    "no-select thumbnail" ++ (greyscale ? " greyscale" : "") ++ (loading ? " loading" : "")
  let imgRef = React.useRef(Js.Nullable.null)

  React.useEffect0(() =>
    if loading {
      setOnLoad(imgRef, () => {
        setLoading(_ => false)
      })
      None
    } else {
      None
    }
  )

  <B height={bStr("100%")} width={bStr("100%")}>
    {<>
      {loading ? <Skeleton /> : React.null}
      <img
        src={album.coverUrl}
        loading={#"lazy"}
        onClick={_ => {
          dispatch(LastVisitedChanged(Some(album)))
          dispatch(HighlightedChanged(Some(album)))
          Bindings.History.pushState("/#")
        }}
        ref={ReactDOM.Ref.domRef(imgRef)}
        className
      />
    </>}
    <Info album />
  </B>
}
