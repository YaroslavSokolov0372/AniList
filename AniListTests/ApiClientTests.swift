//
//  AniListTests.swift
//  AniListTests
//
//  Created by Yaroslav Sokolov on 30/01/2024.
//

import XCTest
import AnilistApi
import Apollo

final class ApiClientTests: XCTestCase {
    let apiClient = ApiClient()
    
    
    func test_ApiClient_With_TheMostPopularAnimes() {
           
        let expectation = self.expectation(description: "Fetch Current Season Anime List")
        
        apiClient.getAnimeBy(
            page: 1,
            perPage: 20,
            sort: [.case(.popularityDesc)],
            type: .some(.case(.anime)),
            season: nil,
            seasonYear: nil,
            formats: nil,
            genres: nil,
            search: nil) { result in
                switch result {
                case .success(let success):
                    XCTAssertNotNil(success)
                    XCTAssertEqual(success.data?.page?.media?.count, 20)
                    expectation.fulfill()
                case .failure(let failure):
                    XCTAssertNil(failure)
                }
            }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    
    func test_ApiClient_With_CurrentSeasonPopulaAnimesr() {
        let expectation = self.expectation(description: "Fetch Current Season Anime List")
        
        apiClient.getAnimeBy(
            page: 1,
            perPage: 20,
            sort: [.case(.favouritesDesc)],
            type: .some(.case(.anime)),
            season: .some(Date().getSeason()),
            seasonYear: Date().getCurrentYear(),
            formats: nil,
            genres: nil,
            search: nil) { result in
                
                switch result {
                case .success(let success):
                    XCTAssertNotNil(success)
                    XCTAssertEqual(success.data?.page?.media?.count, 20)
                    expectation.fulfill()
                case .failure(let failure):
                    XCTAssertNil(failure)
                }
            }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_ApiClient_With_TrendingNowAnimes() {
        let expectation = self.expectation(description: "Fetch Trending Now Anime List")
        
        apiClient.getAnimeBy(
            page: 1,
            perPage: 20,
            sort: [.case(.trendingDesc)],
            type: .some(.case(.anime)),
            season: nil,
            seasonYear: nil,
            formats: nil,
            genres: nil,
            search: nil) { result in
                switch result {
                case .success(let success):
                    XCTAssertNotNil(success)
                    XCTAssertEqual(success.data?.page?.media?.count, 20)
                    expectation.fulfill()
                case .failure(let failure):
                    XCTAssertNil(failure)
                }
            }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    
    func test_Fetching_By_UserSearch_() {
        let expectation = self.expectation(description: "Fetch User Search Anime List")
        
        apiClient.getAnimeBy(
            page: 1,
            perPage: 20,
            sort: [.case(.favouritesDesc)],
            type: .some(.case(.anime)),
            season: ApiClient.mockChosenSeason.convertToGrapQL(),
            seasonYear: ApiClient.mockChosenYear.convertToGraphQL(),
            formats: GraphQLNullable.some(ApiClient.mockChosenFormats.convertToGraphQL()),
            genres: .some(ApiClient.mockGenres.getRawValues()),
            search: .some(ApiClient.mockSearchStringAnime)) { result in
                switch result {
                case .success(let success):
                    XCTAssertNotNil(success)
                    expectation.fulfill()
                case .failure(let failure):
                    XCTAssertNil(failure)
                }
            }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
