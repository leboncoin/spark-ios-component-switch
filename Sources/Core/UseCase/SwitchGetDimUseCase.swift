//
//  SwitchGetDimUseCase.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 11/06/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import Foundation
import SparkTheming

// sourcery: AutoMockable, AutoMockTest
protocol SwitchGetDimUseCaseable {
    // sourcery: theme = "Identical"
    func execute(theme: Theme, isEnabled: Bool) -> CGFloat
}

final class SwitchGetDimUseCase: SwitchGetDimUseCaseable {

    // MARK: - Methods

    func execute(theme: Theme, isEnabled: Bool) -> CGFloat {
        return isEnabled ? theme.dims.none : theme.dims.dim3
    }
}
