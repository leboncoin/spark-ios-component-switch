//
//  SwitchIntent.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 12/05/2023.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

/// The intent of the switch.
@available(*, deprecated, message: "There is no intent anymore for the switch !")
public enum SwitchIntent: CaseIterable {
    case alert
    case error
    case info
    case neutral
    case main
    case support
    case success
    case accent
    case basic
}
