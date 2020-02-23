//
//  CommunityModels.swift
//  Commonality
//
//  Created by Chris Rodriguez on 2/23/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation
import Alamofire

struct CommunityResponse: Codable {
    var resultCode: Int?
    var message: String?
    var communities: [Community]
}

struct Community: Codable {
    var name: String?
    var description: String?
    var members: Int?
    var type: Int?
    var status: Int?
}
