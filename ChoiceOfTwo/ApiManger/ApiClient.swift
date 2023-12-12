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
    
    let appolo = ApolloClient(url: URL(string: "https://graphql.anilist.co")!)
    
    
    public func getData() -> [Any] {
        return []
    }
    
    public func getAnimeBy(sort: GraphQLNullable<[GraphQLEnum<MediaListSort>?]>, page: GraphQLNullable<Int>, perPage: GraphQLNullable<Int>, escaping: @escaping (GraphQLResult<GetAnimeByQuery.Data>) -> ()) {
        
        self.appolo.fetch(query: GetAnimeByQuery(sort: sort , page: page, perPage: perPage)) { result in
            switch result {
            case .success(let data):
                escaping(data)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
