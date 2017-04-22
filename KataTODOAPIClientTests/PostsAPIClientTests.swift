//
//  PostsAPIClientTests.swift
//  KataTODOAPIClient
//
//  Created by Antonio Calvo on 22/04/2017.
//  Copyright © 2017 Karumi. All rights reserved.
//

import Foundation
import Nocilla
import Nimble
import XCTest
import Result
@testable import KataTODOAPIClient

class PostsAPIClientTests: NocillaTestCase {
    
    fileprivate let apiClient = PostsAPIClient()
    
    func testParsesTasksProperlyGettingAllTheTasks() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/posts")
            .andReturn(200)?
            .withBody(fromJsonFile("getPostsResponse"))
        
        var result: Result<[PostDTO], PostsAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }
        
        expect(result?.value?.count).toEventually(equal(2))
        assertPostContainsExpectedValues((result?.value?[0])!)
    }

    fileprivate func assertPostContainsExpectedValues(_ post: PostDTO) {
        expect(post.id).to(equal("1"))
        expect(post.userId).to(equal("1"))
        expect(post.title).to(equal("delectus aut autem"))
        expect(post.body).to(equal("lorum impsu"))
    }
}