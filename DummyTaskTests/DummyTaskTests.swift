//
//  DummyTaskTests.swift
//  DummyTaskTests
//
//  Created by Mac on 21/09/2023.
//

import XCTest
import Combine
@testable import DummyTask

final class DummyTaskTests: XCTestCase {

    
    var apiClient: APIManager!
    private let apiManager = APIManager()
    override func setUp() {
        super.setUp()
        // Initialize the API client with a mock URLSession or test-specific configuration
        apiClient = APIManager()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }

    func testFetchPosts() {
        let expectation = XCTestExpectation(description: "Fetch posts")
        
        let param = ["limit":"10","skip":"0"]
        let endPoint = "posts"
         var cancellables = Set<AnyCancellable>()
        apiClient.request(endpoint: endPoint, httpMethod: .GET, parameters: param)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Failed to fetch posts: \(error)")
                default:
                    break;
                }
            } receiveValue: { response in
                let data: postResponseModel = response.value
                XCTAssertNotNil(data.posts)
                XCTAssertEqual(data.posts.count, 10)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout:15.0)
    }
    
    func testParsePost() {
        let json = """
        {
            "id": 1,
            "title": "Test Post",
            "body": "This is a test post",
        }
        """
        
        let data = json.data(using: .utf8)!
        let post = try? JSONDecoder().decode(Post.self, from: data)
        
        XCTAssertNotNil(post)
        XCTAssertEqual(post?.id, 1)
        XCTAssertEqual(post?.title, "Test Post")
    }

}
