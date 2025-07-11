//
//  SwitchGetTitleFontUseCaseTests.swift
//  SparkSwitchTests
//
//  Created by robin.lemaire on 10/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import XCTest
@testable import SparkSwitch
@_spi(SI_SPI) import SparkThemingTesting

final class SwitchGetTitleFontUseCaseTests: XCTestCase {

    // MARK: - Tests

    func test_executeUI_returnsUIFontFromTheme() {
        // GIVEN
        let theme = ThemeGeneratedMock.mocked()
        let useCase = SwitchGetTitleFontUseCase()

        // WHEN
        let result = useCase.executeUI(theme: theme)

        // THEN
        XCTAssertEqual(result, theme.typography.body1.uiFont)
    }

    func test_execute_returnsFontFromTheme() {
        // GIVEN
        let theme = ThemeGeneratedMock.mocked()
        let useCase = SwitchGetTitleFontUseCase()

        // WHEN
        let result = useCase.execute(theme: theme)

        // THEN
        XCTAssertEqual(result, theme.typography.body1.font)
    }
}
