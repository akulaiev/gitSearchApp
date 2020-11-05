//
//  SearchViewController.swift
//  gitSearchApp
//
//  Created by Anna Kulaieva on 05.11.2020.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var githubSearchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    var searchResults: GithubSearchResponse?
    var errorMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text ?? "no text here")
        GithubAPIClient.getRepositoriesForSearchQuery(query: searchBar.text ?? "no text here") { (response, error) in
            if let response = response {
                print(response)
                self.searchResults = response
            }
            else {
                print(error!)
            }
            self.searchResultsTableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchResults = searchResults else {
            return 1
        }
        return searchResults.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")!
        if let searchResults = searchResults, searchResults.totalCount >= indexPath.row {
            cell.textLabel?.text = searchResults.items[indexPath.row].fullName
        }
        else {
            cell.textLabel?.text = errorMessage
        }
        return cell
    }
    
}
