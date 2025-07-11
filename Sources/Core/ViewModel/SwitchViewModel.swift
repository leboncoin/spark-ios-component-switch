//
//  SwitchViewModel.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 02/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import SwiftUI
@_spi(SI_SPI) import SparkCommon
import SparkTheming

/// ViewModel only used by **SwiftUI** View.
// sourcery: AutoPublisherTest, AutoViewModelStub
internal class SwitchViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var dynamicColors = SwitchDynamicColors()
    @Published private(set) var staticColors = SwitchStaticColors()
    @Published private(set) var contentRadius: CGFloat = 0
    @Published private(set) var dim: CGFloat = 1
    @Published private(set) var titleFont: Font = .body
    @Published private(set) var isIcon: Bool = false
    @Published private(set) var spacing: CGFloat = 0

    // MARK: - Properties

    private var alreadyUpdateAll = false

    var theme: (any Theme)? {
        didSet {
            guard self.alreadyUpdateAll else { return }

            self.setDynamicColors()
            self.setStaticColors()
            self.setContentRadius()
            self.setDim()
            self.setFont()
            self.setSpacing()
        }
    }

    var isOn: Bool? {
        didSet {
            guard oldValue != self.isOn, self.alreadyUpdateAll else { return }

            self.setDynamicColors()
        }
    }

    var isOnOffSwitchLabelsEnabled: Bool? {
        didSet {
            guard oldValue != self.isOnOffSwitchLabelsEnabled, self.alreadyUpdateAll else { return }

            self.setIsIcon()
        }
    }

    var contrast: ColorSchemeContrast? {
        didSet {
            guard oldValue != self.contrast, self.alreadyUpdateAll else { return }

            self.setIsIcon()
        }
    }

    var isEnabled: Bool? {
        didSet {
            guard oldValue != self.isEnabled, self.alreadyUpdateAll else { return }

            self.setDim()
        }
    }

    // MARK: - Use Case Properties

    private let getColorsUseCase: SwitchGetColorsUseCaseable
    private let getContentRadiusUseCase: SwitchGetContentRadiusUseCaseable
    private let getDimUseCase: SwitchGetDimUseCaseable
    private let getTitleFontUseCase: SwitchGetTitleFontUseCaseable
    private let getIsIconUseCase: SwitchGetIsIconUseCaseable
    private let getSpacingUseCase: SwitchGetSpacingUseCaseable

    // MARK: - Initialization

    init(
        getColorsUseCase: SwitchGetColorsUseCaseable = SwitchGetColorsUseCase(),
        getContentRadiusUseCase: SwitchGetContentRadiusUseCaseable = SwitchGetContentRadiusUseCase(),
        getDimUseCase: SwitchGetDimUseCaseable = SwitchGetDimUseCase(),
        getTitleFontUseCase: SwitchGetTitleFontUseCaseable = SwitchGetTitleFontUseCase(),
        getIsIconUseCase: SwitchGetIsIconUseCaseable = SwitchGetIsIconUseCase(),
        getSpacingUseCase: SwitchGetSpacingUseCaseable = SwitchGetSpacingUseCase()
    ) {
        self.getColorsUseCase = getColorsUseCase
        self.getContentRadiusUseCase = getContentRadiusUseCase
        self.getDimUseCase = getDimUseCase
        self.getTitleFontUseCase = getTitleFontUseCase
        self.getIsIconUseCase = getIsIconUseCase
        self.getSpacingUseCase = getSpacingUseCase
    }

    // MARK: - Setup

    func setup(
        theme: Theme,
        isOn: Bool,
        isOnOffSwitchLabelsEnabled: Bool,
        contrast: ColorSchemeContrast,
        isEnabled: Bool
    ) {
        self.theme = theme
        self.isOn = isOn
        self.isOnOffSwitchLabelsEnabled = isOnOffSwitchLabelsEnabled
        self.contrast = contrast
        self.isEnabled = isEnabled

        self.setDynamicColors()
        self.setStaticColors()
        self.setContentRadius()
        self.setDim()
        self.setFont()
        self.setIsIcon()
        self.setSpacing()

        self.alreadyUpdateAll = true
    }

    // MARK: - Private Setter

    private func setDynamicColors() {
        guard let theme, let isOn else {
            return
        }

        self.dynamicColors = self.getColorsUseCase.executeDynamic(
            theme: theme,
            isOn: isOn
        )
    }

    private func setStaticColors() {
        guard let theme else {
            return
        }

        self.staticColors = self.getColorsUseCase.executeStatic(theme: theme)
    }

    private func setContentRadius() {
        guard let theme else {
            return
        }

        self.contentRadius = self.getContentRadiusUseCase.execute(theme: theme)
    }

    private func setDim() {
        guard let theme, let isEnabled else {
            return
        }

        self.dim = self.getDimUseCase.execute(
            theme: theme,
            isEnabled: isEnabled
        )
    }

    private func setFont() {
        guard let theme else {
            return
        }

        self.titleFont = self.getTitleFontUseCase.execute(theme: theme)
    }

    private func setIsIcon() {
        guard let isOnOffSwitchLabelsEnabled, let contrast else {
            return
        }

        self.isIcon = self.getIsIconUseCase.execute(
            isOnOffSwitchLabelsEnabled: isOnOffSwitchLabelsEnabled,
            contrast: contrast
        )
    }

    private func setSpacing() {
        guard let theme else {
            return
        }

        self.spacing = self.getSpacingUseCase.execute(theme: theme)
    }
}
