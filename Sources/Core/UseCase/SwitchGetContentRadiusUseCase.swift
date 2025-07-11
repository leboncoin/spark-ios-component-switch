//
//  SwitchGetContentRadiusUseCase.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 02/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import Foundation
import SparkTheming
import SwiftUI

// sourcery: AutoMockable, AutoMockTest
protocol SwitchGetContentRadiusUseCaseable {
    // sourcery: theme = "Identical"
    func execute(theme: Theme) -> CGFloat
}

final class SwitchGetContentRadiusUseCase: SwitchGetContentRadiusUseCaseable {

    // MARK: - Methods

    func execute(theme: Theme) -> CGFloat {
        theme.border.radius.full
    }
}
