//
//  PostDTO.swift
//  KataTODOAPIClient
//
//  Created by Antonio Calvo on 22/04/2017.
//  Copyright © 2017 Karumi. All rights reserved.
//

import Foundation

public struct PostDTO {
    
    public let userId: String
    public let id: String
    public let title: String
    public let body: String
    
    public init(userId: String, id: String, title: String, body: String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
    
}
