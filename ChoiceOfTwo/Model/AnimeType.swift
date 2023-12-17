//
//  AnimeType.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/12/2023.
//

import Foundation
import AnilistApi

public enum AnimeType {
    case popularAllTime(PopularAllTimeQuery.Data.Page.Medium)
    case curentSeasonPopular(GetAnimeBySeasonQuery.Data.Page.Medium)
    case trendingNow(PopularAllTimeQuery.Data.Page.Medium)
}
