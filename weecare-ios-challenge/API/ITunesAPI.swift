//
//  ITunesAPI.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

let baseURL = "https://rss.itunes.apple.com"

final class ITunesAPI {
    
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func getTopAlbums(limit: Int = 10, filter: TopAlbumsFilter = .comingSoon, completion: @escaping (Result<AlbumFeed, Error>) -> ())  {
        let request: APIRequest
        switch filter {
        case .comingSoon:
            request = APIRequest(url: "\(baseURL)/api/v1/us/apple-music/coming-soon/all/\(limit)/explicit.json")
        case .hotTracks:
            request = APIRequest(url: "\(baseURL)/api/v1/us/apple-music/hot-tracks/all/\(limit)/explicit.json")
        case .newReleases:
            request = APIRequest(url: "\(baseURL)/api/v1/us/apple-music/new-releases/all/\(limit)/explicit.json")
        case .topAlbums:
            request = APIRequest(url: "\(baseURL)/api/v1/us/apple-music/top-albums/all/\(limit)/explicit.json")
        case .topSongs:
            request = APIRequest(url: "\(baseURL)/api/v1/us/apple-music/top-songs/all/\(limit)/explicit.json")
        }
        network.requestObject(request, completion: completion)
    }
}
