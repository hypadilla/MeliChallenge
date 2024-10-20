//
//  APIClient.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    var urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    @discardableResult
    func request(
        endpoint: String,
        method: HTTPMethod = .GET,
        headers: [String: String]? = nil,
        body: Data? = nil,
        retries: Int = AppConstants.maxRetries,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        let urlString = AppConstants.baseURL + endpoint
        guard let url = URL(string: urlString) else {
            Logger.log("invalid_url_error".localized + ": \(urlString)", level: .error)
            completion(.failure(APIError.invalidURL))
            return URLSessionDataTask()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = AppConstants.timeoutInterval
        
        var allHeaders = AppConstants.defaultHeaders
        if let headers = headers {
            allHeaders.merge(headers) { (_, new) in new }
        }
        for (key, value) in allHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body = body {
            urlRequest.httpBody = body
        }
        
        Logger.log(String(format: "making_request".localized, url.absoluteString))
        
        let task = self.urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                if retries > 0 {
                    Logger.log(String(format: "retrying_request".localized, retries), level: .info)
                    self.request(endpoint: endpoint, method: method, headers: headers, body: body, retries: retries - 1, completion: completion)
                } else {
                    Logger.log(String(format: "network_error".localized, error.localizedDescription), level: .error)
                    DispatchQueue.main.async {
                        completion(.failure(APIError.networkError(error)))
                    }
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.log("invalid_response".localized, level: .error)
                DispatchQueue.main.async {
                    completion(.failure(APIError.invalidResponse))
                }
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                if let data = data {
                    Logger.log(String(format: "received_data".localized, data.count))
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                } else {
                    Logger.log("no_data_received".localized, level: .error)
                    DispatchQueue.main.async {
                        completion(.failure(APIError.noData))
                    }
                }
            } else {
                Logger.log(String(format: "response_error".localized, httpResponse.statusCode), level: .error)
                DispatchQueue.main.async {
                    completion(.failure(APIError.responseError(statusCode: httpResponse.statusCode, data: data)))
                }
            }
        }
        task.resume()
        return task
    }
}
