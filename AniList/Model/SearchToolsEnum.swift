//
//  searchTools.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 17/12/2023.
//

import Foundation
import AnilistApi

enum SearchTool: String, CaseIterable {
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


