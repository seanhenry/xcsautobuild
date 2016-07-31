//
//  TestHelpers.swift
//
//
//

import Foundation
import XCTest
@testable import xcsautobuild

private func createBot() -> Bot {
    let location = Bot.Configuration.Blueprint.Location(branchName: "master")
    let repo = Bot.Configuration.Blueprint.Repository(
        id: testRepoID,
        url: "https://xcs-server.local/git/xcsautobuild.git",
        fingerprint: testRepoFingerprint
    )
    let blueprint = Bot.Configuration.Blueprint(
        location: location,
        projectName: "xcsautobuild",
        projectPath: "xcsautobuild.xcodeproj",
        authenticationStrategy: .basic("sean", "password"),
        repository: repo
    )
    let before = Bot.Configuration.Trigger(
        phase: .before,
        name: "Before Trigger",
        scriptBody: "echo \"hello world!\""
    )
    let after = Bot.Configuration.Trigger(
        phase: .after([.onWarnings, .onSuccess, .onAnalyzerWarnings]),
        name: "After Trigger",
        scriptBody: "echo \"fancy seeing you here\""
    )
    let configuration = Bot.Configuration(
        schedule: .commit, schemeName: "xcsautobuild_macOS",
        builtFromClean: .never,
        performsAnalyzeAction: true,
        performsTestAction: .no,
        exportsProductFromArchive: true,
        triggers: [before, after],
        sourceControlBlueprint: blueprint
    )
    return Bot(name: "I am a bot", configuration: configuration)
}

let testRepoFingerprint = "93138D460F513226B44C11D1DC747F2BE36A21CE"
let testRepoID = "C214B4F4246A49E51CAE71AA5C1349A716302EB4"
let testBot = createBot()
let testEndpoint = "https://seans-macbook-pro-2.local:20343/api/"
let testRequest = HTTPRequest(url: "https://test.com", method: .get, jsonBody: [:])
let testBranch = Branch(name: "test")

func Assert(@autoclosure expression: () throws -> BooleanType?, @autoclosure _ message: () -> String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssert(try expression() ?? false, message, file: file, line: line)
}