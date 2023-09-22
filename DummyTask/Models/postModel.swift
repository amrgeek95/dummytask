//
//  postModel.swift
//  DummyTask
//
//  Created by Mac on 21/09/2023.
//

import Foundation

struct postResponseModel : Codable {
    let posts : [Post]
    var total: Int = 0
}

struct Post: Identifiable, Codable {
    let id: Int
    let title: String
    let body: String
}
