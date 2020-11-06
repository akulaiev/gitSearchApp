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
    @IBOutlet weak var downloadIndicator: UIActivityIndicatorView!
    var searchResults: [RepositoryInfo] = []
    var userImages: [UIImage] = []
    let githubClient = GithubAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.isHidden = true
        downloadIndicator.isHidden = true
    }

    fileprivate func updateInterface(isDownloading: Bool) {
        downloadIndicator.isHidden = !isDownloading
        searchResultsTableView.isHidden = isDownloading
        if isDownloading {
            downloadIndicator.startAnimating()
        }
        else {
            downloadIndicator.stopAnimating()
        }
    }
    
    fileprivate func displayError(_ error: String) {
        updateInterface(isDownloading: false)
        searchResults = []
        searchResultsTableView.reloadData()
        HelperMethods.showFailureAlert(title: "An error has occured", message: error.description, controller: self)
    }
    
    fileprivate func formatNumber(_ originalNumberString: String) -> String {
        if var originalNumber = Float(originalNumberString) {
            if originalNumber >= 1000 {
                originalNumber /= 1000
                return String(format: "%.1f", originalNumber) + "k"
            }
        }
        return originalNumberString
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateInterface(isDownloading: true)
        githubClient.getRepositoriesForSearchQuery(query: searchBar.text ?? "no text here") { (response, error) in
            if response.count > 0 {
                self.searchResults = response
                self.githubClient.downloadUserImages(fetchedRepositories: self.searchResults) { (images, error) in
                    if images.count > 0 {
                        self.userImages = images
                    }
                    else {
                        self.displayError(error)
                    }
                    self.updateInterface(isDownloading: false)
                    self.searchResultsTableView.reloadData()
                }
            }
            else {
                self.displayError(error)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") as! SearchResultsTableViewCell
        cell.starImage.isHidden = true
        cell.ratingLabel.isHidden = true
        if searchResults.count > indexPath.row {
            cell.repositoryNameLabel.text = searchResults[indexPath.row].fullName
            cell.starImage.isHidden = false
            cell.ratingLabel.isHidden = false
            cell.ratingLabel.text = formatNumber("\(searchResults[indexPath.row].stargazersCount)")
            cell.userPicImageView.image = HelperMethods.resizeImage(originalImage: userImages[indexPath.row], targetHeight: UIScreen.main.bounds.height / 10)
        }
        return cell
    }
    
}
