//
//  SwitchViewModelTests.swift
//  SparkSwitchTests
//
//  Created by robin.lemaire on 10/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import XCTest
@testable import SparkSwitch
@_spi(SI_SPI) @testable import SparkSwitchTesting
@_spi(SI_SPI) import SparkCommon
import SparkTheming
@_spi(SI_SPI) import SparkThemingTesting
import SwiftUI

final class SwitchViewModelTests: XCTestCase {

    // MARK: - Initialization Test

    func test_initialization_shouldUseDefaultValues() {
        // GIVEN / WHEN
        let stub = Stub()

        // THEN
        XCTAssertEqualToExpected(
            on: stub,
            otherDynamicColors: .init(),
            otherStaticColors: .init(),
            otherContentRadius: 0,
            otherDim: 1,
            otherTitleFont: .body,
            otherIsIcon: false,
            otherShowHiddenEmptyLabel: false,
            otherSpacing: 0
        )

        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getTitleFont: true,
            getIsIcon: true,
            getShowHiddenEmptyLabel: true,
            getSpacing: true
        )
    }

    // MARK: - Setup Tests

    func test_setup_shouldCallAllUseCases() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        // WHEN
        viewModel.setup(stub: stub)

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        SwitchGetColorsUseCaseableMockTest.XCTAssert(
            stub.getColorsUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            givenIsOn: stub.givenIsOn,
            expectedReturnValue: stub.expectedDynamicColors
        )

        SwitchGetColorsUseCaseableMockTest.XCTAssert(
            stub.getColorsUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            expectedReturnValue: stub.expectedStaticColors
        )

        SwitchGetContentRadiusUseCaseableMockTest.XCTAssert(
            stub.getContentRadiusUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            expectedReturnValue: stub.expectedContentRadius
        )

        SwitchGetDimUseCaseableMockTest.XCTAssert(
            stub.getDimUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            givenIsEnabled: stub.givenIsEnabled,
            expectedReturnValue: stub.expectedDim
        )

        SwitchGetTitleFontUseCaseableMockTest.XCTAssert(
            stub.getTitleFontUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            expectedReturnValue: stub.expectedTitleFont
        )

        SwitchGetIsIconUseCaseableMockTest.XCTAssert(
            stub.getIsIconUseCaseMock,
            expectedNumberOfCalls: 1,
            givenIsOnOffSwitchLabelsEnabled: stub.givenIsOnOffSwitchLabelsEnabled,
            givenContrast: stub.givenContrast,
            expectedReturnValue: stub.expectedIsIcon
        )

        SwitchGetShowHiddenEmptyLabelUseCaseableMockTest.XCTAssert(
            stub.getShowHiddenEmptyLabelUseCaseMock,
            expectedNumberOfCalls: 1,
            givenIsCustomLabel: stub.givenIsCustomLabel,
            expectedReturnValue: stub.expectedShowHiddenEmptyLabel
        )

        SwitchGetSpacingUseCaseableMockTest.XCTAssert(
            stub.getSpacingUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            expectedReturnValue: stub.expectedSpacing
        )
        // **
    }

    // MARK: - Setter

    func test_themeChanged_shouldUpdateAllProperties_exceptIsIcon() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.setup(stub: stub)
        stub.resetMockedData()

        let givenTheme = ThemeGeneratedMock.mocked()

        // WHEN
        viewModel.theme = givenTheme

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getIsIcon: true
        )

        SwitchGetColorsUseCaseableMockTest.XCTAssert(
            stub.getColorsUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: givenTheme,
            givenIsOn: stub.givenIsOn,
            expectedReturnValue: stub.expectedDynamicColors
        )

        SwitchGetColorsUseCaseableMockTest.XCTAssert(
            stub.getColorsUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: givenTheme,
            expectedReturnValue: stub.expectedStaticColors
        )

        SwitchGetContentRadiusUseCaseableMockTest.XCTAssert(
            stub.getContentRadiusUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: givenTheme,
            expectedReturnValue: stub.expectedContentRadius
        )

        SwitchGetDimUseCaseableMockTest.XCTAssert(
            stub.getDimUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: givenTheme,
            givenIsEnabled: stub.givenIsEnabled,
            expectedReturnValue: stub.expectedDim
        )

        SwitchGetTitleFontUseCaseableMockTest.XCTAssert(
            stub.getTitleFontUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: givenTheme,
            expectedReturnValue: stub.expectedTitleFont
        )

        SwitchGetSpacingUseCaseableMockTest.XCTAssert(
            stub.getSpacingUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: givenTheme,
            expectedReturnValue: stub.expectedSpacing
        )
        // **
    }

    func test_isOnChanged_shouldUpdateDynamicColors() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.setup(stub: stub)
        stub.resetMockedData()

        let givenIsOn = false

        // WHEN
        viewModel.isOn = givenIsOn

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getTitleFont: true,
            getIsIcon: true,
            getSpacing: true
        )

        SwitchGetColorsUseCaseableMockTest.XCTAssert(
            stub.getColorsUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            givenIsOn: givenIsOn,
            expectedReturnValue: stub.expectedDynamicColors
        )
        // **
    }

    func test_isOnOffSwitchLabelsEnabledChanged_shouldUpdateIsIcon() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.setup(stub: stub)
        stub.resetMockedData()

        let givenIsOnOffSwitchLabelsEnabled = true

        // WHEN
        viewModel.isOnOffSwitchLabelsEnabled = givenIsOnOffSwitchLabelsEnabled

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getTitleFont: true,
            getSpacing: true
        )

        SwitchGetIsIconUseCaseableMockTest.XCTAssert(
            stub.getIsIconUseCaseMock,
            expectedNumberOfCalls: 1,
            givenIsOnOffSwitchLabelsEnabled: givenIsOnOffSwitchLabelsEnabled,
            givenContrast: stub.givenContrast,
            expectedReturnValue: stub.expectedIsIcon
        )
        // **
    }

    func test_contrastChanged_shouldUpdateIsIcon() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.setup(stub: stub)
        stub.resetMockedData()

        let givenContrast = ColorSchemeContrast.increased

        // WHEN
        viewModel.contrast = givenContrast

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getTitleFont: true,
            getSpacing: true
        )

        SwitchGetIsIconUseCaseableMockTest.XCTAssert(
            stub.getIsIconUseCaseMock,
            expectedNumberOfCalls: 1,
            givenIsOnOffSwitchLabelsEnabled: stub.givenIsOnOffSwitchLabelsEnabled,
            givenContrast: givenContrast,
            expectedReturnValue: stub.expectedIsIcon
        )
        // **
    }

    func test_isEnabledChanged_shouldUpdateDim() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.setup(stub: stub)
        stub.resetMockedData()

        let givenIsEnabled = true

        // WHEN
        viewModel.isEnabled = givenIsEnabled

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getTitleFont: true,
            getIsIcon: true,
            getSpacing: true
        )

        SwitchGetDimUseCaseableMockTest.XCTAssert(
            stub.getDimUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            givenIsEnabled: givenIsEnabled,
            expectedReturnValue: stub.expectedDim
        )
        // **
    }

    func test_allSetter_exceptTheme_withoutChange() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.setup(stub: stub)
        stub.resetMockedData()

        // WHEN
        viewModel.isOn = stub.givenIsOn
        viewModel.isOnOffSwitchLabelsEnabled = stub.givenIsOnOffSwitchLabelsEnabled
        viewModel.contrast = stub.givenContrast
        viewModel.isEnabled = stub.givenIsEnabled

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getTitleFont: true,
            getIsIcon: true,
            getSpacing: true
        )
    }

    func test_allSetter_exceptTheme_withoutSetupBefore() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        // WHEN
        viewModel.isOn = false
        viewModel.isOnOffSwitchLabelsEnabled = true
        viewModel.contrast = .increased
        viewModel.isEnabled = true
        viewModel.isEnabled = true

        // THEN
        XCTAssertEqualToExpected(
            on: stub,
            otherDynamicColors: .init(),
            otherStaticColors: .init(),
            otherContentRadius: 0,
            otherDim: 1,
            otherTitleFont: .body,
            otherIsIcon: false,
            otherShowHiddenEmptyLabel: false,
            otherSpacing: 0
        )

        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getTitleFont: true,
            getIsIcon: true,
            getShowHiddenEmptyLabel: true,
            getSpacing: true
        )
    }
}

