//
//  APIResponseModel.swift
//  WisdomLeafTask
//
//  Created by Sai Balaji on 25/06/24.
//

import Foundation


struct Image: Codable {
    var isChecked = false 
    let id, author: String?
    let width, height: Int?
    let url, downloadURL: String?

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
