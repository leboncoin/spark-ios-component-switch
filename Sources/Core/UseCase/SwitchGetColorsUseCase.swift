//
//  SwitchGetColorUseCase.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 12/05/2023.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

import SparkTheming

// sourcery: AutoMockable, AutoMockTest
protocol SwitchGetColorsUseCaseable {
    // sourcery: theme = "Identical"
    @available(*, deprecated, message: "Not used anymore by SwitchViewModel or SwitchUIViewModel.")
    func execute(theme: Theme) -> SwitchColors

    // sourcery: theme = "Identical"
    func executeStatic(theme: Theme) -> SwitchStaticColors
    // sourcery: theme = "Identical"
    func executeDynamic(theme: Theme, isOn: Bool) -> SwitchDynamicColors
}

struct SwitchGetColorsUseCase: SwitchGetColorsUseCaseable {

    // MARK: - Methods

    func execute(theme: Theme) -> SwitchColors {
        let stateColor = theme.colors.basic.basic

        return .init(
            toggleBackgroundColors: .init(
                onColorToken: stateColor,
                offColorToken: stateColor.opacity(theme.dims.dim3))
            ,
            toggleDotForegroundColors: .init(
                onColorToken: stateColor,
                offColorToken: stateColor.opacity(theme.dims.dim2)
            ),
            toggleDotBackgroundColor: theme.colors.base.surface,
            textForegroundColor: theme.colors.base.onSurface
        )
    }

    func executeStatic(theme: Theme) -> SwitchStaticColors {
        let colors = theme.colors
        return .init(
            dotBackgroundColor: theme.colors.base.surface,
            textForegroundColor: theme.colors.base.onSurface,
            hoverColor: colors.basic.basicContainer
        )
    }

    func executeDynamic(theme: Theme, isOn: Bool) -> SwitchDynamicColors {
        let color = theme.colors.basic.basic
        return .init(
            backgroundColors: isOn ? color : color.opacity(theme.dims.dim3),
            dotForegroundColors: isOn ? color : color.opacity(theme.dims.dim2)
        )
    }
}
