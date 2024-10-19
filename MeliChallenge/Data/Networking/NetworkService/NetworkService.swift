//
//  NetworkService.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchData<T: Decodable>(
        from endpoint: String,
        method: HTTPMethod = .GET,
        headers: [String: String]? = nil,
        body: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        apiClient.request(endpoint: endpoint, method: method, headers: headers, body: body, retries: AppConstants.maxRetries) { result in
            switch result {
            case .success(let data):
                DispatchQueue.global(qos: .background).async {
                    do {
                        let decoder = JSONDecoder()
                        // Configurar decoder si es necesario
                        let decodedData = try decoder.decode(T.self, from: data)
                        Logger.log("data_parsed_successfully".localized)
                        DispatchQueue.main.async {
                            completion(.success(decodedData))
                        }
                    } catch {
                        Logger.log(String(format: "data_parsing_error".localized, error.localizedDescription), level: .error)
                        DispatchQueue.main.async {
                            completion(.failure(APIError.dataParsingError(error)))
                        }
                    }
                }
            case .failure(let error):
                Logger.log(String(format: "failed_to_fetch_data".localized, error.localizedDescription), level: .error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
