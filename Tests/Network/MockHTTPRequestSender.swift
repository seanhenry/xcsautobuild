
import XCTest
@testable import xcsautobuild

class MockHTTPRequestSender: HTTPRequestSender {

    var didSendRequest = false
    var invokedRequest: HTTPRequest?
    var stubbedResponse: Data?
    var stubbedStatusCode: Int?
    func send(_ request: HTTPRequest, completion: ((Data?, Int?) -> ())?) {
        didSendRequest = true
        invokedRequest = request
        completion?(stubbedResponse, stubbedStatusCode)
    }
}
