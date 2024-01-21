//
//  AniListAPI.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/12/2023.
//

import Foundation
import AnilistApi
import Apollo

struct ClientError {
    let errorCode: Int
    let errorMessage: String
}

class ApiClient {
    
    private let appolo = ApolloClient(url: URL(string: "https://graphql.anilist.co")!)
//    private (set) var state = ClientState.idle
    
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
        completition: @escaping (GraphQLResult<GetAnimeByQuery.Data>) -> ()) {
            
//            state = .loading
            
            self.appolo.fetch(query: GetAnimeByQuery(page: page, perPage: perPage, sort: sort, type: type, season: season, seasonYear: seasonYear, search: search, asHtml: false, formatIn: formats, genreIn: genres)) { result in
                switch result {
                case .success(let data):
                    completition(data)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        self.state = .loaded(data)
                        if let error = data.errors {
                            debugPrint(error)
                        }
                    }
                case .failure(let error):
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
