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
    
    enum ClientState {
        case idle
        case loading
        case failed(Error)
        case loaded(Any)
    }
    
    private let appolo = ApolloClient(url: URL(string: "https://graphql.anilist.co")!)
    private (set) var state = ClientState.idle
    
    private (set) var currentPage: Int = 0
    private (set) var hasNextPage: Bool = false
    private (set) var lastPage: Int = 0
    private (set) var total: Int = 0
    
    
    public func getAnimeBy(
        page: GraphQLNullable<Int>,
        perPage: GraphQLNullable<Int>,
        sort: GraphQLNullable<[GraphQLEnum<MediaSort>?]>,
        type: GraphQLNullable<GraphQLEnum<MediaType>>,
        season: GraphQLNullable<GraphQLEnum<MediaSeason>>,
        seasonYear: GraphQLNullable<Int>,
        formats: GraphQLNullable<[GraphQLEnum<MediaFormat>?]>,
        genres: GraphQLNullable<[String?]>,
        search: GraphQLNullable<String>,
        escaping: @escaping (GraphQLResult<GetAnimeByQuery.Data>) -> ()) {
            
            state = .loading
            
            self.appolo.fetch(query: GetAnimeByQuery(page: page, perPage: perPage, sort: sort, type: type, season: season, seasonYear: seasonYear, search: search, asHtml: false, formatIn: formats, genreIn: genres)) { result in
                switch result {
                case .success(let data):
                    escaping(data)
                    self.state = .loaded(data)
//                        print(data.data?.page?.pageInfo?.hasNextPage)
//                        print(data.data?.page?.pageInfo?.lastPage)
//                        print(data.data?.page?.pageInfo?.currentPage)
                case .failure(let error):
                    self.state = .failed(error)
                    debugPrint(error)
                }
            }
            
//            self.appolo.fetch(query: GetAnimeByQuery(
//                page: page,
//                perPage: perPage,
//                sort: sort,
//                type: type,
//                season: season,
//                seasonYear: seasonYear,
//                format: format,
//                genre: genre,
//                search: search,
//                asHtml: false)) { result in
//                    switch result {
//                    case .success(let data):
//                        escaping(data)
//                        self.state = .loaded(data)
////                        print(data.data?.page?.pageInfo?.hasNextPage)
////                        print(data.data?.page?.pageInfo?.lastPage)
////                        print(data.data?.page?.pageInfo?.currentPage)
//                    case .failure(let error):
//                        self.state = .failed(error)
//                        debugPrint(error)
//                    }
//                }
        }
    
    
}
