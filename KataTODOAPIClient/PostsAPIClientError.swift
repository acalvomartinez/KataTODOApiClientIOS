//
//  PostAPIClientError.swift
//  KataTODOAPIClient
//
//  Created by Antonio Calvo on 22/04/2017.
//  Copyright © 2017 Karumi. All rights reserved.
//

import Foundation
import Result
import BothamNetworking

public enum PostsAPIClientError: Error {
    
    case networkError
    case itemNotFound
    case unknownError(code: Int)
    
}

extension ResultProtocol where Error == BothamAPIClientError {
    
    func mapErrorToPostsAPIClientError() -> Result<Value, PostsAPIClientError> {
        return mapError { error in
            switch error {
            case BothamAPIClientError.httpResponseError(404, _):
                return PostsAPIClientError.itemNotFound
            case BothamAPIClientError.httpResponseError(let statusCode, _):
                return PostsAPIClientError.unknownError(code: statusCode)
            default:
                return PostsAPIClientError.networkError
            }
        }
    }
}
