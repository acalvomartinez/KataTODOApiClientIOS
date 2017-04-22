//
//  PostsAPIClient.swift
//  KataTODOAPIClient
//
//  Created by Antonio Calvo on 22/04/2017.
//  Copyright © 2017 Karumi. All rights reserved.
//

import Foundation
import BothamNetworking
import Result

open class PostsAPIClient {
    fileprivate let apiClient: BothamAPIClient
    fileprivate let parser: PostDTOJSONParser
    
    public init() {
        self.apiClient = BothamAPIClient(baseEndpoint: PostsAPIClientConfig.baseEndpoint)
        self.apiClient.requestInterceptors.append(DefaultHeadersInterceptor())
        self.parser = PostDTOJSONParser()
    }
    
    open func getAllTasks(_ completion: @escaping (Result<[PostDTO], PostsAPIClientError>) -> Void) {
        apiClient.GET(PostsAPIClientConfig.tasksEndpoint) { result in
            completion(result.mapJSON { json -> [PostDTO] in
                let posts: [PostDTO] = self.parser.fromJSON(json)
                return posts
                }.mapErrorToPostsAPIClientError())
        }
    }
}
