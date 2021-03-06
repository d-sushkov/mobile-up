//
//  APIManager.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import Foundation

struct APICallError: Error {
    enum ErrorKind {
        case connectionLost
        case dataTaskFailed
        case noDataRetrieved
    }
    let kind: ErrorKind
    let response: URLResponse?
}

class APIManager {
    
    var progress = Progress(totalUnitCount: 4)
    
    var result: [APIModel]?
    
    private let apiURLString = "https://s3-eu-west-1.amazonaws.com/builds.getmobileup.com/storage/MobileUp-Test/api.json"

    func getMessages(completion: @escaping ((Result<Data, Error>) -> Void)) {
        progress.completedUnitCount = 1
        guard NetworkMonitor.shared.isConnected else {
            let apiCallError = APICallError(kind: .connectionLost, response: nil)
            DispatchQueue.main.async {
                completion(.failure(apiCallError))
            }
            return
        }
        guard let url = URL(string: apiURLString) else {return}
        progress.completedUnitCount += 1
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {[weak self] (data, response, error) in
            if error != nil {
                let apiCallError = APICallError(kind: .dataTaskFailed, response: response)
                DispatchQueue.main.async {
                    completion(.failure(apiCallError))
                }
            } else {
                self?.result = self?.parseJSON(data)
                self?.progress.completedUnitCount += 1
                if self?.result != nil {
                    DispatchQueue.main.async {
                        completion(.success(data!))
                    }
                } else {
                    let apiCallError = APICallError(kind: .noDataRetrieved, response: nil)
                    DispatchQueue.main.async {
                        completion(.failure(apiCallError))
                    }
                }
            }
        }
        task.resume()
    }

    private func parseJSON(_ data: Data?) -> [APIModel]? {
        progress.completedUnitCount += 1
        guard let safeData = data else {return nil}
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let decodedData = try decoder.decode([APIModel].self, from: safeData)
            return decodedData
        } catch {
            print("Error decoding data: \(error.localizedDescription)")
            return nil
        }
    }
}
