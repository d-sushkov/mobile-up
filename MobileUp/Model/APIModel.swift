//
//  APIModel.swift
//  MobileUp
//
//  Created by Denis Sushkov on 18.10.2020.
//

import Foundation

/// APIModel: Codable
/// User: Codable
/// Message: Codable
///
/// Data structures for decoding
/// message API call result
struct APIModel: Codable {
    let user: User
    let message: Message
}

struct User: Codable {
    let nickname: String
    let avatarURL: String
    
    private enum CodingKeys: String, CodingKey {
        case nickname, avatarURL = "avatar_url"
    }
}

struct Message: Codable {
    let text: String
    let receivingDate: String
    
    private enum CodingKeys: String, CodingKey {
        case text, receivingDate = "receiving_date"
    }
}
