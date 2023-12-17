// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TrendingNowQuery: GraphQLQuery {
  public static let operationName: String = "trendingNow"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query trendingNow($page: Int, $perPage: Int, $sort: [MediaTrendSort]) { Page(page: $page, perPage: $perPage) { __typename mediaTrends(sort: $sort) { __typename media { __typename averageScore bannerImage chapters coverImage { __typename medium large extraLarge color } description duration episodes genres meanScore seasonYear source startDate { __typename year month day } title { __typename romaji userPreferred native english } } } } }"#
    ))

  public var page: GraphQLNullable<Int>
  public var perPage: GraphQLNullable<Int>
  public var sort: GraphQLNullable<[GraphQLEnum<MediaTrendSort>?]>

  public init(
    page: GraphQLNullable<Int>,
    perPage: GraphQLNullable<Int>,
    sort: GraphQLNullable<[GraphQLEnum<MediaTrendSort>?]>
  ) {
    self.page = page
    self.perPage = perPage
    self.sort = sort
  }

  public var __variables: Variables? { [
    "page": page,
    "perPage": perPage,
    "sort": sort
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
        .field("mediaTrends", [MediaTrend?]?.self, arguments: ["sort": .variable("sort")]),
      ] }

      public var mediaTrends: [MediaTrend?]? { __data["mediaTrends"] }

      /// Page.MediaTrend
      ///
      /// Parent Type: `MediaTrend`
      public struct MediaTrend: AnilistApi.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.MediaTrend }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("media", Media?.self),
        ] }

        /// The related media
        public var media: Media? { __data["media"] }

        /// Page.MediaTrend.Media
        ///
        /// Parent Type: `Media`
        public struct Media: AnilistApi.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.Media }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("averageScore", Int?.self),
            .field("bannerImage", String?.self),
            .field("chapters", Int?.self),
            .field("coverImage", CoverImage?.self),
            .field("description", String?.self),
            .field("duration", Int?.self),
            .field("episodes", Int?.self),
            .field("genres", [String?]?.self),
            .field("meanScore", Int?.self),
            .field("seasonYear", Int?.self),
            .field("source", GraphQLEnum<AnilistApi.MediaSource>?.self),
            .field("startDate", StartDate?.self),
            .field("title", Title?.self),
          ] }

          /// A weighted average score of all the user's scores of the media
          public var averageScore: Int? { __data["averageScore"] }
          /// The banner image of the media
          public var bannerImage: String? { __data["bannerImage"] }
          /// The amount of chapters the manga has when complete
          public var chapters: Int? { __data["chapters"] }
          /// The cover images of the media
          public var coverImage: CoverImage? { __data["coverImage"] }
          /// Short description of the media's story and characters
          public var description: String? { __data["description"] }
          /// The general length of each anime episode in minutes
          public var duration: Int? { __data["duration"] }
          /// The amount of episodes the anime has when complete
          public var episodes: Int? { __data["episodes"] }
          /// The genres of the media
          public var genres: [String?]? { __data["genres"] }
          /// Mean score of all the user's scores of the media
          public var meanScore: Int? { __data["meanScore"] }
          /// The season year the media was initially released in
          public var seasonYear: Int? { __data["seasonYear"] }
          /// Source type the media was adapted from.
          public var source: GraphQLEnum<AnilistApi.MediaSource>? { __data["source"] }
          /// The first official release date of the media
          public var startDate: StartDate? { __data["startDate"] }
          /// The official titles of the media in various languages
          public var title: Title? { __data["title"] }

          /// Page.MediaTrend.Media.CoverImage
          ///
          /// Parent Type: `MediaCoverImage`
          public struct CoverImage: AnilistApi.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.MediaCoverImage }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("medium", String?.self),
              .field("large", String?.self),
              .field("extraLarge", String?.self),
              .field("color", String?.self),
            ] }

            /// The cover image url of the media at medium size
            public var medium: String? { __data["medium"] }
            /// The cover image url of the media at a large size
            public var large: String? { __data["large"] }
            /// The cover image url of the media at its largest size. If this size isn't available, large will be provided instead.
            public var extraLarge: String? { __data["extraLarge"] }
            /// Average #hex color of cover image
            public var color: String? { __data["color"] }
          }

          /// Page.MediaTrend.Media.StartDate
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

          /// Page.MediaTrend.Media.Title
          ///
          /// Parent Type: `MediaTitle`
          public struct Title: AnilistApi.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.MediaTitle }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("romaji", String?.self),
              .field("userPreferred", String?.self),
              .field("native", String?.self),
              .field("english", String?.self),
            ] }

            /// The romanization of the native language title
            public var romaji: String? { __data["romaji"] }
            /// The currently authenticated users preferred title language. Default romaji for non-authenticated
            public var userPreferred: String? { __data["userPreferred"] }
            /// Official title in it's native language
            public var native: String? { __data["native"] }
            /// The official english title
            public var english: String? { __data["english"] }
          }
        }
      }
    }
  }
}
