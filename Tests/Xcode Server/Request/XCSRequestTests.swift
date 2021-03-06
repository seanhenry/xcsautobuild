
import XCTest
@testable import xcsautobuild

class XCSRequestTests: XCTestCase {
    
    var request: TestXCSRequest!
    var mockedNetwork: MockHTTPRequestSender { return request.mockedRequestSender }
    
    override func setUp() {
        super.setUp()
        request = TestXCSRequest()
    }
    
    // MARK: - send
    
    func test_send_shouldCreateRequest() {
        send()
        XCTAssert(request.didCreateRequest)
    }

    func test_send_shouldNotParseResponse_whenNoResponseData() {
        send()
        XCTAssertFalse(request.didParse)
    }

    func test_send_shouldParseResponse_whenResponseData() {
        stubResponse()
        send()
        XCTAssert(request.didParse)
    }

    func test_send_shouldCallCompletion() {
        var didCallCompletion = false
        request.send("") { _ in
            didCallCompletion = true
        }
        XCTAssert(didCallCompletion)
    }

    func test_send_shouldCompleteWithNil_whenNoData() {
        stubResponse(data: nil)
        XCTAssertNil(send())
    }

    func test_send_shouldCompleteWithNil_whenNoStatusCode() {
        stubResponse(statusCode: nil)
        XCTAssertNil(send())
    }

    // MARK: - send (sync)

    func test_sendSync_shouldCreateRequest() {
        sendSync()
        XCTAssert(request.didCreateRequest)
    }

    func test_sendSync_shouldNotParseResponse_whenNoResponseData() {
        sendSync()
        XCTAssertFalse(request.didParse)
    }

    func test_sendSync_shouldParseResponse_whenResponseData() {
        stubResponse()
        sendSync()
        XCTAssert(request.didParse)
    }

    func test_sendSync_shouldBlockUntilFinished() {
        let parsed = "hello".data(using: String.Encoding.utf8)!
        mockedNetwork.stubbedResponse = parsed
        mockedNetwork.stubbedStatusCode = 200
        let response = request.send("")
        XCTAssertEqual(response?.data, parsed)
    }

    // MARK: - Helpers

    @discardableResult func send() -> XCSResponse<Data>? {
        var response: XCSResponse<Data>?
        request.send("") { r in
            response = r
        }
        return response
    }
    
    @discardableResult func sendSync() -> XCSResponse<Data>? {
        return request.send("")
    }
    
    func stubResponse(data: Data? = Data(), statusCode: Int? = 200) {
        mockedNetwork.stubbedResponse = data
        mockedNetwork.stubbedStatusCode = statusCode
    }

    class TestXCSRequest: XCSRequest {

        var mockedRequestSender = MockHTTPRequestSender()
        var requestSender: HTTPRequestSender {
            return mockedRequestSender
        }

        var didCreateRequest = false
        func createRequest(_ data: String) -> HTTPRequest {
            didCreateRequest = true
            return testRequest
        }

        var didParse = false
        func parse(response data: Data) -> Data? {
            didParse = true
            return data
        }
    }
}
