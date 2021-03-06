
import Foundation

class DecisionTable: NSObject, SlimDecisionTable {

    func setUp() {
    }

    func tearDown() {
    }

    func test() {
    }

    final func reset() {
        createFiles()
    }

    final func execute() {
        setUp()
        test()
        tearDown()
        removeFiles()
    }

    private func createFiles() {
        create(directory: URL(fileURLWithPath: testGitPath))
    }

    private func create(directory: URL) {
        _ = try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
    }

    private func removeFiles() {
        _ = try? FileManager.default.removeItem(at: URL(fileURLWithPath: testPath))
    }
}
