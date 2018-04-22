//
//  MusicPlacesTests.swift
//  MusicPlacesTests
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import XCTest
@testable import MusicPlaces

class MusicPlacesTests: XCTestCase {
    struct MockedResponseInfo {
        static let keyword: String = "Music"
        static let count: Int = 712
        static let offset: Int = 0
        static let limit: Int = 5
        static var numberOfPlaces: Int {
            if AppSettings.shouldFilterPlacesByDateAndRemovedAfterTime {
                //Only one has beginYear >= 1990
                return 1
            } else {
                //One has no coordinates so doesn't conform to our model rules
                return 4
            }
        }
    }

    override func setUp() {
        super.setUp()
        AppSettings.defaultRequestLimit = 25
        AppSettings.beginYearFilter = 1990
        AppSettings.shouldFilterPlacesByDateAndRemovedAfterTime = true
    }

    override func tearDown() {
        super.tearDown()
    }

    func getJSONDataFromFile() -> Data {

        guard let path = Bundle(for: MusicPlacesTests.self).path(forResource: "sampleResponse", ofType: "json") else {
            fatalError("JSON file can't be found")
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
        } catch {
            fatalError("JSON file can't be parsed")
        }
    }


    func testDecodingResponseDataToModelFilteringDisabled() {
        // Siable filtering
        AppSettings.shouldFilterPlacesByDateAndRemovedAfterTime = false

        let responseData = getJSONDataFromFile()
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(APIPlacesResponse.self, from: responseData)

            XCTAssert(MockedResponseInfo.count == response.count)
            XCTAssert(MockedResponseInfo.offset == response.offset)
            XCTAssert(MockedResponseInfo.numberOfPlaces == response.places.count)
        } catch {
            XCTFail("Decoding failed")
            return
        }

    }

    func testDecodingResponseDataToModelFilteringEnabled() {
        // Enable filtering
        AppSettings.shouldFilterPlacesByDateAndRemovedAfterTime = true
        AppSettings.beginYearFilter = 1990

        let responseData = getJSONDataFromFile()
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(APIPlacesResponse.self, from: responseData)

            XCTAssert(MockedResponseInfo.count == response.count)
            XCTAssert(MockedResponseInfo.offset == response.offset)
            XCTAssert(MockedResponseInfo.numberOfPlaces == response.places.count)
        } catch {
            XCTFail("Decoding failed")
            return
        }

    }

    func testURLFactory() {
        let urlForGivenConditions = "https://musicbrainz.org/ws/2/place/?query=music&limit=5&offset=100&fmt=json"
        let generatedURL = RequestURLFactory.generatePlaceURLString("music", limit: 5, offset: 100)
        XCTAssert(generatedURL == urlForGivenConditions)
    }

    func testOffsetCalculator() {
        let numberOfResults = 101
        let correctOffsets = [25, 50, 75, 100]

        let generatedOffsets = MapWorker().calculateOffsets(numberOfResults)

        XCTAssert(generatedOffsets == correctOffsets)
    }
}




