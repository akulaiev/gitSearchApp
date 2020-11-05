//
//  GithubSearchResponse.swift
//  gitSearchApp
//
//  Created by Anna Kulaieva on 05.11.2020.
//

import Foundation

// MARK: - GithubSearchResponse
struct GithubSearchResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [RepositoryInfo]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Item
struct RepositoryInfo: Codable {
    let id: Int
    let name, fullName: String
    let itemPrivate: Bool
    let owner: Owner
    let itemDescription: String
    let score: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case itemPrivate = "private"
        case owner
        case itemDescription = "description"
        case score
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
