//
//  ModelData.swift
//  MiniRumbl
//
//  Created by Anshu Vij on 15/05/21.
//

import Foundation

// MARK: - ModelData
struct ModelData: Codable {
    let title: String
    let nodes: [Node]
}

// MARK: - Node
struct Node: Codable {
    let video: Video
}

// MARK: - Video
struct Video: Codable {
    let encodeURL: String

    enum CodingKeys: String, CodingKey {
        case encodeURL = "encodeUrl"
    }
}