// MARK: - Stub

private final class Stub: SwitchViewModelStub {

    // MARK: - Given Properties

    let givenTheme = ThemeGeneratedMock.mocked()
    let givenIsOn = true
    let givenIsOnOffSwitchLabelsEnabled: Bool = false
    let givenContrast: ColorSchemeContrast = .standard
    let givenIsEnabled: Bool = false
    let givenIsCustomLabel: Bool = false

    // MARK: - Expected Properties

    let expectedDynamicColors = SwitchDynamicColors()
    let expectedStaticColors = SwitchStaticColors()
    let expectedContentRadius: CGFloat = 4
    let expectedDim: CGFloat = 0.5
    let expectedTitleFont: Font = .title
    let expectedIsIcon = true
    let expectedSpacing: CGFloat = 10
    let expectedShowHiddenEmptyLabel = true

    // MARK: - Initialization

    init() {
        let getColorsUseCaseMock = SwitchGetColorsUseCaseableGeneratedMock()
        getColorsUseCaseMock.executeStaticWithThemeReturnValue = self.expectedStaticColors
        getColorsUseCaseMock.executeDynamicWithThemeAndIsOnReturnValue = self.expectedDynamicColors

        let getContentRadiusUseCaseMock = SwitchGetContentRadiusUseCaseableGeneratedMock()
        getContentRadiusUseCaseMock.executeWithThemeReturnValue = self.expectedContentRadius

        let getDimUseCaseMock = SwitchGetDimUseCaseableGeneratedMock()
        getDimUseCaseMock.executeWithThemeAndIsEnabledReturnValue = self.expectedDim

        let getTitleFontUseCaseMock = SwitchGetTitleFontUseCaseableGeneratedMock()
        getTitleFontUseCaseMock.executeWithThemeReturnValue = self.expectedTitleFont

        let getIsIconUseCaseMock = SwitchGetIsIconUseCaseableGeneratedMock()
        getIsIconUseCaseMock.executeWithIsOnOffSwitchLabelsEnabledAndContrastReturnValue = self.expectedIsIcon

        let getSpacingUseCaseMock = SwitchGetSpacingUseCaseableGeneratedMock()
        getSpacingUseCaseMock.executeWithThemeReturnValue = self.expectedSpacing

        let getShowHiddenEmptyLabelUseCaseMock = SwitchGetShowHiddenEmptyLabelUseCaseableGeneratedMock()
        getShowHiddenEmptyLabelUseCaseMock.executeWithIsCustomLabelReturnValue = self.expectedShowHiddenEmptyLabel

        let viewModel = SwitchViewModel(
            getColorsUseCase: getColorsUseCaseMock,
            getContentRadiusUseCase: getContentRadiusUseCaseMock,
            getDimUseCase: getDimUseCaseMock,
            getTitleFontUseCase: getTitleFontUseCaseMock,
            getIsIconUseCase: getIsIconUseCaseMock,
            getShowHiddenEmptyLabelUseCase: getShowHiddenEmptyLabelUseCaseMock,
            getSpacingUseCase: getSpacingUseCaseMock
        )

        super.init(
            viewModel: viewModel,
            getColorsUseCaseMock: getColorsUseCaseMock,
            getContentRadiusUseCaseMock: getContentRadiusUseCaseMock,
            getDimUseCaseMock: getDimUseCaseMock,
            getTitleFontUseCaseMock: getTitleFontUseCaseMock,
            getIsIconUseCaseMock: getIsIconUseCaseMock,
            getShowHiddenEmptyLabelUseCaseMock: getShowHiddenEmptyLabelUseCaseMock,
            getSpacingUseCaseMock: getSpacingUseCaseMock
        )
    }
}

