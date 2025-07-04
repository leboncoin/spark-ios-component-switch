//
//  SwitchViewModelDeprecatedDependencies.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 03/07/2023.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

import Foundation
@_spi(SI_SPI) import SparkCommon

// sourcery: AutoMockable
protocol SwitchViewModelDeprecatedDependenciesProtocol {
    var getColorsUseCase: SwitchGetColorsUseCaseable { get }
    var getImagesStateUseCase: SwitchGetImagesStateUseCaseable { get }
    var getToggleColorUseCase: SwitchGetToggleColorUseCaseable { get }
    var getPositionUseCase: SwitchGetPositionUseCaseable { get }
    var getToggleStateUseCase: SwitchGetToggleStateUseCaseable { get }

    func makeDisplayedTextViewModel(text: String?,
                                    attributedText: AttributedStringEither?) -> DisplayedTextViewModel
}

struct SwitchViewModelDeprecatedDependencies: SwitchViewModelDeprecatedDependenciesProtocol {

    // MARK: - Properties

    let getColorsUseCase: SwitchGetColorsUseCaseable
    var getImagesStateUseCase: SwitchGetImagesStateUseCaseable
    let getToggleColorUseCase: SwitchGetToggleColorUseCaseable
    let getPositionUseCase: SwitchGetPositionUseCaseable
    let getToggleStateUseCase: SwitchGetToggleStateUseCaseable

    // MARK: - Initialization

    init(
        getColorsUseCase: SwitchGetColorsUseCaseable = SwitchGetColorsUseCase(),
        getImagesStateUseCase: SwitchGetImagesStateUseCaseable = SwitchGetImagesStateUseCase(),
        getToggleColorUseCase: SwitchGetToggleColorUseCaseable = SwitchGetToggleColorUseCase(),
        getPositionUseCase: SwitchGetPositionUseCaseable = SwitchGetPositionUseCase(),
        getToggleStateUseCase: SwitchGetToggleStateUseCaseable = SwitchGetToggleStateUseCase()
    ) {
        self.getColorsUseCase = getColorsUseCase
        self.getImagesStateUseCase = getImagesStateUseCase
        self.getToggleColorUseCase = getToggleColorUseCase
        self.getPositionUseCase = getPositionUseCase
        self.getToggleStateUseCase = getToggleStateUseCase
    }

    // MARK: - Maker

    func makeDisplayedTextViewModel(
        text: String?,
        attributedText: AttributedStringEither?
    ) -> DisplayedTextViewModel {
        return DisplayedTextViewModelDefault(
            text: text,
            attributedText: attributedText
        )
    }
}
