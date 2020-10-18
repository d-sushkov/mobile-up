//
//  APIManager.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import Foundation

protocol APIManagerDelegate: AnyObject {
    func managerDidUpdateData()
    func managerDidFailWithError(response: URLResponse?)
    func managerDidLoseConnection()
}

class APIManager {
    
    weak var delegate: APIManagerDelegate?
    
    var result: [APIModel]?
    
    private let apiURLString = "https://s3-eu-west-1.amazonaws.com/builds.getmobileup.com/storage/MobileUp-Test/api.json"
    
    /// fetchMessageData()
    ///
    /// Checks network connection,
    /// creates a URL using given string
    /// and calls a function to perform request with it
    func fetchMessageData() {
        if NetworkMonitor.shared.isConnected {
            if let url = URL(string: apiURLString) {
                performAPIRequest(with: url)
            }
        } else {
            delegate?.managerDidLoseConnection()
        }
    }
    
    /// performRequest(with url: URL)
    ///
    /// Uses given URL to create a URL session data task,
    /// starts the task and calls a function to parse resulting JSON
    /// if succeeds
    ///
    /// Parameters   : url: URL for API call
    private func performAPIRequest(with url: URL) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {[weak self] (data, response, error) in
            if error != nil {
                self?.delegate?.managerDidFailWithError(response: response)
                print("Error retrieving API data: \(error!.localizedDescription)")
            } else {
                self?.result = self?.parseJSON(data)
                self?.delegate?.managerDidUpdateData()
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
        guard let safeData = data else {return nil}
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([APIModel].self, from: safeData)
            return decodedData
        } catch {
            delegate?.managerDidFailWithError(response: nil)
            print("Error decoding data: \(error.localizedDescription)")
            return nil
        }
    }
}
