//
//  GithubAPIClient.swift
//  gitSearchApp
//
//  Created by Anna Kulaieva on 05.11.2020.
//

import Foundation

class GithubAPIClient {
    static let searchBaseString: String = "https://api.github.com/search/repositories?q="
    
    class func getRepositoriesForSearchQuery(query: String, completion: @escaping (GithubSearchResponse?, String?) -> Void) {
        NetworkingTasks.taskForRequest(url: URL(string: GithubAPIClient.searchBaseString + query)!) { (response, error) in
            DispatchQueue.main.async {
                guard let response = response else {
                    completion(nil, error?.localizedDescription ?? "An error occured")
                    return
                }
                completion(response, nil)
            }
        }
    }
}
