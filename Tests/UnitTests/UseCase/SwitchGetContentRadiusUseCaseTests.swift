//
//  SwitchGetContentRadiusUseCaseTests.swift
//  SparkSwitchTests
//
//  Created by robin.lemaire on 10/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import XCTest
@testable import SparkSwitch
@_spi(SI_SPI) import SparkThemingTesting

final class SwitchGetContentRadiusUseCaseTests: XCTestCase {

    // MARK: - Tests

    func test_execute_returnsFullRadius() {
        // GIVEN
        let theme = ThemeGeneratedMock.mocked()
        let useCase = SwitchGetContentRadiusUseCase()

        // WHEN
        let result = useCase.execute(theme: theme)

        // THEN
        XCTAssertEqual(result, theme.border.radius.full)
    }
}
