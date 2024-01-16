// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetAnimeByQuery: GraphQLQuery {
  public static let operationName: String = "getAnimeBy"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query getAnimeBy($page: Int, $perPage: Int, $sort: [MediaSort], $type: MediaType, $season: MediaSeason, $seasonYear: Int, $search: String, $asHtml: Boolean, $formatIn: [MediaFormat], $genreIn: [String]) { Page(page: $page, perPage: $perPage) { __typename media( sort: $sort type: $type season: $season seasonYear: $seasonYear search: $search format_in: $formatIn genre_in: $genreIn ) { __typename bannerImage chapters coverImage { __typename medium large color extraLarge } description(asHtml: $asHtml) duration genres episodes meanScore seasonYear startDate { __typename year month day } title { __typename userPreferred native english } source averageScore countryOfOrigin format status endDate { __typename day month year } } pageInfo { __typename total perPage lastPage hasNextPage currentPage } } }"#
    ))

  public var page: GraphQLNullable<Int>
  public var perPage: GraphQLNullable<Int>
  public var sort: GraphQLNullable<[GraphQLEnum<MediaSort>?]>
  public var type: GraphQLNullable<GraphQLEnum<MediaType>>
  public var season: GraphQLNullable<GraphQLEnum<MediaSeason>>
  public var seasonYear: GraphQLNullable<Int>
  public var search: GraphQLNullable<String>
  public var asHtml: GraphQLNullable<Bool>
  public var formatIn: GraphQLNullable<[GraphQLEnum<MediaFormat>?]>
  public var genreIn: GraphQLNullable<[String?]>

  public init(
    page: GraphQLNullable<Int>,
    perPage: GraphQLNullable<Int>,
    sort: GraphQLNullable<[GraphQLEnum<MediaSort>?]>,
    type: GraphQLNullable<GraphQLEnum<MediaType>>,
    season: GraphQLNullable<GraphQLEnum<MediaSeason>>,
    seasonYear: GraphQLNullable<Int>,
    search: GraphQLNullable<String>,
    asHtml: GraphQLNullable<Bool>,
    formatIn: GraphQLNullable<[GraphQLEnum<MediaFormat>?]>,
    genreIn: GraphQLNullable<[String?]>
  ) {
    self.page = page
    self.perPage = perPage
    self.sort = sort
    self.type = type
    self.season = season
    self.seasonYear = seasonYear
    self.search = search
    self.asHtml = asHtml
    self.formatIn = formatIn
    self.genreIn = genreIn
  }

  public var __variables: Variables? { [
    "page": page,
    "perPage": perPage,
    "sort": sort,
    "type": type,
    "season": season,
    "seasonYear": seasonYear,
    "search": search,
    "asHtml": asHtml,
    "formatIn": formatIn,
    "genreIn": genreIn
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
        .field("media", [Medium?]?.self, arguments: [
          "sort": .variable("sort"),
          "type": .variable("type"),
          "season": .variable("season"),
          "seasonYear": .variable("seasonYear"),
          "search": .variable("search"),
          "format_in": .variable("formatIn"),
          "genre_in": .variable("genreIn")
        ]),
        .field("pageInfo", PageInfo?.self),
      ] }

      public var media: [Medium?]? { __data["media"] }
      /// The pagination information
      public var pageInfo: PageInfo? { __data["pageInfo"] }

      /// Page.Medium
      ///
      /// Parent Type: `Media`
      public struct Medium: AnilistApi.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.Media }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("bannerImage", String?.self),
          .field("chapters", Int?.self),
          .field("coverImage", CoverImage?.self),
          .field("description", String?.self, arguments: ["asHtml": .variable("asHtml")]),
          .field("duration", Int?.self),
          .field("genres", [String?]?.self),
          .field("episodes", Int?.self),
          .field("meanScore", Int?.self),
          .field("seasonYear", Int?.self),
          .field("startDate", StartDate?.self),
          .field("title", Title?.self),
          .field("source", GraphQLEnum<AnilistApi.MediaSource>?.self),
          .field("averageScore", Int?.self),
          .field("countryOfOrigin", AnilistApi.CountryCode?.self),
          .field("format", GraphQLEnum<AnilistApi.MediaFormat>?.self),
          .field("status", GraphQLEnum<AnilistApi.MediaStatus>?.self),
          .field("endDate", EndDate?.self),
        ] }

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
        /// The genres of the media
        public var genres: [String?]? { __data["genres"] }
        /// The amount of episodes the anime has when complete
        public var episodes: Int? { __data["episodes"] }
        /// Mean score of all the user's scores of the media
        public var meanScore: Int? { __data["meanScore"] }
        /// The season year the media was initially released in
        public var seasonYear: Int? { __data["seasonYear"] }
        /// The first official release date of the media
        public var startDate: StartDate? { __data["startDate"] }
        /// The official titles of the media in various languages
        public var title: Title? { __data["title"] }
        /// Source type the media was adapted from.
        public var source: GraphQLEnum<AnilistApi.MediaSource>? { __data["source"] }
        /// A weighted average score of all the user's scores of the media
        public var averageScore: Int? { __data["averageScore"] }
        /// Where the media was created. (ISO 3166-1 alpha-2)
        public var countryOfOrigin: AnilistApi.CountryCode? { __data["countryOfOrigin"] }
        /// The format the media was released in
        public var format: GraphQLEnum<AnilistApi.MediaFormat>? { __data["format"] }
        /// The current releasing status of the media
        public var status: GraphQLEnum<AnilistApi.MediaStatus>? { __data["status"] }
        /// The last official release date of the media
        public var endDate: EndDate? { __data["endDate"] }

        /// Page.Medium.CoverImage
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
            .field("color", String?.self),
            .field("extraLarge", String?.self),
          ] }

          /// The cover image url of the media at medium size
          public var medium: String? { __data["medium"] }
          /// The cover image url of the media at a large size
          public var large: String? { __data["large"] }
          /// Average #hex color of cover image
          public var color: String? { __data["color"] }
          /// The cover image url of the media at its largest size. If this size isn't available, large will be provided instead.
          public var extraLarge: String? { __data["extraLarge"] }
        }

        /// Page.Medium.StartDate
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

        /// Page.Medium.Title
        ///
        /// Parent Type: `MediaTitle`
        public struct Title: AnilistApi.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.MediaTitle }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("userPreferred", String?.self),
            .field("native", String?.self),
            .field("english", String?.self),
          ] }

          /// The currently authenticated users preferred title language. Default romaji for non-authenticated
          public var userPreferred: String? { __data["userPreferred"] }
          /// Official title in it's native language
          public var native: String? { __data["native"] }
          /// The official english title
          public var english: String? { __data["english"] }
        }

        /// Page.Medium.EndDate
        ///
        /// Parent Type: `FuzzyDate`
        public struct EndDate: AnilistApi.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.FuzzyDate }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("day", Int?.self),
            .field("month", Int?.self),
            .field("year", Int?.self),
          ] }

          /// Numeric Day (24)
          public var day: Int? { __data["day"] }
          /// Numeric Month (3)
          public var month: Int? { __data["month"] }
          /// Numeric Year (2017)
          public var year: Int? { __data["year"] }
        }
      }

      /// Page.PageInfo
      ///
      /// Parent Type: `PageInfo`
      public struct PageInfo: AnilistApi.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.PageInfo }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("total", Int?.self),
          .field("perPage", Int?.self),
          .field("lastPage", Int?.self),
          .field("hasNextPage", Bool?.self),
          .field("currentPage", Int?.self),
        ] }

        /// The total number of items. Note: This value is not guaranteed to be accurate, do not rely on this for logic
        public var total: Int? { __data["total"] }
        /// The count on a page
        public var perPage: Int? { __data["perPage"] }
        /// The last page
        public var lastPage: Int? { __data["lastPage"] }
        /// If there is another page
        public var hasNextPage: Bool? { __data["hasNextPage"] }
        /// The current page
        public var currentPage: Int? { __data["currentPage"] }
      }
    }
  }
}
