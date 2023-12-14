//
//  AnimeType.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/12/2023.
//

import Foundation
import AnilistApi

public enum AnimeType {
    case popularAllTime(GetAnimeBySortQuery.Data.Page.Medium)
    case curentSeasonPopular(GetAnimeBySeasonQuery.Data.Page.Medium)
    case trendingNow(GetAnimeBySeasonQuery.Data.Page.Medium)
}
