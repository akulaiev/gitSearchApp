//
//  NetworkingTasks.swift
//  OnTheMap
//
//  Created by Anna KULAIEVA on 10/24/19.
//  Copyright © 2019 Anna Kulaieva. All rights reserved.
//

import Foundation
import UIKit

class NetworkingTasks {
    
    //Static function to perform all kinds of networking requests
    @discardableResult class func taskForRequest(url: URL, completion: @escaping (GithubSearchResponse?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GithubSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    // Downloads images from URL
    class func downloadImage(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                completion(image, nil)
            }
        }
        task.resume()
    }
}
