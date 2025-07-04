//
//  SwitchGetTitleFontUseCase.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 02/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import Foundation
import SparkTheming
import SwiftUI

// sourcery: AutoMockable, AutoMockTest
protocol SwitchGetTitleFontUseCaseable {
    // sourcery: theme = "Identical"
    func executeUI(theme: Theme) -> UIFont
    // sourcery: theme = "Identical"
    func execute(theme: Theme) -> Font
}

final class SwitchGetTitleFontUseCase: SwitchGetTitleFontUseCaseable {

    // MARK: - Methods

    func executeUI(theme: Theme) -> UIFont {
        self.execute(theme: theme).uiFont
    }

    func execute(theme: Theme) -> Font {
        self.execute(theme: theme).font
    }

    // MARK: - Private Methods

    private func execute(theme: Theme) -> any TypographyFontToken {
        theme.typography.body1
    }
}
