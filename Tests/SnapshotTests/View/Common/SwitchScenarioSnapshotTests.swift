//
//  SwitchScenarioSnapshotTests.swift
//  SparkSwitchSnapshotTests
//
//  Created by robin.lemaire on 09/10/2024.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

@testable import SparkSwitch
@_spi(SI_SPI) import SparkCommonSnapshotTesting
@_spi(SI_SPI) import SparkCommon
@_spi(SI_SPI) import SparkCommonTesting
import UIKit
import SwiftUI

enum SwitchScenarioSnapshotTests: String, CaseIterable {
    case test1
    case test2
    case test3
    case test4
    case documentation

    // MARK: - Type Alias

    typealias Constants = ComponentSnapshotTestConstants

    // MARK: - Configurations

    func configuration() throws -> [SwitchConfigurationSnapshotTests] {
        switch self {
        case .test1:
            return self.test1()
        case .test2:
            return self.test2()
        case .test3:
            return self.test3()
        case .test4:
            return self.test4()
        case .documentation:
            return self.documentation()
        }
    }

    // MARK: - Case Iterable

    static func allCases(forDocumentation: Bool = false) -> [Self] {
        forDocumentation ? [.documentation] : Self.allCases.filter { $0 != .documentation }
    }

    // MARK: - Scenarios

    /// Test 1
    ///
    /// Description: To test both values with all status
    ///
    /// Content:
    /// - value : **all**
    /// - status : all**
    /// - content resilience : short label
    /// - mode : light
    /// - a11y size : medium
    private func test1() -> [SwitchConfigurationSnapshotTests] {
        let values = SwitchValue.allCases
        let statutes = SwitchStatus.allCases

        return values.flatMap { value in
            statutes.map { status in
                return .init(
                    scenario: self,
                    value: value,
                    status: status,
                    content: .shortLabel
                )
            }
        }
    }

    /// Test 2
    ///
    /// Description: To test different length of labels
    ///
    /// Content:
    /// - value : activated
    /// - status : enabled
    /// - **content resilience : all**
    /// - mode : light
    /// - a11y size : medium
    private func test2() -> [SwitchConfigurationSnapshotTests] {
        let contentResiliences = SwitchContentResilience.allCases

        return contentResiliences.map { contentResilience in
            return .init(
                scenario: self,
                value: .activated,
                status: .enabled,
                content: contentResilience
            )
        }
    }

    /// Test 3
    ///
    /// Description: To test dark and light mode
    ///
    /// Content:
    /// - value : activated
    /// - status : enabled
    /// - content resilience : short label
    /// - **mode : all**
    /// - a11y size : medium
    private func test3() -> [SwitchConfigurationSnapshotTests] {
        let modes = ComponentSnapshotTestConstants.Modes.all

        return modes.map { mode in
            return .init(
                scenario: self,
                value: .activated,
                status: .enabled,
                content: .shortLabel,
                modes: [mode]
            )
        }
    }

    /// Test 4
    ///
    /// Description: To test a11y sizes
    ///
    /// Content:
    /// - value : activated
    /// - status : enabled
    /// - content resilience : multiline label
    /// - mode : light
    /// - **a11y size : all**
    private func test4() -> [SwitchConfigurationSnapshotTests] {
        let sizes = ComponentSnapshotTestConstants.Sizes.all

        return sizes.map { size in
            return .init(
                scenario: self,
                value: .activated,
                status: .enabled,
                content: .multilineLabel,
                sizes: [size]
            )
        }
    }

    // MARK: - Documentation

    // Used to generate screenshot for Documentation
    private func documentation() -> [SwitchConfigurationSnapshotTests] {
        let contentResiliences = SwitchContentResilience.allCases
        let values = SwitchValue.allCases
        let statutes = SwitchStatus.allCases

        return contentResiliences.flatMap { contentResilience in
            values.flatMap { value in
                statutes.map { status in
                    return .init(
                        scenario: self,
                        value: value,
                        status: status,
                        content: contentResilience,
                        modes: Constants.Modes.all
                    )
                }
            }
        }
    }
}
