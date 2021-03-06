
import Foundation
import FlexiJSON

class FileBotTemplateDataStore: DataStore {

    private let file: String
    private let dataLoader: DataLoader
    private let dataWriter: DataWriter

    init(file: String, dataLoader: DataLoader = DefaultDataLoader(), dataWriter: DataWriter = DefaultDataWriter()) {
        self.file = file
        self.dataLoader = dataLoader
        self.dataWriter = dataWriter
    }

    func load() -> BotTemplate? {
        guard let data = dataLoader.loadData(from: file),
              let name = FlexiJSON(data: data)["name"].string else { return nil }
        return BotTemplate(name: name, data: data)
    }

    func save(_ data: BotTemplate) {
        dataWriter.write(data: data.data, toFile: file)
    }
}
