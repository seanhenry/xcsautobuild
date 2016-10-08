//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol BotTemplateCreatingInteractorOutput: class {
    func didCreateTemplate()
    func didFailToFindTemplate()
}

protocol BotNamable {
    var botName: String { get set }
}

class BotTemplateCreatingInteractor: Command, BotNamable {

    private let botTemplatesFetcher: BotTemplatesFetcher
    private let botTemplateSaver: BotTemplateSaver
    weak var output: BotTemplateCreatingInteractorOutput?
    var botName = ""

    init(botTemplatesFetcher: BotTemplatesFetcher, botTemplateSaver: BotTemplateSaver) {
        self.botTemplatesFetcher = botTemplatesFetcher
        self.botTemplateSaver = botTemplateSaver
    }

    func execute() {
        botTemplatesFetcher.fetchBotTemplates { [weak self] templates in
            self?.handle(fetchedTemplates: templates)
        }
    }

    private func handle(fetchedTemplates templates: [BotTemplate]) {
        let matching = templates.filter { $0.name == botName }.first
        guard let template = matching else {
            output?.didFailToFindTemplate()
            return
        }
        botTemplateSaver.save(template)
        output?.didCreateTemplate()
    }
}
