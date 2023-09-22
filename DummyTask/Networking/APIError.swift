//
//  APIError.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import Foundation
import Foundation

enum APIError: Error {
    case invalidURL
    case serializationError
    case networkError(Error)
    case invalidResponse
    case httpError(Int)
    case noData
    case decodingError(Error)
}