// MARK: - Extension

private extension SwitchViewModel {

    func setup(stub: Stub) {
        self.setup(
            theme: stub.givenTheme,
            isOn: stub.givenIsOn,
            isOnOffSwitchLabelsEnabled: stub.givenIsOnOffSwitchLabelsEnabled,
            contrast: stub.givenContrast,
            isEnabled: stub.givenIsEnabled,
            isCustomLabel: stub.givenIsCustomLabel
        )
    }
}

// MARK: - XCT

private func XCTAssertNotCalled(
    on stub: Stub,
    getDynamicColors getDynamicColorsNotCalled: Bool = false,
    getStaticColors getStaticColorsNotCalled: Bool = false,
    getContentRadius getContentRadiusNotCalled: Bool = false,
    getDim getDimNotCalled: Bool = false,
    getTitleFont getTitleFontNotCalled: Bool = false,
    getIsIcon getIsIconNotCalled: Bool = false,
    getShowHiddenEmptyLabel getShowHiddenEmptyLabelCalled: Bool = false,
    getSpacing getSpacingNotCalled: Bool = false
) {
    if getDynamicColorsNotCalled {
        SwitchGetColorsUseCaseableMockTest.XCTCallsCount(
            stub.getColorsUseCaseMock,
            executeDynamicWithThemeAndIsOnNumberOfCalls: 0
        )
    }

    if getStaticColorsNotCalled {
        SwitchGetColorsUseCaseableMockTest.XCTCallsCount(
            stub.getColorsUseCaseMock,
            executeStaticWithThemeNumberOfCalls: 0
        )
    }

    if getContentRadiusNotCalled {
        SwitchGetContentRadiusUseCaseableMockTest.XCTCallsCount(
            stub.getContentRadiusUseCaseMock,
            executeWithThemeNumberOfCalls: 0
        )
    }

    if getDimNotCalled {
        SwitchGetDimUseCaseableMockTest.XCTCallsCount(
            stub.getDimUseCaseMock,
            executeWithThemeAndIsEnabledNumberOfCalls: 0
        )
    }

    if getTitleFontNotCalled {
        SwitchGetTitleFontUseCaseableMockTest.XCTCallsCount(
            stub.getTitleFontUseCaseMock,
            executeUIWithThemeNumberOfCalls: 0
        )
    }

    if getIsIconNotCalled {
        SwitchGetIsIconUseCaseableMockTest.XCTCallsCount(
            stub.getIsIconUseCaseMock,
            executeUIWithIsOnOffSwitchLabelsEnabledAndContrastNumberOfCalls: 0
        )
    }
    if getShowHiddenEmptyLabelCalled {
        SwitchGetShowHiddenEmptyLabelUseCaseableMockTest.XCTCallsCount(
            stub.getShowHiddenEmptyLabelUseCaseMock,
            executeWithIsCustomLabelNumberOfCalls: 0
        )
    }

    if getSpacingNotCalled {
        SwitchGetSpacingUseCaseableMockTest.XCTCallsCount(
            stub.getSpacingUseCaseMock,
            executeWithThemeNumberOfCalls: 0
        )
    }
}

