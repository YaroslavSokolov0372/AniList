// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetAnimeByQuery: GraphQLQuery {
  public static let operationName: String = "getAnimeBy"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query getAnimeBy($sort: [MediaListSort], $page: Int, $perPage: Int) { Page(page: $page, perPage: $perPage) { __typename mediaList(sort: $sort) { __typename media { __typename title { __typename english native userPreferred } coverImage { __typename color large medium } bannerImage duration startDate { __typename year month day } } mediaId score status } } }"#
    ))

  public var sort: GraphQLNullable<[GraphQLEnum<MediaListSort>?]>
  public var page: GraphQLNullable<Int>
  public var perPage: GraphQLNullable<Int>

  public init(
    sort: GraphQLNullable<[GraphQLEnum<MediaListSort>?]>,
    page: GraphQLNullable<Int>,
    perPage: GraphQLNullable<Int>
  ) {
    self.sort = sort
    self.page = page
    self.perPage = perPage
  }

  public var __variables: Variables? { [
    "sort": sort,
    "page": page,
    "perPage": perPage
  ] }

  public struct Data: AnilistApi.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("Page", Page?.self, arguments: [
        "page": .variable("page"),
        "perPage": .variable("perPage")
      ]),
    ] }

    public var page: Page? { __data["Page"] }

    /// Page
    ///
    /// Parent Type: `Page`
    public struct Page: AnilistApi.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.Page }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("mediaList", [MediaList?]?.self, arguments: ["sort": .variable("sort")]),
      ] }

      public var mediaList: [MediaList?]? { __data["mediaList"] }

      /// Page.MediaList
      ///
      /// Parent Type: `MediaList`
      public struct MediaList: AnilistApi.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.MediaList }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("media", Media?.self),
          .field("mediaId", Int.self),
          .field("score", Double?.self),
          .field("status", GraphQLEnum<AnilistApi.MediaListStatus>?.self),
        ] }

        public var media: Media? { __data["media"] }
        /// The id of the media
        public var mediaId: Int { __data["mediaId"] }
        /// The score of the entry
        public var score: Double? { __data["score"] }
        /// The watching/reading status
        public var status: GraphQLEnum<AnilistApi.MediaListStatus>? { __data["status"] }

        /// Page.MediaList.Media
        ///
        /// Parent Type: `Media`
        public struct Media: AnilistApi.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.Media }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("title", Title?.self),
            .field("coverImage", CoverImage?.self),
            .field("bannerImage", String?.self),
            .field("duration", Int?.self),
            .field("startDate", StartDate?.self),
          ] }

          /// The official titles of the media in various languages
          public var title: Title? { __data["title"] }
          /// The cover images of the media
          public var coverImage: CoverImage? { __data["coverImage"] }
          /// The banner image of the media
          public var bannerImage: String? { __data["bannerImage"] }
          /// The general length of each anime episode in minutes
          public var duration: Int? { __data["duration"] }
          /// The first official release date of the media
          public var startDate: StartDate? { __data["startDate"] }

          /// Page.MediaList.Media.Title
          ///
          /// Parent Type: `MediaTitle`
          public struct Title: AnilistApi.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.MediaTitle }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("english", String?.self),
              .field("native", String?.self),
              .field("userPreferred", String?.self),
            ] }

            /// The official english title
            public var english: String? { __data["english"] }
            /// Official title in it's native language
            public var native: String? { __data["native"] }
            /// The currently authenticated users preferred title language. Default romaji for non-authenticated
            public var userPreferred: String? { __data["userPreferred"] }
          }

          /// Page.MediaList.Media.CoverImage
          ///
          /// Parent Type: `MediaCoverImage`
          public struct CoverImage: AnilistApi.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.MediaCoverImage }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("color", String?.self),
              .field("large", String?.self),
              .field("medium", String?.self),
            ] }

            /// Average #hex color of cover image
            public var color: String? { __data["color"] }
            /// The cover image url of the media at a large size
            public var large: String? { __data["large"] }
            /// The cover image url of the media at medium size
            public var medium: String? { __data["medium"] }
          }

          /// Page.MediaList.Media.StartDate
          ///
          /// Parent Type: `FuzzyDate`
          public struct StartDate: AnilistApi.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.FuzzyDate }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("year", Int?.self),
              .field("month", Int?.self),
              .field("day", Int?.self),
            ] }

            /// Numeric Year (2017)
            public var year: Int? { __data["year"] }
            /// Numeric Month (3)
            public var month: Int? { __data["month"] }
            /// Numeric Day (24)
            public var day: Int? { __data["day"] }
          }
        }
      }
    }
  }
}
