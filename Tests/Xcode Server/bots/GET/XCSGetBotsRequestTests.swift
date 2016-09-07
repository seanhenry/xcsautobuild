//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class XCSGetBotsRequestTests: XCTestCase {
    
    var request: XCSGetBotsRequest!
    var response: NSData!
    
    override func setUp() {
        super.setUp()
        request = XCSGetBotsRequest(network: MockNetwork())
    }

    // MARK: - createRequest

    func test_createRequest() {
        let expectedURL = self.request.endpoint + "bots"
        let request = self.request.createRequest()
        XCTAssertEqual(request.method, HTTPMethod.get)
        XCTAssertEqual(request.url, expectedURL)
        XCTAssertNil(request.jsonBody)
    }

    // MARK: - parse

    func test_parse_shouldReturnEmptyArray_whenNoBots() {
        stubArrayResponse([])
        Assert(parse()?.isEmpty)
    }

    func test_parse_shouldReturnBot_whenValidBot() {
        stubArrayResponse([["_id": "123", "name": "my bot"]])
        XCTAssertEqual(parse()?.count, 1)
    }

    func test_parse_shouldReturnBots_whenValidBots() {
        stubArrayResponse([["_id": "123", "name": "my bot"], ["_id": "456", "name": "my bot 2"]])
        XCTAssertEqual(parse()?.count, 2)
    }

    func test_parse_shouldReturnNil_whenInvalidBots() {
        stubArrayResponse([["not valid": "123", "name": "bot"]])
        Assert(parse()?.isEmpty)
        stubArrayResponse([["_id": "123", "not valid": "bot"]])
        Assert(parse()?.isEmpty)
    }

    // MARK: - Helpers

    func parse() -> [RemoteBot]? {
        return request.parse(response: response)
    }

    func stubArrayResponse(array: [AnyObject]) {
        let object = ["results": array]
        let data = try! NSJSONSerialization.dataWithJSONObject(object, options: [])
        response = data
    }
}
