//
//  SwitchUIViewModelTests.swift
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

final class SwitchUIViewModelTests: XCTestCase {

    // MARK: - Initialization Tests

    func test_initialization_shouldUseDefaultValues() {
        // GIVEN / WHEN
        let stub = Stub()

        // THEN
        XCTAssertEqualToExpected(
            on: stub,
            otherIsOn: false,
            otherAnimationType: .unanimated,
            otherDynamicColors: .init(),
            otherStaticColors: .init(),
            otherContentRadius: 0,
            otherDim: 1,
            otherIsIcon: false,
            otherShowSpace: .left,
            otherSpacing: 0,
            otherTitleFont: .systemFont(ofSize: 14)
        )

        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getAnimationType: true,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getIsIcon: true,
            getShowSpace: true,
            getSpacing: true,
            getTitleFont: true
        )
    }

    // MARK: - Load Tests

    func test_load_shouldCallAllUseCases_exceptAnimationType() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        // WHEN
        viewModel.load(stub: stub)

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        SwitchGetAnimationTypeUseCaseableMockTest.XCTAssert(
            stub.getAnimationTypeUseCaseMock,
            expectedNumberOfCalls: 1,
            givenIsOnAnimated: true,
            givenIsReduceMotionEnabled: stub.givenIsReduceMotionEnabled,
            expectedReturnValue: stub.expectedAnimationType
        )

        SwitchGetColorsUseCaseableMockTest.XCTAssert(
            stub.getColorsUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            givenIsOn: false,
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
            givenIsEnabled: true,
            expectedReturnValue: stub.expectedDim
        )

        SwitchGetIsIconUseCaseableMockTest.XCTAssert(
            stub.getIsIconUseCaseMock,
            expectedNumberOfCalls: 1,
            givenIsOnOffSwitchLabelsEnabled: stub.givenIsOnOffSwitchLabelsEnabled,
            givenContrast: stub.givenContrast,
            expectedReturnValue: stub.expectedIsIcon
        )

        SwitchGetShowSpaceUseCaseableMockTest.XCTAssert(
            stub.getShowSpaceUseCaseableMock,
            expectedNumberOfCalls: 1,
            givenIsOn: false,
            expectedReturnValue: stub.expectedShowSpace
        )

        SwitchGetSpacingUseCaseableMockTest.XCTAssert(
            stub.getSpacingUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            expectedReturnValue: stub.expectedSpacing
        )

        SwitchGetTitleFontUseCaseableMockTest.XCTAssert(
            stub.getTitleFontUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            expectedReturnValue: stub.expectedTitleFont
        )
        // **
    }

    // MARK: - Setter Tests

    func test_themeChanged_shouldUpdateSomeProperties() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.load(stub: stub)
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
            getAnimationType: true,
            getIsIcon: true,
            getShowSpace: true
        )

        SwitchGetColorsUseCaseableMockTest.XCTAssert(
            stub.getColorsUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: givenTheme,
            givenIsOn: false,
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
            givenIsEnabled: true,
            expectedReturnValue: stub.expectedDim
        )

        SwitchGetSpacingUseCaseableMockTest.XCTAssert(
            stub.getSpacingUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: givenTheme,
            expectedReturnValue: stub.expectedSpacing
        )

        SwitchGetTitleFontUseCaseableMockTest.XCTAssert(
            stub.getTitleFontUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: givenTheme,
            expectedReturnValue: stub.expectedTitleFont
        )
        // **
    }

    func test_isOnOffSwitchLabelsEnabledChanged_shouldUpdateIsIcon() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.load(stub: stub)
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
            getAnimationType: true,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getShowSpace: true,
            getSpacing: true,
            getTitleFont: true
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

        viewModel.load(stub: stub)
        stub.resetMockedData()

        let givenContrast = UIAccessibilityContrast.high

        // WHEN
        viewModel.contrast = givenContrast

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getAnimationType: true,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getShowSpace: true,
            getSpacing: true,
            getTitleFont: true
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

        viewModel.load(stub: stub)
        stub.resetMockedData()

        let givenIsEnabled = false

        // WHEN
        viewModel.isEnabled = givenIsEnabled

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getAnimationType: true,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getIsIcon: true,
            getShowSpace: true,
            getSpacing: true,
            getTitleFont: true
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

    func test_isReduceMotionEnabled_shouldUpdateAnimationType() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.load(stub: stub)
        stub.resetMockedData()

        let givenIsReduceMotionEnabled = true

        // WHEN
        viewModel.isReduceMotionEnabled = givenIsReduceMotionEnabled

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getIsIcon: true,
            getShowSpace: true,
            getSpacing: true,
            getTitleFont: true
        )

        SwitchGetAnimationTypeUseCaseableMockTest.XCTAssert(
            stub.getAnimationTypeUseCaseMock,
            expectedNumberOfCalls: 1,
            givenIsOnAnimated: true,
            givenIsReduceMotionEnabled: givenIsReduceMotionEnabled,
            expectedReturnValue: stub.expectedAnimationType
        )
        // **
    }

    func test_allSetter_exceptTheme_withoutChange() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.load(stub: stub)
        stub.resetMockedData()

        // WHEN
        viewModel.setIsOn(false)
        viewModel.isOnOffSwitchLabelsEnabled = stub.givenIsOnOffSwitchLabelsEnabled
        viewModel.contrast = stub.givenContrast
        viewModel.isEnabled = true
        viewModel.isReduceMotionEnabled = stub.givenIsReduceMotionEnabled

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getAnimationType: true,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getIsIcon: true,
            getShowSpace: true,
            getSpacing: true,
            getTitleFont: true
        )
    }

    func test_allSetter_exceptTheme_withoutLoadBefore() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        // WHEN
        viewModel.setIsOn(true)
        viewModel.isOnOffSwitchLabelsEnabled = true
        viewModel.contrast = .high
        viewModel.isEnabled = false
        viewModel.isReduceMotionEnabled = true

        // THEN
        XCTAssertEqualToExpected(
            on: stub,
            otherAnimationType: .unanimated,
            otherDynamicColors: .init(),
            otherStaticColors: .init(),
            otherContentRadius: 0,
            otherDim: 1,
            otherIsIcon: false,
            otherShowSpace: .left,
            otherSpacing: 0,
            otherTitleFont: .systemFont(ofSize: 14)
        )

        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getAnimationType: true,
            getDynamicColors: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getIsIcon: true,
            getShowSpace: true,
            getSpacing: true,
            getTitleFont: true
        )
    }

    // MARK: - Action

    func test_toggle() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.load(stub: stub)
        stub.resetMockedData()

        // WHEN
        viewModel.toggle()

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getAnimationType: true,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getSpacing: true,
            getTitleFont: true
        )

        SwitchGetColorsUseCaseableMockTest.XCTAssert(
            stub.getColorsUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            givenIsOn: true,
            expectedReturnValue: stub.expectedDynamicColors
        )

        SwitchGetIsIconUseCaseableMockTest.XCTAssert(
            stub.getIsIconUseCaseMock,
            expectedNumberOfCalls: 1,
            givenIsOnOffSwitchLabelsEnabled: stub.givenIsOnOffSwitchLabelsEnabled,
            givenContrast: stub.givenContrast,
            expectedReturnValue: stub.expectedIsIcon
        )

        SwitchGetShowSpaceUseCaseableMockTest.XCTAssert(
            stub.getShowSpaceUseCaseableMock,
            expectedNumberOfCalls: 1,
            givenIsOn: true,
            expectedReturnValue: stub.expectedShowSpace
        )
        // **
    }

    func test_setIsOn() {
        // GIVEN
        let stub = Stub()
        let viewModel = stub.viewModel

        viewModel.load(stub: stub)
        stub.resetMockedData()

        let givenIsOn = true
        let givenIsAnimated = false

        // WHEN
        viewModel.setIsOn(true, animated: givenIsAnimated)

        // THEN
        XCTAssertEqualToExpected(on: stub)

        // **
        // UseCase Calls Count
        XCTAssertNotCalled(
            on: stub,
            getStaticColors: true,
            getContentRadius: true,
            getDim: true,
            getSpacing: true,
            getTitleFont: true
        )

        SwitchGetAnimationTypeUseCaseableMockTest.XCTAssert(
            stub.getAnimationTypeUseCaseMock,
            expectedNumberOfCalls: 1,
            givenIsOnAnimated: givenIsAnimated,
            givenIsReduceMotionEnabled: stub.givenIsReduceMotionEnabled,
            expectedReturnValue: stub.expectedAnimationType
        )

        SwitchGetColorsUseCaseableMockTest.XCTAssert(
            stub.getColorsUseCaseMock,
            expectedNumberOfCalls: 1,
            givenTheme: stub.givenTheme,
            givenIsOn: givenIsOn,
            expectedReturnValue: stub.expectedDynamicColors
        )

        SwitchGetIsIconUseCaseableMockTest.XCTAssert(
            stub.getIsIconUseCaseMock,
            expectedNumberOfCalls: 1,
            givenIsOnOffSwitchLabelsEnabled: stub.givenIsOnOffSwitchLabelsEnabled,
            givenContrast: stub.givenContrast,
            expectedReturnValue: stub.expectedIsIcon
        )

        SwitchGetShowSpaceUseCaseableMockTest.XCTAssert(
            stub.getShowSpaceUseCaseableMock,
            expectedNumberOfCalls: 1,
            givenIsOn: givenIsOn,
            expectedReturnValue: stub.expectedShowSpace
        )
        // **
    }
}

