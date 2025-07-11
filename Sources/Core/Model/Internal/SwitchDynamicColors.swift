//
//  SwitchDynamicColors.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 02/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

@_spi(SI_SPI) import SparkTheming

struct SwitchDynamicColors: Equatable {

    // MARK: - Properties

    var backgroundColors: any ColorToken = ColorTokenClear()
    var dotForegroundColors: any ColorToken = ColorTokenClear()

    // MARK: - Equatable

    static func == (lhs: SwitchDynamicColors, rhs: SwitchDynamicColors) -> Bool {
        return lhs.backgroundColors.equals(rhs.backgroundColors) &&
        lhs.dotForegroundColors.equals(rhs.dotForegroundColors)
    }
}

