//
//  SwitchStaticColors.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 02/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

@_spi(SI_SPI) import SparkTheming

struct SwitchStaticColors: Equatable {

    // MARK: - Properties

    var dotBackgroundColor: any ColorToken = ColorTokenClear()
    var textForegroundColor: any ColorToken = ColorTokenClear()
    var hoverColor: any ColorToken = ColorTokenClear()

    // MARK: - Equatable

    static func == (lhs: SwitchStaticColors, rhs: SwitchStaticColors) -> Bool {
        return lhs.dotBackgroundColor.equals(rhs.dotBackgroundColor) &&
        lhs.textForegroundColor.equals(rhs.textForegroundColor) &&
        lhs.hoverColor.equals(rhs.hoverColor)
    }
}