// MARK: - Stub

private final class Stub: SwitchUIViewModelStub {

    // MARK: - Given Properties

    let givenTheme = ThemeGeneratedMock.mocked()
    let givenIsOnOffSwitchLabelsEnabled: Bool = false
    let givenContrast: UIAccessibilityContrast = .normal
    let givenIsEnabled: Bool = false
    let givenIsReduceMotionEnabled = false

    // MARK: - Expected Properties

    let expectedAnimationType = UIExecuteAnimationType.animated(duration: 2)
    let expectedDynamicColors = SwitchDynamicColors()
    let expectedStaticColors = SwitchStaticColors()
    let expectedContentRadius: CGFloat = 4
    let expectedDim: CGFloat = 0.5
    let expectedIsIcon: Bool = true
    let expectedShowSpace: SwitchSpace = .right
    let expectedSpacing: CGFloat = 10
    let expectedTitleFont: UIFont = .systemFont(ofSize: 14)

    // MARK: - Initialization

    init() {
        let getAnimationTypeUseCaseMock = SwitchGetAnimationTypeUseCaseableGeneratedMock()
        getAnimationTypeUseCaseMock.executeWithIsOnAnimatedAndIsReduceMotionEnabledReturnValue = self.expectedAnimationType

        let getColorsUseCaseMock = SwitchGetColorsUseCaseableGeneratedMock()
        getColorsUseCaseMock.executeStaticWithThemeReturnValue = self.expectedStaticColors
        getColorsUseCaseMock.executeDynamicWithThemeAndIsOnReturnValue = self.expectedDynamicColors

        let getContentRadiusUseCaseMock = SwitchGetContentRadiusUseCaseableGeneratedMock()
        getContentRadiusUseCaseMock.executeWithThemeReturnValue = self.expectedContentRadius

        let getDimUseCaseMock = SwitchGetDimUseCaseableGeneratedMock()
        getDimUseCaseMock.executeWithThemeAndIsEnabledReturnValue = self.expectedDim

        let getIsIconUseCaseMock = SwitchGetIsIconUseCaseableGeneratedMock()
        getIsIconUseCaseMock.executeUIWithIsOnOffSwitchLabelsEnabledAndContrastReturnValue = self.expectedIsIcon

        let getShowSpaceUseCaseMock = SwitchGetShowSpaceUseCaseableGeneratedMock()
        getShowSpaceUseCaseMock.executeWithIsOnReturnValue = self.expectedShowSpace

        let getSpacingUseCaseMock = SwitchGetSpacingUseCaseableGeneratedMock()
        getSpacingUseCaseMock.executeWithThemeReturnValue = self.expectedSpacing

        let getTitleFontUseCaseMock = SwitchGetTitleFontUseCaseableGeneratedMock()
        getTitleFontUseCaseMock.executeUIWithThemeReturnValue = self.expectedTitleFont

        let viewModel = SwitchUIViewModel(
            theme: givenTheme,
            getAnimationTypeUseCase: getAnimationTypeUseCaseMock,
            getColorsUseCase: getColorsUseCaseMock,
            getContentRadiusUseCase: getContentRadiusUseCaseMock,
            getDimUseCase: getDimUseCaseMock,
            getIsIconUseCase: getIsIconUseCaseMock,
            getShowSpaceUseCaseable: getShowSpaceUseCaseMock,
            getSpacingUseCase: getSpacingUseCaseMock,
            getTitleFontUseCase: getTitleFontUseCaseMock
        )

        super.init(
            viewModel: viewModel,
            getAnimationTypeUseCaseMock: getAnimationTypeUseCaseMock,
            getColorsUseCaseMock: getColorsUseCaseMock,
            getContentRadiusUseCaseMock: getContentRadiusUseCaseMock,
            getDimUseCaseMock: getDimUseCaseMock,
            getIsIconUseCaseMock: getIsIconUseCaseMock,
            getShowSpaceUseCaseableMock: getShowSpaceUseCaseMock,
            getSpacingUseCaseMock: getSpacingUseCaseMock,
            getTitleFontUseCaseMock: getTitleFontUseCaseMock
        )
    }
}

