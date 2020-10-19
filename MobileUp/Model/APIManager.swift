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
    
    func makeAPICall(completion: @escaping ((Result<Data, Error>) -> Void)) {
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
                print("Error retrieving API data: \(error!.localizedDescription)")
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
    
    /// parseJSON(_ data: Data?l) -> [APIModel]?
    ///
    /// Decodes given data
    ///
    /// Parameters   : data: data received from API call
    ///
    /// Return Value : [APIModel]?: decoded data (if succeded) or nil
    private func parseJSON(_ data: Data?) -> [APIModel]? {
        progress.completedUnitCount += 1
        guard let safeData = data else {return nil}
        let decoder = JSONDecoder()
        do {
            var decodedData = try decoder.decode([APIModel].self, from: safeData)
            for i in 0..<decodedData.count {
                decodedData[i].message.shownDate = Date().convertToDate(string: decodedData[i].message.receivingDate)
            }
            return decodedData
        } catch {
            print("Error decoding data: \(error.localizedDescription)")
            return nil
        }
    }
}
