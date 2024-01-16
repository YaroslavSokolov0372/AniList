//
//  ListOfAnime.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 15/01/2024.
//

import Foundation
import AnilistApi


struct ListOfAnime {
        
    var pageInfo: GetAnimeByQuery.Data.Page.PageInfo?
    var animes: [GetAnimeByQuery.Data.Page.Medium]
}
