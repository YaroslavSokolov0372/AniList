query getAnimeBy($sort: [MediaListSort], $page: Int, $perPage: Int) {
  Page(page: $page, perPage: $perPage) {
    mediaList(sort: $sort) {
      media {
        title {
          english
          native
          userPreferred
        }
        coverImage {
          color
          large
          medium
        }
        bannerImage
      }
      mediaId
      score
      status
    }
  }
}

