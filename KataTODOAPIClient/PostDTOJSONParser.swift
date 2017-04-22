//
//  PostDTOJSONParser.swift
//  KataTODOAPIClient
//
//  Created by Antonio Calvo on 22/04/2017.
//  Copyright © 2017 Karumi. All rights reserved.
//

import Foundation
import SwiftyJSON

class PostDTOJSONParser {
    
    func fromJSON(_ json: JSON) -> [PostDTO] {
        return json.arrayValue.map { fromJSON($0) }
    }
    
    func fromJSON(_ json: JSON) -> PostDTO {
        return PostDTO(userId: json["userId"].stringValue,
                       id: json["id"].stringValue,
                       title: json["title"].stringValue,
                       body: json["body"].stringValue)
    }
    
}
