//
//  SwitchGetColorUseCase.swift
//  SparkComponentSwitch
//
//  Created by robin.lemaire on 12/05/2023.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

import SparkTheming

// sourcery: AutoMockable
protocol SwitchGetColorUseCaseable {
    func execute(intent: SwitchIntent,
                 colors: Colors) -> any ColorToken
}

struct SwitchGetColorUseCase: SwitchGetColorUseCaseable {

    // MARK: - Methods

    func execute(
        intent: SwitchIntent,
        colors: Colors
    ) -> any ColorToken {
        switch intent {
        case .alert:
            return colors.feedback.alert

        case .error:
            return colors.feedback.error

        case .info:
            return colors.feedback.info

        case .neutral:
            return colors.feedback.neutral

        case .main:
            return colors.main.main

        case .support:
            return colors.support.support

        case .success:
            return colors.feedback.success

        case .accent:
            return colors.accent.accent

        case .basic:
            return colors.basic.basic
        }
    }
}
