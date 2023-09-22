//
//  UserModel.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import Foundation

struct UserModel: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
    let token: String

    enum CodingKeys: String, CodingKey {
        case id, username, email, firstName, lastName, gender, image, token
    }

    init(id: Int = 0, username: String = "", email: String = "", firstName: String = "", lastName: String = "", gender: String = "", image: String = "", token: String = "") {
        self.id = id
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.image = image
        self.token = token
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        gender = try container.decode(String.self, forKey: .gender)
        image = try container.decode(String.self, forKey: .image)
        token = try container.decode(String.self, forKey: .token)
    }
}
