//
//  ParametersEnum.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 27/12/2023.
//

import Foundation
import AnilistApi

//enum SideInfo {
//    case format(GetAnimeByQuery.Data.Page.Medium.status)
//    case episodes(GetAnimeByQuery.Data.Page.Medium.episodes)
//    case status(GetAnimeByQuery.Data.Page.Medium.status)
//    case meanScore(GetAnimeByQuery.Data.Page.Medium.meanScore)
//    case startDate(GetAnimeByQuery.Data.Page.Medium.StartDate?)
//    case endDate(GetAnimeByQuery.Data.Page.Medium.EndDate?)
//}




//extension GetAnimeByQuery.Data.Page.Medium {
//    
////    enum SideInfo {
////        
//////        case format(self.status)
//////        case episodes(self.episodes)
//////        case status(self.status)
//////        case meanScore(self.meanScore)
//////        case startDate(self.StartDate?)
//////        case endDate(self.EndDate?)
//////        case format()
////    }
//    
//    
//    func createSideInfo() {
//        var sideInfoArr = [SideInfo]()
//        
//        
////        sideInfoArr.append(.format(self.format))
////        sideInfoArr.append(.episodes(self.episodes))
////        sideInfoArr.append(.status(self.status))
////        sideInfoArr.append(.meanScore(self.meanScore))
////        sideInfoArr.append(.startDate(self.startDate))
////        sideInfoArr.append(.endDate(self.endDate))
//    }
//    
//    
//    
//}


struct SideInfo {
    let sideInfoHeader: String
    let sideInfoDescription: Any
}
