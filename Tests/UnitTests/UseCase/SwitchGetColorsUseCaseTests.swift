//
//  SwitchGetColorsUseCaseTests.swift
//  SparkSwitchTests
//
//  Created by robin.lemaire on 10/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import XCTest
@testable import SparkSwitch
@_spi(SI_SPI) import SparkThemingTesting

final class SwitchGetColorsUseCaseTests: XCTestCase {

    // MARK: - Tests

    func test_executeStatic_returnsExpectedStaticColors() {
        // GIVEN
        let theme = ThemeGeneratedMock.mocked()
        let useCase = SwitchGetColorsUseCase()

        // WHEN
        let result = useCase.executeStatic(theme: theme)

        // THEN
        XCTAssertTrue(result.dotBackgroundColor.equals(theme.colors.base.surface))
        XCTAssertTrue(result.textForegroundColor.equals(theme.colors.base.onSurface))
        XCTAssertTrue(result.hoverColor.equals(theme.colors.basic.basicContainer))
    }

    func test_executeDynamic_whenIsOn_returnsExpectedDynamicColors() {
        // GIVEN
        let theme = ThemeGeneratedMock.mocked()
        let useCase = SwitchGetColorsUseCase()

        // WHEN
        let result = useCase.executeDynamic(theme: theme, isOn: true)

        // THEN
        let color = theme.colors.basic.basic
        XCTAssertTrue(result.backgroundColors.equals(color))
        XCTAssertTrue(result.dotForegroundColors.equals(color))
    }

    func test_executeDynamic_whenIsOff_returnsExpectedDynamicColors() {
        // GIVEN
        let theme = ThemeGeneratedMock.mocked()
        let useCase = SwitchGetColorsUseCase()

        // WHEN
        let result = useCase.executeDynamic(theme: theme, isOn: false)

        // THEN
        let color = theme.colors.basic.basic
        XCTAssertTrue(result.backgroundColors.equals(color.opacity(theme.dims.dim3)))
        XCTAssertTrue(result.dotForegroundColors.equals(color.opacity(theme.dims.dim2)))
    }
}
