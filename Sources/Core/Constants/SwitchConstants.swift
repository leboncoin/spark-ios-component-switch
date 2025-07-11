//
//  SwitchConstants.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 12/05/2023.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

import Foundation

// TODO: test

enum SwitchConstants {
    /// Animation duration is 200ms
    static let animationDuration = 0.2

    /// Padding for toggle dot image
    static let toggleDotImagePadding: CGFloat = 5

    /// Toggles sizes
    enum ToggleSizes {
        /// Toggle width
        static let width: CGFloat = 56
        /// Toggle height
        static let height: CGFloat = 32
        /// Toggle size
        static let dotSize: CGFloat = Self.height
        /// Toggle size
        static let dotPressedSize: CGFloat = Self.width * 0.75
        /// Toggle size
        static let dotIncreasePressedSize: CGFloat = 10
        /// Toggle padding
        static let padding: CGFloat = 4 // TODO: deprecated ?
        /// Dot size
        static let dotIconSize: CGFloat = 14
        /// Hover padding
        static let hoverPadding: CGFloat = 4
    }
}
