//
//  SwitchGetToggleColorUseCase.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 23/05/2023.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

import SparkTheming

// sourcery: AutoMockable
@available(*, deprecated, message: "Not used anymore by SwitchViewModel or SwitchUIViewModel.")
protocol SwitchGetToggleColorUseCaseable {
    func execute(isOn: Bool,
                 statusAndStateColor: SwitchStatusColors) -> any ColorToken
}

struct SwitchGetToggleColorUseCase: SwitchGetToggleColorUseCaseable {

    // MARK: - Methods

    func execute(
        isOn: Bool,
        statusAndStateColor: SwitchStatusColors
    ) -> any ColorToken {
        return isOn ? statusAndStateColor.onColorToken : statusAndStateColor.offColorToken
    }
}
