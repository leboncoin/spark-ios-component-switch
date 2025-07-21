//
//  SwitchGetAnimationTypeUseCase.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 07/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import Foundation
@_spi(SI_SPI) import SparkCommon

// sourcery: AutoMockable, AutoMockTest
protocol SwitchGetAnimationTypeUseCaseable {
    func execute(isOnAnimated: Bool, isReduceMotionEnabled: Bool) -> UIExecuteAnimationType
}

final class SwitchGetAnimationTypeUseCase: SwitchGetAnimationTypeUseCaseable {

    // MARK: - Methods

    func execute(isOnAnimated: Bool, isReduceMotionEnabled: Bool) -> UIExecuteAnimationType {
        isOnAnimated && !isReduceMotionEnabled ? .animated(duration: SwitchConstants.animationDuration) : .unanimated
    }
}
