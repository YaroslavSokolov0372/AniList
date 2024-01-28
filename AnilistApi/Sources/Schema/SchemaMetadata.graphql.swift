// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == AnilistApi.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == AnilistApi.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == AnilistApi.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == AnilistApi.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Query": return AnilistApi.Objects.Query
    case "Page": return AnilistApi.Objects.Page
    case "Media": return AnilistApi.Objects.Media
    case "MediaCoverImage": return AnilistApi.Objects.MediaCoverImage
    case "FuzzyDate": return AnilistApi.Objects.FuzzyDate
    case "MediaTitle": return AnilistApi.Objects.MediaTitle
    case "MediaTrend": return AnilistApi.Objects.MediaTrend
    case "CharacterConnection": return AnilistApi.Objects.CharacterConnection
    case "Character": return AnilistApi.Objects.Character
    case "CharacterImage": return AnilistApi.Objects.CharacterImage
    case "CharacterName": return AnilistApi.Objects.CharacterName
    case "MediaTrailer": return AnilistApi.Objects.MediaTrailer
    case "MediaConnection": return AnilistApi.Objects.MediaConnection
    case "PageInfo": return AnilistApi.Objects.PageInfo
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
