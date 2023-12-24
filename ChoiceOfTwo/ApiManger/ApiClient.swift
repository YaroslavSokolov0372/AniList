//
//  AniListAPI.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/12/2023.
//

import Foundation
import AnilistApi
import Apollo

class ApiClient {
    
    private let appolo = ApolloClient(url: URL(string: "https://graphql.anilist.co")!)
    
    
    public func getData() -> [Any] {
        return []
    }
    
    public func getAnimeBySort(_ sorting: GraphQLNullable<[GraphQLEnum<MediaSort>?]>, escaping: @escaping (GraphQLResult<PopularAllTimeQuery.Data>) -> ()) async {
        self.appolo.fetch(query: PopularAllTimeQuery(page: 1, perPage: 20, sort: sorting, type: .some(.case(.anime)))) { result in
            switch result {
            case .success(let data):
                escaping(data)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    public func getAnimeBySeason(page: GraphQLNullable<Int>, perPage: GraphQLNullable<Int>, sort: GraphQLNullable<[GraphQLEnum<MediaSort>?]>, type: GraphQLNullable<GraphQLEnum<MediaType>>, season: GraphQLNullable<GraphQLEnum<MediaSeason>>, seasonYear: GraphQLNullable<Int>, escaping: @escaping (GraphQLResult<GetAnimeBySeasonQuery.Data>) -> ()) async {
        self.appolo.fetch(query: GetAnimeBySeasonQuery(page: page, perPage: perPage, sort: sort, type: type, season: season, seasonYear: seasonYear)) { result in
            switch result {
            case .success(let data):
                escaping(data)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    
    public func getAnimeBy(
        page: GraphQLNullable<Int>,
        perPage: GraphQLNullable<Int>,
        sort: GraphQLNullable<[GraphQLEnum<MediaSort>?]>,
        type: GraphQLNullable<GraphQLEnum<MediaType>>,
        season: GraphQLNullable<GraphQLEnum<MediaSeason>>,
        seasonYear: GraphQLNullable<Int>,
        format: GraphQLNullable<GraphQLEnum<MediaFormat>>,
        genre: GraphQLNullable<String>,
        search: GraphQLNullable<String>,
        escaping: @escaping (GraphQLResult<GetAnimeByQuery.Data>) -> ()) {
            
        self.appolo.fetch(query: GetAnimeByQuery(
            page: page,
            perPage: perPage,
            sort: sort,
            type: type,
            season: season,
            seasonYear: seasonYear,
            format: format,
            genre: genre,
            search: search,
            asHtml: false)) { result in
                
            switch result {
            case .success(let data):
                escaping(data)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
