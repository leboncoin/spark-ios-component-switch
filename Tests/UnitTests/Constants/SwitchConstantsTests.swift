//
//  SwitchSubviewTypeTests.swift
//  SparkSwitchTests
//
//  Created by robin.lemaire on 14/09/2023.
//  Copyright © 2023 Leboncoin. All rights reserved.
//
import XCTest
@testable import SparkSwitch

final class SwitchConstantsTests: XCTestCase {

    // MARK: - SwitchConstants Tests

    func test_animationDuration() {
        XCTAssertEqual(
            SwitchConstants.animationDuration,
            0.2
        )
    }

    func test_toggleDotImagePadding() {
        XCTAssertEqual(
            SwitchConstants.toggleDotImagePadding,
            5
        )
    }

    // MARK: - ToggleSizes Tests

    func test_toggleSizes_width() {
        XCTAssertEqual(
            SwitchConstants.ToggleSizes.width,
            56
        )
    }

    func test_toggleSizes_height() {
        XCTAssertEqual(
            SwitchConstants.ToggleSizes.height,
            32
        )
    }

    func test_toggleSizes_dotSize() {
        XCTAssertEqual(
            SwitchConstants.ToggleSizes.dotSize,
            SwitchConstants.ToggleSizes.height
        )
    }

    func test_toggleSizes_dotPressedSize() {
        XCTAssertEqual(
            SwitchConstants.ToggleSizes.dotPressedSize,
            SwitchConstants.ToggleSizes.width * 0.75
        )
    }

    func test_toggleSizes_dotIncreasePressedSize() {
        XCTAssertEqual(
            SwitchConstants.ToggleSizes.dotIncreasePressedSize,
            10
        )
    }

    func test_toggleSizes_padding() {
        XCTAssertEqual(
            SwitchConstants.ToggleSizes.padding,
            4
        )
    }

    func test_toggleSizes_dotIconSize() {
        XCTAssertEqual(
            SwitchConstants.ToggleSizes.dotIconSize,
            14
        )
    }

    func test_toggleSizes_hoverPadding() {
        XCTAssertEqual(
            SwitchConstants.ToggleSizes.hoverPadding,
            4
        )
    }
}
