//
//  AniListAPI.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 12/12/2023.
//

import Foundation
import AnilistApi
import Apollo

enum ClientErrorType: Error {
    case internetConnection(ClientError)
    case otherReason(ClientError)
}

struct ClientError {
    let errorCode: Int?
    let errorMessage: String
}

class ApiClient {
    
    private let appolo = ApolloClient(url: URL(string: "https://graphql.anilist.co")!)
    private (set) var network = NetworkReachability()
    
    private (set) var chosenGenres: [Genre] = []
    private (set) var chosenYear: Int?
    private (set) var chosenSeason: MediaSeason?
    private (set) var chosenFormats: [MediaFormat] = []
    private (set) var searchStringAnime: String?
    
    
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
        completition: @escaping (Result<GraphQLResult<GetAnimeByQuery.Data>, ClientErrorType>) -> ()) {
            
            
            self.appolo.fetch(query: GetAnimeByQuery(page: page, perPage: perPage, sort: sort, type: type, season: season, seasonYear: seasonYear, search: search, asHtml: .none, formatIn: formats, genreIn: genres)) { result in
                switch result {
                case .success(let data):
                    completition(.success(data))
                    DispatchQueue.main.async {
                        if let error = data.errors {
                            debugPrint(error)
                        }
                    }
                case .failure(let error):
                    if !self.network.isNetworkAvailable() {
                        completition(.failure(ClientErrorType.internetConnection(ClientError(errorCode: nil, errorMessage: "No Internet Connection"))))
                    } else {
                        completition(.failure(ClientErrorType.otherReason(ClientError(errorCode: nil, errorMessage: " Failed To Load Data"))))
                    }
                    debugPrint(error)
                }
            }
        }
    
    
    public func changeGenres(to genres: [Genre]) {
        chosenGenres = genres
    }
    
    public func changeYear(to year: Int?) {
        chosenYear = year
    }
    
    public func changeSeason(to season: MediaSeason?) {
        chosenSeason = season
    }
    
    public func changeFormats(to formats: [MediaFormat]) {
        chosenFormats = formats
    }
    
    public func changeSearchString(to string: String?) {
        searchStringAnime = string
    }
    
}



extension ApiClient {
    static let mockGenres = [Genre.action]
    static let mockChosenYear = 2014
    static let mockChosenSeason: MediaSeason = .fall
    static let mockChosenFormats: [MediaFormat] = [.music, .movie]
    static let mockSearchStringAnime  = "Clone"
}
