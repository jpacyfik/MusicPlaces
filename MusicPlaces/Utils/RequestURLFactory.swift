//
//  RequestURLFactory.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

final class RequestURLFactory {
    fileprivate static let baseURLString = "https://musicbrainz.org/ws/2"
    fileprivate static let places = "/place"
    fileprivate static let jsonFormat = "&fmt=json"

    fileprivate static func getQueryPhraseSuffix(_ phrase: String) -> String {
        let fixedPhrase = phrase.trimmingCharacters(in: .whitespaces)
        return "/?query=\(fixedPhrase)"
    }

    fileprivate static func getOffsetParam(_ offset: Int) -> String {
        return "&offset=\(offset.description)"
    }

    fileprivate static func getLimitParam(_ limit: Int) -> String {
        return "&limit=\(limit.description)"
    }

    static func generatePlaceURLString(_ searchPhrase: String, limit: Int = Constants.defaultRequestLimit, offset: Int = 0) -> String {
        return (baseURLString + places + getQueryPhraseSuffix(searchPhrase) + getLimitParam(limit) + getOffsetParam(offset) + jsonFormat)
    }
}
