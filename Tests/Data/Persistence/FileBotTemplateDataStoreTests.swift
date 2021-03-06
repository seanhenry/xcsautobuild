
import XCTest
@testable import xcsautobuild

class FileBotTemplateDataStoreTests: XCTestCase {
    
    var persister: FileBotTemplateDataStore!
    var mockedDataWriter: MockDataWriter!
    var mockedDataLoader: MockDataLoader!
    let file = "test file"
    
    override func setUp() {
        super.setUp()
        mockedDataWriter = MockDataWriter()
        mockedDataLoader = MockDataLoader()
        persister = FileBotTemplateDataStore(file: file, dataLoader: mockedDataLoader, dataWriter: mockedDataWriter)
    }
    
    // MARK: - save
    
    func test_save_shouldWriteTemplateJSONToFile() {
        let template = BotTemplate(name: "", data: Data())
        persister.save(template)
        XCTAssert(mockedDataWriter.didWriteToFile)
        XCTAssertEqual(mockedDataWriter.invokedPath, file)
    }

    // MARK: - load

    func test_load_shouldReadTemplateFromFile() {
        mockedDataLoader.stubbedData = testBotTemplate.data
        XCTAssertEqual(persister.load(), testBotTemplate)
    }

    func test_load_shouldReturnNil_whenNoFile() {
        XCTAssertNil(persister.load())
    }

    func test_load_shouldReturnNil_whenNoBotNameInData() {
        mockedDataLoader.stubbedData = Data()
        XCTAssertNil(persister.load())
    }
}
