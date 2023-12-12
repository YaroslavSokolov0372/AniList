// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetMediaQuery: GraphQLQuery {
  public static let operationName: String = "getMedia"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query getMedia($id: Int) { Media(id: $id, type: ANIME) { __typename id title { __typename romaji english native } } }"#
    ))

  public var id: GraphQLNullable<Int>

  public init(id: GraphQLNullable<Int>) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: AnilistApi.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("Media", Media?.self, arguments: [
        "id": .variable("id"),
        "type": "ANIME"
      ]),
    ] }

    /// Media query
    public var media: Media? { __data["Media"] }

    /// Media
    ///
    /// Parent Type: `Media`
    public struct Media: AnilistApi.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.Media }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Int.self),
        .field("title", Title?.self),
      ] }

      /// The id of the media
      public var id: Int { __data["id"] }
      /// The official titles of the media in various languages
      public var title: Title? { __data["title"] }

      /// Media.Title
      ///
      /// Parent Type: `MediaTitle`
      public struct Title: AnilistApi.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { AnilistApi.Objects.MediaTitle }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("romaji", String?.self),
          .field("english", String?.self),
          .field("native", String?.self),
        ] }

        /// The romanization of the native language title
        public var romaji: String? { __data["romaji"] }
        /// The official english title
        public var english: String? { __data["english"] }
        /// Official title in it's native language
        public var native: String? { __data["native"] }
      }
    }
  }
}
