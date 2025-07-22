//
//  SwitchConfigurationSnapshotTests.swift
//  SparkSwitchSnapshotTests
//
//  Created by robin.lemaire on 09/10/2024.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

@testable import SparkSwitch
@_spi(SI_SPI) import SparkCommonSnapshotTesting
@_spi(SI_SPI) import SparkCommon
import XCTest

struct SwitchConfigurationSnapshotTests {

    // MARK: - Type Alias

    private typealias Constants = ComponentSnapshotTestConstants

    // MARK: - Properties

    let scenario: SwitchScenarioSnapshotTests

    let value: SwitchValue
    let status: SwitchStatus
    let content: SwitchContentResilience

    let modes: [ComponentSnapshotTestMode]
    let sizes: [UIContentSizeCategory]

    // MARK: - Initialization

    init(
        scenario: SwitchScenarioSnapshotTests,
        value: SwitchValue,
        status: SwitchStatus,
        content: SwitchContentResilience,
        modes: [ComponentSnapshotTestMode] = Constants.Modes.default,
        sizes: [UIContentSizeCategory] = Constants.Sizes.default
    ) {
        self.scenario = scenario
        self.value = value
        self.status = status
        self.content = content
        self.modes = modes
        self.sizes = sizes
    }

    // MARK: - Getter

    func testName() -> String {
        return [
            "\(self.scenario.rawValue)",
            "\(value)" + "Value",
            "\(status)" + "Status",
            "\(content)" + "Content"
        ].joined(separator: "-")
    }
}

// MARK: - Enum

enum SwitchValue: String, CaseIterable {
    case activated
    case deactivated

    var isOn: Bool {
        switch self {
        case .activated: true
        case .deactivated: false
        }
    }
}

enum SwitchStatus: String, CaseIterable {
    case enabled
    case disabled

    var isEnabled: Bool {
        switch self {
        case .enabled: true
        case .disabled: false
        }
    }
}

enum SwitchContentResilience: String, CaseIterable {
    case withoutLabel
    case shortLabel
    case multilineLabel
    case other

    var text: String? {
        switch self {
        case .withoutLabel: nil
        case .shortLabel: "My switch"
        case .multilineLabel: "My switch. Lorem ipsum dolor.\nConsectetur adipiscing elit.\nProin vel metus pretium."
        case .other: nil
        }
    }
}
