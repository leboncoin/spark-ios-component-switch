//
//  SwitchGetShowHiddenEmptyLabelUseCase.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 22/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import Foundation

// sourcery: AutoMockable, AutoMockTest
protocol SwitchGetShowHiddenEmptyLabelUseCaseable {
    func execute(isCustomLabel: Bool) -> Bool
}

final class SwitchGetShowHiddenEmptyLabelUseCase: SwitchGetShowHiddenEmptyLabelUseCaseable {

    // MARK: - Methods

    func execute(isCustomLabel: Bool) -> Bool {
        return isCustomLabel
    }
}
