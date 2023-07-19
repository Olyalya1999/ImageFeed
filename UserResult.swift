//
//  UserResult.swift
//  ImageFeed
//
//  Created by Olya on 29.06.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