private func XCTAssertEqualToExpected(
    on stub: Stub,
    otherDynamicColors: SwitchDynamicColors? = nil,
    otherStaticColors: SwitchStaticColors? = nil,
    otherContentRadius: CGFloat? = nil,
    otherDim: CGFloat? = nil,
    otherTitleFont: Font? = nil,
    otherIsIcon: Bool? = nil,
    otherShowHiddenEmptyLabel: Bool? = nil,
    otherSpacing: CGFloat? = nil
) {
    let viewModel = stub.viewModel

    XCTAssertEqual(
        viewModel.dynamicColors,
        otherDynamicColors ?? stub.expectedDynamicColors,
        "Wrong dynamicColors value"
    )
    XCTAssertEqual(
        viewModel.staticColors,
        otherStaticColors ?? stub.expectedStaticColors,
        "Wrong staticColors value"
    )
    XCTAssertEqual(
        viewModel.contentRadius,
        otherContentRadius ?? stub.expectedContentRadius,
        "Wrong contentRadius value"
    )
    XCTAssertEqual(
        viewModel.dim,
        otherDim ?? stub.expectedDim,
        "Wrong dim value"
    )
    XCTAssertEqual(
        viewModel.titleFont,
        otherTitleFont ?? stub.expectedTitleFont,
        "Wrong font value"
    )
    XCTAssertEqual(
        viewModel.isIcon,
        otherIsIcon ?? stub.expectedIsIcon,
        "Wrong isIcon value"
    )
    XCTAssertEqual(
        viewModel.showHiddenEmptyLabel,
        otherShowHiddenEmptyLabel ?? stub.expectedShowHiddenEmptyLabel,
        "Wrong otherShowHiddenEmptyLabel value"
    )
    XCTAssertEqual(
        viewModel.spacing,
        otherSpacing ?? stub.expectedSpacing,
        "Wrong spacing value"
    )
}
