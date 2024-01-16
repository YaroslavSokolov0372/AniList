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


extension MediaSeason {
    
    func getName() -> String {
        switch self {
        case .fall:
            return "Fall"
        case .spring:
            return "Spring"
        case .summer:
            return "Summer"
        case .winter:
            return "Winter"
        }
    }
}


extension MediaFormat {
    func getName() -> String {
        switch self {
        case .tv:
            return "TV"
        case .tvShort:
            return "TV Short"
        case .movie:
            return "Movie"
        case .special:
            return "Special"
        case .ova:
            return "OVA"
        case .ona:
            return "ONA"
        case .music:
            return "Music"
        case .manga:
            return "Manga"
        case .novel:
            return "Novel"
        case .oneShot:
            return "OneShot"
        }
    }
}


extension MediaSeason {
     
    func convertToGrapQL() -> GraphQLNullable<GraphQLEnum<MediaSeason>> {
        
        switch self {
        case .winter:
            return .some(.case(.fall))
        case .spring:
            return .some(.case(.spring))
        case .summer:
            return .some(.case(.summer))
        case .fall:
            return .some(.case(.winter))
        }
    }
}


extension Int {
    func convertToGraphQL() -> GraphQLNullable<Int> {
        return .some(self)
    }
}

extension [Genre] {
    func getRawValues() -> [String] {
        
        var values = [String]()
        for genre in self {
            values.append(genre.rawValue)
        }
        
        return values
    }
}

extension [MediaFormat] {
    
    func convertToGraphQL() -> [GraphQLEnum<MediaFormat>?] {
        
        var converted: [GraphQLEnum<MediaFormat>?] = []
        
        for format in self {
            switch format {
            case .tv:
                converted.append(.case(.tv))
            case .tvShort:
                converted.append(.case(.tvShort))
            case .movie:
                converted.append(.case(.movie))
            case .special:
                converted.append(.case(.special))
            case .ova:
                converted.append(.case(.ova))
            case .ona:
                converted.append(.case(.ona))
            case .music:
                converted.append(.case(.music))
            case .manga:
                converted.append(.case(.manga))
            case .novel:
                converted.append(.case(.novel))
            case .oneShot:
                converted.append(.case(.oneShot))
            }
        }
        
//        if converted.isEmpty {
//            return [.none]
//        } else {
            return converted
//        }
    }
}


