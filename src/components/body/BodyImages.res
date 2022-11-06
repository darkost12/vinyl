open Mui

@react.component
let make = (~displayedPlates: array<Types.AlbumWithType.t>) =>
  <ImageList cols={Number.int(2)}>
    {displayedPlates
    ->Array.map(({album, tab}) =>
      <ImageListItem key={album.artist ++ album.title}>
        <BodyThumbnail album greyscale={tab == Wishlist} />
      </ImageListItem>
    )
    ->React.array}
  </ImageList>
