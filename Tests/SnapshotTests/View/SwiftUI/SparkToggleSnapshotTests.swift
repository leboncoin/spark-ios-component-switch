//
//  SparkToggleSnapshotTests.swift
//  SparkSwitchSnapshotTests
//
//  Created by robin.lemaire on 11/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import SparkSwitch
@_spi(SI_SPI) import SparkCommon
@_spi(SI_SPI) import SparkCommonTesting
@_spi(SI_SPI) import SparkCommonSnapshotTesting
@_spi(SI_SPI) import SparkThemingTesting
import SparkTheming
import SparkTheme
import SwiftUI

final class SparkToggleSnapshotTests: SwiftUIComponentSnapshotTestCase {

    // MARK: - Properties

    private let theme: Theme = SparkTheme.shared

    // MARK: - Tests

    func test() throws {
        let forDocumentation = false

        let scenarios = SwitchScenarioSnapshotTests.allCases(forDocumentation: forDocumentation)

        for scenario in scenarios {
            let configurations: [SwitchConfigurationSnapshotTests] = try scenario.configuration()

            for configuration in configurations {
                let view = self.component(configuration: configuration)
                    .disabled(!configuration.status.isEnabled)
                    .style(forDocumentation: forDocumentation)

                self.assertSnapshot(
                    matching: view,
                    modes: configuration.modes,
                    sizes: configuration.sizes,
                    testName: configuration.testName()
                )
            }
        }
    }

    @ViewBuilder func component(configuration: SwitchConfigurationSnapshotTests) -> some View {
        if let text = configuration.content.text {
            SparkToggle(
                text,
                theme: self.theme,
                isOn: .constant(configuration.value.isOn),
                onIcon: .on,
                offIcon: .off
            )
        } else if configuration.content == .other {
            SparkToggle(
                theme: self.theme,
                isOn: .constant(configuration.value.isOn),
                onIcon: .on,
                offIcon: .off,
                label: {
                    VStack(alignment: .leading) {
                        Text("Welcome")
                        Text("on Spark's Toggle")
                            .foregroundColor(.orange)
                    }
                }
            )
        } else {
            SparkToggle(
                theme: self.theme,
                isOn: .constant(configuration.value.isOn),
                onIcon: .on,
                offIcon: .off
            )
        }
    }
}

// MARK: - Extension

private extension Image {
    static var on = Image(systemName: "checkmark")
    static var off = Image(systemName: "xmark")
}

private extension View {

    @ViewBuilder
    func style(forDocumentation: Bool) -> some View {
        if forDocumentation {
            self.padding(4)
                .background(.background)
                .fixedSize()
        } else {
            self.background(Color(uiColor: .secondarySystemBackground))
                .padding(SwitchSnapshotConstants.padding)
                .fixedSize()
                .background(.background)
        }
    }
}
