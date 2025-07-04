//
//  SwitchGetShowSpaceUseCase.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 04/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import Foundation

// sourcery: AutoMockable, AutoMockTest
protocol SwitchGetShowSpaceUseCaseable {
    func execute(isOn: Bool) -> SwitchSpace
}

final class SwitchGetShowSpaceUseCase: SwitchGetShowSpaceUseCaseable {

    // MARK: - Methods

    func execute(isOn: Bool) -> SwitchSpace {
        return isOn ? .left : .right
    }
}
