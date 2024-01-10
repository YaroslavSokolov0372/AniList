//
//  searchTools.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/12/2023.
//

import Foundation
import AnilistApi

enum SearchTool: String, CaseIterable {
//    case search = "Search"
    
    case genre = "Genres"
    case year = "Year"
    case season = "Season"
    case format = "Format"
    
    
    var startYear: Int {
        return 1970
    }
    
    var currentYear: Int {
        return Calendar.current.component(.year, from: Date())
    }
    
    var yearCount: Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentYearDate = Calendar.current.date(from: DateComponents(year: currentYear))
        let startYear = Calendar.current.date(from: DateComponents(year: 1970))
        let difference = Calendar.current.dateComponents([.year], from: startYear!, to: currentYearDate!)
        return difference.year!
    }
}

enum Genre: String, CaseIterable {
    case action = "Action"
    case adventure = "Adventure"
    case comedy = "Comedy"
    case drama = "Drama"
    case ecchi = "Ecchi"
    case fantasy = "Fantasy"
    case horror = "Horror"
    case mahouShoujo =  "Mahou Shoujo"
    case mecha = "Mecha"
    case music = "Music"
    case mystery = "Mystery"
    case psychological = "Psychological"
    case romance = "Romance"
    case sciFi = "Ski-Fi"
    case sliceOfLife = "Slice of Life"
    case sports = "Sports"
    case superNatural = "Supernatural"
    case thriller = "Thriller"
}

enum ToolsOptions {
    case search(GraphQLNullable<String>)
    case genre(GraphQLNullable<String>)
    case year(GraphQLNullable<Int>)
    case season(GraphQLNullable<GraphQLEnum<MediaSeason>>)
    case format(GraphQLNullable<GraphQLEnum<MediaFormat>>)
}
