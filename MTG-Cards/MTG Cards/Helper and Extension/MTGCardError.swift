//
//  MTGCardError.swift
//  MTG Cards
//
//  Created by Ben Erekson on 8/4/21.
//

import Foundation

enum MTGCardError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case couldNotDecode
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "The URL given to the system could not be translated"
        case .thrownError(let error):
            return "Error: \(error.localizedDescription)"
        case .noData:
            return "No data was returned form the API"
        case .couldNotDecode:
            return "Could not decode the JSON Object."
        }
    }
}
