//
//  NetworkManager.swift
//  Slang-App
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation

class NetworkManager {
    private let baseURL: String = "http://api.urbandictionary.com/v0"
    private let searchPath: String = "/define?term="
    
    private(set) var dataTask: URLSessionDataTask?
    
    private var isFetching: Bool = false
    
    func getSlanges(query: String, success: @escaping ([Slang]) -> (), failure: @escaping (String) -> ()) {
        let requestURLString: String = baseURL + searchPath + query
        guard
            let appropriateURL = requestURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: appropriateURL)
        else {
            return
        }
        
        isFetching = true
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            self?.isFetching = false
            
            if let error = error {
                DispatchQueue.main.async {
                    failure(error.localizedDescription)
                }
            }
            
            guard let unwrappedData = data else {
                DispatchQueue.main.async {
                    failure("No data has fetched")
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(ResultResponse.self, from: unwrappedData)
                
                DispatchQueue.main.async {
                    success(response.list)
                }
            } catch {
                DispatchQueue.main.async {
                    failure(error.localizedDescription)
                }
            }
            
            self?.dataTask = nil
        }
        
        dataTask.resume()
        self.dataTask = dataTask
    }
    
    func resumeRequest() {
        guard !isFetching else { return }
        dataTask?.resume()
    }
    
    func cancelRequest() {
        guard isFetching else { return }
        dataTask?.cancel()
    }
}
