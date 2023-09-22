//
//  APIManager.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import Foundation
import Combine

struct APIResponse<T> {
    let value: T
    let response: URLResponse
}


class APIManager {
    private let baseURL = "https://dummyjson.com/"
    private let authenticationToken: String?
    
    init(authenticationToken: String? = nil) {
        self.authenticationToken = authenticationToken
    }
    
    func request<T: Decodable>(endpoint: String, httpMethod: httpMethod, parameters: [String: Any] = [:]) -> AnyPublisher<APIResponse<T>, APIError> {
        
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        switch httpMethod {
        case .GET:
            guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
                return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
            }
            
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            urlComponents.queryItems = queryItems
            
            request.url = urlComponents.url
            
        case .POST:
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted){
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
            }
            if let token = authenticationToken {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.current)
            .tryMap { (data, response) -> APIResponse<T> in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw APIError.invalidResponse
                }
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    return APIResponse(value: decodedData, response: response)
                } catch {
                    throw APIError.decodingError(error)
                }
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
}



