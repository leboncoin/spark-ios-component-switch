//
//  SparkUISwitchSnapshotTests.swift
//  SparkSwitchSnapshotTests
//
//  Created by robin.lemaire on 11/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import SparkSwitch
@_spi(SI_SPI) import SparkCommonSnapshotTesting
@_spi(SI_SPI) import SparkCommon
@_spi(SI_SPI) import SparkCommonTesting
@_spi(SI_SPI) import SparkThemingTesting
import SparkTheming
import SparkTheme

final class SparkUISwitchSnapshotTests: UIKitComponentSnapshotTestCase {

    // MARK: - Type Alias

    private typealias Constants = SwitchSnapshotConstants

    // MARK: - Properties

    private let theme: Theme = SparkTheme.shared

    // MARK: - Tests

    func test() throws {
        let scenarios = SwitchScenarioSnapshotTests.allCases()

        for scenario in scenarios {
            let configurations: [SwitchConfigurationSnapshotTests] = try scenario.configuration()
            for configuration in configurations {
                let view = SparkUISwitch(
                    theme: self.theme,
                    onIcon: .on,
                    offIcon: .off
                )
                view.isOn = configuration.value.isOn
                view.isEnabled = configuration.status.isEnabled

                if let text = configuration.content.text {
                    view.text = text
                } else if configuration.content == .other {
                    view.attributedText = .init(
                        string: "Welcome\non Spark's Toggle",
                        attributes: [
                            .foregroundColor: UIColor.red,
                            .font: UIFont.italicSystemFont(ofSize: 20),
                            .underlineStyle: NSUnderlineStyle.single.rawValue
                        ]
                    )
                }
                view.backgroundColor = .secondarySystemBackground

                let backgroundView = UIView()
                backgroundView.backgroundColor = .systemBackground
                backgroundView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    backgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.maxWidth)
                ])
                backgroundView.addSubview(view)
                NSLayoutConstraint.stickEdges(
                    from: view,
                    to: backgroundView,
                    insets: .init(all: Constants.padding)
                )

                self.assertSnapshot(
                    matching: backgroundView,
                    modes: configuration.modes,
                    sizes: configuration.sizes,
                    testName: configuration.testName()
                )
            }
        }
    }
}

// MARK: - Extension

private extension UIImage {
    static var on = IconographyTests.shared.switchOn
    static var off = IconographyTests.shared.switchOff
}
