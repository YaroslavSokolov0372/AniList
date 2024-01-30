//
//  ExtensionToGetCurrentSeason.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 24/01/2024.
//

import Foundation
import AnilistApi


extension Date {
    func getSeason() -> GraphQLEnum<MediaSeason> {
        
        let calendar = Calendar.current
        
        let month = calendar.component(.month, from: self)
        
        switch month {
        case 3...5:
            return .case(.spring)
        case 6...9:
            return .case(.summer)
        case 10...12:
            return .case(.winter)
        case 1...2:
            return .case(.winter)
        default: return .case(.fall) 
        }
    }
}


extension Date {
    func getCurrentYear() -> GraphQLNullable<Int> {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: self)
        
        return .some(year)
    }
}
