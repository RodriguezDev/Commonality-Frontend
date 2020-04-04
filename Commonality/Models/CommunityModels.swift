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
    var resultCode: Int
    var message: String
    var communities: [Community]
}

struct Community: Codable {
    var name: String
    var description: String
    var members: Int
    var type: Int
    var status: Int
}

/**
    Takes a JSON dictionary and converts it into the data structures listed above
    I really need a parser.
 */
func parseCommunityResponse(JSON: NSDictionary) -> CommunityResponse {
    var cr = CommunityResponse(resultCode: JSON["resultCode"] as! Int, message: JSON["message"] as! String, communities: [])
    
    if (cr.resultCode > 0) {
        // The request was successful.
        let dataArray = JSON["communities"] as! NSArray;

        for item in dataArray { // loop through data items
            let obj = item as! NSDictionary
            let community = Community(name: obj["name"] as! String, description: obj["description"] as! String, members: obj["members"] as! Int, type: obj["type"] as! Int, status: obj["status"] as! Int)
            
            cr.communities.append(community)
        }
    }
    
    return cr
}