// MARK: - Extension

private extension SwitchUIViewModel {

    func load(stub: Stub) {
        self.load(
            isOnOffSwitchLabelsEnabled: stub.givenIsOnOffSwitchLabelsEnabled,
            isReduceMotionEnabled: stub.givenIsReduceMotionEnabled,
            contrast: stub.givenContrast
        )
    }
}

// MARK: - XCT

private func XCTAssertNotCalled(
    on stub: Stub,
    getAnimationType getAnimationTypeNotCalled: Bool = false,
    getDynamicColors getDynamicColorsNotCalled: Bool = false,
    getStaticColors getStaticColorsNotCalled: Bool = false,
    getContentRadius getContentRadiusNotCalled: Bool = false,
    getDim getDimNotCalled: Bool = false,
    getIsIcon getIsIconNotCalled: Bool = false,
    getShowSpace getShowSpaceNotCalled: Bool = false,
    getSpacing getSpacingNotCalled: Bool = false,
    getTitleFont getTitleFontNotCalled: Bool = false
) {
    if getAnimationTypeNotCalled {
        SwitchGetAnimationTypeUseCaseableMockTest.XCTCallsCount(
            stub.getAnimationTypeUseCaseMock,
            executeWithIsOnAnimatedAndIsReduceMotionEnabledNumberOfCalls: 0
        )
    }

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

    if getIsIconNotCalled {
        SwitchGetIsIconUseCaseableMockTest.XCTCallsCount(
            stub.getIsIconUseCaseMock,
            executeUIWithIsOnOffSwitchLabelsEnabledAndContrastNumberOfCalls: 0
        )
    }

    if getShowSpaceNotCalled {
        SwitchGetShowSpaceUseCaseableMockTest.XCTCallsCount(
            stub.getShowSpaceUseCaseableMock,
            executeWithIsOnNumberOfCalls: 0
        )
    }

    if getSpacingNotCalled {
        SwitchGetSpacingUseCaseableMockTest.XCTCallsCount(
            stub.getSpacingUseCaseMock,
            executeWithThemeNumberOfCalls: 0
        )
    }

    if getTitleFontNotCalled {
        SwitchGetTitleFontUseCaseableMockTest.XCTCallsCount(
            stub.getTitleFontUseCaseMock,
            executeUIWithThemeNumberOfCalls: 0
        )
    }
}

