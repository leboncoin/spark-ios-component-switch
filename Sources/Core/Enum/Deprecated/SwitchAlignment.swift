//
//  SwitchAlignment.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 12/05/2023.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

/// The alignment of the switch.
@available(*, deprecated, message: "There is no alignment anymore for the switch to respect accessibility recommandation !")
public enum SwitchAlignment: CaseIterable {
    /// Switch is on the left, text is on the right
    case left
    /// Switch is on the right, text is on the left
    case right
}
