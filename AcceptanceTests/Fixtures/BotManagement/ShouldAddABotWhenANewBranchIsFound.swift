
import Foundation

@objc(ShouldAddABotWhenANewBranchIsFound)
class ShouldAddABotWhenANewBranchIsFound: DecisionTable, GitFixture {

    // MARK: - Input
    var branches: String!
    var branchesArray: [String] {
        return commaSeparatedList(from: branches)
    }

    // MARK: - Output
    var numberOfCreatedBots: NSNumber!

    // MARK: - Test
    var network: MockNetwork!
    var gitBuilder: GitBuilder!
    var interactor: BotSyncingInteractor!

    override func setUp() {
        numberOfCreatedBots = nil
        FileBotTemplateDataStore(file: testTemplateFile).save(testBotTemplate)
        network = MockNetwork()
        network.expectDuplicateBot(id: testTemplateBotID)
        setUpGit(branches: branchesArray)
        interactor = BotSyncingInteractor(
            branchFetcher: testGitBranchFetcher,
            botSynchroniser: testBotSynchroniser,
            branchFilter: IgnoreMasterBranchFilter(),
            botDataStore: PlistBotDataStore(file: testDataStoreFile)
        )
    }

    override func test() {
        interactor.execute()
        waitUntil(network.duplicateBotCount != 0)
        numberOfCreatedBots = network.duplicateBotCount as NSNumber
    }
}
