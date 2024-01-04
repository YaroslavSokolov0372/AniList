//
//  searchTools.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/12/2023.
//

import Foundation
import AnilistApi

enum SearchTools: String, CaseIterable {
//    case search = "Search"
    case genre = "Genres"
    case year = "Year"
    case season = "Season"
    case format = "Format"
}


enum ToolsOptions {
    case search(GraphQLNullable<String>)
    case genre(GraphQLNullable<String>)
    case year(GraphQLNullable<Int>)
    case season(GraphQLNullable<GraphQLEnum<MediaSeason>>)
    case format(GraphQLNullable<GraphQLEnum<MediaFormat>>)
}
