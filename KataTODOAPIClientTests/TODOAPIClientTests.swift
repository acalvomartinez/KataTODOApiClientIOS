//
//  TODOAPIClientTests.swift
//  KataTODOAPIClient
//
//  Created by Pedro Vicente Gomez on 12/02/16.
//  Copyright © 2016 Karumi. All rights reserved.
//

import Foundation
import Nocilla
import Nimble
import XCTest
import Result
@testable import KataTODOAPIClient

class TODOAPIClientTests: NocillaTestCase {

    fileprivate let apiClient = TODOAPIClient()
    fileprivate let anyTask = TaskDTO(userId: "1", id: "2", title: "Finish this kata", completed: true)

    func testSendsContentTypeHeader() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
            .withHeaders(["Accept": "application/json", "Accept-Language": "en-us", "Content-Type": "application/json"])?
            .andReturn(200)

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result).toEventuallyNot(beNil())
    }

    func testParsesTasksProperlyGettingAllTheTasks() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
            .andReturn(200)?
            .withBody(fromJsonFile("getTasksResponse"))

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result?.value?.count).toEventually(equal(200))
        assertTaskContainsExpectedValues((result?.value?[0])!)
    }

    func testReturnsNetworkErrorIfThereIsNoConnectionGettingAllTasks() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
            .andFailWithError(NSError.networkError())

        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { response in
            result = response
        }

        expect(result?.error).toEventually(equal(TODOAPIClientError.networkError))
    }
    
    func testReturnsEmptyListIfResultIsEmpty() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
            .andReturn(200)?
            .withBody(fromJsonFile("emptyResult"))
        
        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { (response) in
            result = response
        }
        
        expect(result?.value).toEventuallyNot(beNil())
    }
    
    func testReturnsErrorIfServerReturn404Error() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos")
            .andReturn(404)
        
        var result: Result<[TaskDTO], TODOAPIClientError>?
        apiClient.getAllTasks { (response) in
            result = response
        }
        
        expect(result?.error).toEventually(equal(TODOAPIClientError.itemNotFound))
    }

    func testReturnsTaskProperllyGettingATask() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos/1")
            .andReturn(200)?
            .withBody(fromJsonFile("getTaskByIdResponse"))
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }
        
        expect(result?.value).toEventuallyNot(beNil())
        assertTaskContainsExpectedValues((result?.value)!)
    }
    
    func testReturnsNotFoundIfTaskNotExists() {
        stubRequest("GET", "http://jsonplaceholder.typicode.com/todos/1")
            .andReturn(404)
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.getTaskById("1") { response in
            result = response
        }
        
        expect(result?.error).toEventually(equal(TODOAPIClientError.itemNotFound))
    }
    
    func testAddTaskProperlly() {
        stubRequest("POST", "http://jsonplaceholder.typicode.com/todos")
            .andReturn(201)?
            .withBody(fromJsonFile("addTaskToUserResponse"))
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "title", completed: false) { (response) in
            result = response
        }
        
        expect(result?.value).toEventuallyNot(beNil())
        assertTaskContainsExpectedValues((result?.value)!)
    }
    
    func testReturnsErrorWhenServerCrash() {
        stubRequest("POST", "http://jsonplaceholder.typicode.com/todos")
            .andReturn(500)
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "title", completed: false) { (response) in
            result = response
        }
        
        expect(result?.error).toEventually(equal(TODOAPIClientError.unknownError(code: 500)))
    }
    
    func testRecivesTheSameThatIsSendInAddTask() {
        stubRequest("POST", "http://jsonplaceholder.typicode.com/todos")
            .withBody(fromJsonFile("addTaskToUserRequest"))?
            .andReturn(201)?
            .withBody(fromJsonFile("addTaskToUserResponse"))
        
        var result: Result<TaskDTO, TODOAPIClientError>?
        apiClient.addTaskToUser("1", title: "Finish this kata", completed: false) { (response) in
            result = response
        }
        
        expect(result?.value).toEventuallyNot(beNil())
    }
    
    
    fileprivate func assertTaskContainsExpectedValues(_ task: TaskDTO) {
        expect(task.id).to(equal("1"))
        expect(task.userId).to(equal("1"))
        expect(task.title).to(equal("delectus aut autem"))
        expect(task.completed).to(beFalse())
    }

}