private func XCTAssertEqualToExpected(
    on stub: Stub,
    otherIsOn: Bool? = nil,
    otherAnimationType: UIExecuteAnimationType? = nil,
    otherDynamicColors: SwitchDynamicColors? = nil,
    otherStaticColors: SwitchStaticColors? = nil,
    otherContentRadius: CGFloat? = nil,
    otherDim: CGFloat? = nil,
    otherIsIcon: Bool? = nil,
    otherShowSpace: SwitchSpace? = nil,
    otherSpacing: CGFloat? = nil,
    otherTitleFont: UIFont? = nil
) {
    let viewModel = stub.viewModel

    if let otherIsOn {
        XCTAssertEqual(
            viewModel.isOn,
            otherIsOn,
            "Wrong isOn value"
        )
    }

    XCTAssertEqual(
        viewModel.animationType,
        otherAnimationType ?? stub.expectedAnimationType,
        "Wrong animationType value"
    )
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
        viewModel.isIcon,
        otherIsIcon ?? stub.expectedIsIcon,
        "Wrong isIcon value"
    )
    XCTAssertEqual(
        viewModel.showSpace,
        otherShowSpace ?? stub.expectedShowSpace,
        "Wrong showSpace value"
    )
    XCTAssertEqual(
        viewModel.spacing,
        otherSpacing ?? stub.expectedSpacing,
        "Wrong spacing value"
    )
    XCTAssertEqual(
        viewModel.titleFont,
        otherTitleFont ?? stub.expectedTitleFont,
        "Wrong font value"
    )
}
