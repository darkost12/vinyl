open Box

let setOnLoad = (imgRef: ReactV3.React.ref<Js.Nullable.t<Dom.element>>, callback: unit => unit) => {
  switch imgRef.current->Js.Nullable.toOption {
  | Some(el) => Bindings.setOnLoad(el, callback)
  | None => ()
  }
}

@react.component
let make = (~album: Types.Album.t) => {
  let (loading, setLoading) = React.useState(() => true)
  let className = "info-miniature no-select " ++ (loading ? " loading" : "")
  let imgRef = React.useRef(Js.Nullable.null)

  React.useEffect0(() =>
    if loading {
      setOnLoad(imgRef, () => {setLoading(_ => false)})
      None
    } else {
      None
    }
  )

  <B className={"info-miniature-container"}>
    {<>
      {loading ? <Skeleton /> : React.null}
      <img src={album.coverUrl} loading={#"lazy"} ref={ReactDOM.Ref.domRef(imgRef)} className />
    </>}
  </B>
}
