//
//  GithubAPIClient.swift
//  gitSearchApp
//
//  Created by Anna Kulaieva on 05.11.2020.
//

import Foundation

class GithubAPIClient {
    
    let searchBaseString: String = "https://api.github.com/search/repositories?"
    let numOnPage = 3
    var queue: DispatchQueue = DispatchQueue.main
    let searchGroup = DispatchGroup()
    
    fileprivate func taskForRequest(request: URLRequest, completion: @escaping ([RepositoryInfo], String) -> Void) {
        queue.async(group: searchGroup) {
            print(request)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(GithubSearchResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(response.items, "")
                        }
                    }
                    catch {
                        DispatchQueue.main.async {
                            completion([], error.localizedDescription)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion([], error?.localizedDescription ?? "An error has occured")
                    }
                }
            }
            task.resume()
        }
    }
    
    func getRepositoriesForSearchQuery(query: String, completion: @escaping ([RepositoryInfo], String) -> Void) {
        var fullResponse: [RepositoryInfo] = []
        var returnError: String = ""
        guard var url = URLComponents(string: searchBaseString) else {
            completion([], "An error has occured")
            return
        }
        
        url.queryItems = [
            URLQueryItem(name: "q", value: "\(query)+in:name"),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "per_page", value: "\(numOnPage)")]
        for i in 1...2 {
            var currentUrl = url
            currentUrl.queryItems?.append(URLQueryItem(name: "page", value: "\(i)"))
            var request = URLRequest(url: currentUrl.url!)
            request.httpMethod = "GET"
            searchGroup.enter()
            taskForRequest(request: request) { (result, error) in
                if result.count > 0 {
                    fullResponse += result
                }
                else {
                    returnError = error
                }
                self.searchGroup.leave()
            }
        }
        searchGroup.notify(queue: .main) {
            print(fullResponse)
            completion(fullResponse, returnError)
        }
    }
}
