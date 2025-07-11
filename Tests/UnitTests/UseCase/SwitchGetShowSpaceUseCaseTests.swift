//
//  SwitchGetShowSpaceUseCaseTests.swift
//  SparkSwitchTests
//
//  Created by robin.lemaire on 10/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import XCTest
@testable import SparkSwitch

final class SwitchGetShowSpaceUseCaseTests: XCTestCase {

    // MARK: - Tests

    func test_execute_whenIsOn_returnsLeft() {
        // GIVEN
        let useCase = SwitchGetShowSpaceUseCase()

        // WHEN
        let result = useCase.execute(isOn: true)

        // THEN
        XCTAssertEqual(result, .left)
    }

    func test_execute_whenIsOff_returnsRight() {
        // GIVEN
        let useCase = SwitchGetShowSpaceUseCase()

        // WHEN
        let result = useCase.execute(isOn: false)

        // THEN
        XCTAssertEqual(result, .right)
    }
}
