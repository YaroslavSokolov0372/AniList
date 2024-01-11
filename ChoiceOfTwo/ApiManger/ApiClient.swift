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
            
            state = .loading
            
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
                        self.state = .loaded(data)
                    case .failure(let error):
                        self.state = .failed(error)
                        debugPrint(error)
                    }
                }
        }
}
