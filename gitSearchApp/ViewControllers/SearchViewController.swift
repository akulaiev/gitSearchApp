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
    var searchResults: [RepositoryInfo] = []
    var errorMessage: String = ""
    let githubClient = GithubAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text ?? "no text here")
        githubClient.getRepositoriesForSearchQuery(query: searchBar.text ?? "no text here") { (response, error) in
            if response.count > 0 {
                print(response)
                self.searchResults = response
            }
            else {
                print(error)
                self.errorMessage = error
            }
            self.searchResultsTableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count > 0 {
            return searchResults.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")!
        if searchResults.count > indexPath.row {
            cell.textLabel?.text = searchResults[indexPath.row].name
        }
        else {
            cell.textLabel?.text = errorMessage
        }
        return cell
    }
    
}
