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
    case "Media": return AnilistApi.Objects.Media
    case "MediaTitle": return AnilistApi.Objects.MediaTitle
    case "Page": return AnilistApi.Objects.Page
    case "MediaCoverImage": return AnilistApi.Objects.MediaCoverImage
    case "FuzzyDate": return AnilistApi.Objects.FuzzyDate
    case "MediaTrend": return AnilistApi.Objects.MediaTrend
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
