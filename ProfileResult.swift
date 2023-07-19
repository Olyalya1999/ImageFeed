//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Olya on 21.06.2023.
//

import Foundation

struct ProfileResult:Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
