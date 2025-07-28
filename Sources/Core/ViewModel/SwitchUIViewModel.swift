//
//  SwitchUIViewModel.swift
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
internal class SwitchUIViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var dynamicColors = SwitchDynamicColors()
    @Published private(set) var staticColors = SwitchStaticColors()
    @Published private(set) var contentRadius: CGFloat = 0
    @Published private(set) var dim: CGFloat = 1
    @Published private(set) var isIcon: Bool = false
    @Published private(set) var showSpace: SwitchSpace = .left
    @Published private(set) var spacing: CGFloat = 0
    @Published private(set) var titleFont: UIFont = .systemFont(ofSize: 14)

    // MARK: - Properties

    private var alreadyUpdateAll = false

    var theme: any Theme {
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

    private(set) var isOn: Bool = false  {
        didSet {
            guard oldValue != self.isOn, self.alreadyUpdateAll else { return }

            self.setDynamicColors()
            self.setShowSpace()
            self.setIsIcon()
        }
    }

    var isOnOffSwitchLabelsEnabled: Bool = false {
        didSet {
            guard oldValue != self.isOnOffSwitchLabelsEnabled, self.alreadyUpdateAll else { return }

            self.setIsIcon()
        }
    }

    var contrast: UIAccessibilityContrast = .unspecified {
        didSet {
            guard oldValue != self.contrast, self.alreadyUpdateAll else { return }

            self.setIsIcon()
        }
    }

    var isEnabled: Bool = true {
        didSet {
            guard oldValue != self.isEnabled, self.alreadyUpdateAll else { return }

            self.setDim()
        }
    }

    var isReduceMotionEnabled: Bool = false {
        didSet {
            guard oldValue != self.isReduceMotionEnabled, self.alreadyUpdateAll else { return }

            self.setAnimationType()
        }
    }

    private var isOnAnimated: Bool = true {
        didSet {
            guard oldValue != self.isOnAnimated, self.alreadyUpdateAll else { return }

            self.setAnimationType()
        }
    }

    private(set) var animationType: UIExecuteAnimationType = .unanimated

    // MARK: - Use Case Properties

    private let getAnimationTypeUseCase: SwitchGetAnimationTypeUseCaseable
    private let getColorsUseCase: SwitchGetColorsUseCaseable
    private let getContentRadiusUseCase: SwitchGetContentRadiusUseCaseable
    private let getDimUseCase: SwitchGetDimUseCaseable
    private let getIsIconUseCase: SwitchGetIsIconUseCaseable
    private let getShowSpaceUseCaseable: SwitchGetShowSpaceUseCaseable
    private let getSpacingUseCase: SwitchGetSpacingUseCaseable
    private let getTitleFontUseCase: SwitchGetTitleFontUseCaseable

    // MARK: - Initialization

    init(
        theme: any Theme,
        getAnimationTypeUseCase: SwitchGetAnimationTypeUseCaseable = SwitchGetAnimationTypeUseCase(),
        getColorsUseCase: SwitchGetColorsUseCaseable = SwitchGetColorsUseCase(),
        getContentRadiusUseCase: SwitchGetContentRadiusUseCaseable = SwitchGetContentRadiusUseCase(),
        getDimUseCase: SwitchGetDimUseCaseable = SwitchGetDimUseCase(),
        getIsIconUseCase: SwitchGetIsIconUseCaseable = SwitchGetIsIconUseCase(),
        getShowSpaceUseCaseable: SwitchGetShowSpaceUseCaseable = SwitchGetShowSpaceUseCase(),
        getSpacingUseCase: SwitchGetSpacingUseCaseable = SwitchGetSpacingUseCase(),
        getTitleFontUseCase: SwitchGetTitleFontUseCaseable = SwitchGetTitleFontUseCase()
    ) {
        self.theme = theme

        self.getAnimationTypeUseCase = getAnimationTypeUseCase
        self.getColorsUseCase = getColorsUseCase
        self.getContentRadiusUseCase = getContentRadiusUseCase
        self.getDimUseCase = getDimUseCase
        self.getIsIconUseCase = getIsIconUseCase
        self.getShowSpaceUseCaseable = getShowSpaceUseCaseable
        self.getSpacingUseCase = getSpacingUseCase
        self.getTitleFontUseCase = getTitleFontUseCase
    }

    // MARK: - Load

    func load(
        isOnOffSwitchLabelsEnabled: Bool,
        isReduceMotionEnabled: Bool,
        contrast: UIAccessibilityContrast
    ) {
        self.isOnOffSwitchLabelsEnabled = isOnOffSwitchLabelsEnabled
        self.isReduceMotionEnabled = isReduceMotionEnabled
        self.contrast = contrast

        self.setAnimationType()
        self.setDynamicColors()
        self.setStaticColors()
        self.setContentRadius()
        self.setDim()
        self.setFont()
        self.setIsIcon()
        self.setShowSpace()
        self.setSpacing()

        self.alreadyUpdateAll = true
    }

    // MARK: - Action

    func toggle() {
        if self.isEnabled {
            self.isOnAnimated = true
            self.isOn.toggle()
        }
    }

    func setIsOn(_ isOn: Bool, animated: Bool = false) {
        guard isOn != self.isOn else { return }

        self.isOnAnimated = animated
        self.isOn = isOn
    }

    // MARK: - Private Setter

    private func setDynamicColors() {
        self.dynamicColors = self.getColorsUseCase.executeDynamic(
            theme: self.theme,
            isOn: self.isOn
        )
    }

    private func setStaticColors() {
        self.staticColors = self.getColorsUseCase.executeStatic(theme: self.theme)
    }

    private func setContentRadius() {
        self.contentRadius = self.getContentRadiusUseCase.execute(theme: self.theme)
    }

    private func setDim() {
        self.dim = self.getDimUseCase.execute(
            theme: self.theme,
            isEnabled: self.isEnabled
        )
    }

    private func setFont() {
        self.titleFont = self.getTitleFontUseCase.executeUI(theme: self.theme)
    }

    private func setIsIcon() {
        self.isIcon = self.getIsIconUseCase.executeUI(
            isOnOffSwitchLabelsEnabled: self.isOnOffSwitchLabelsEnabled,
            contrast: self.contrast
        )
    }

    private func setShowSpace() {
        self.showSpace = self.getShowSpaceUseCaseable.execute(isOn: self.isOn)
    }

    private func setSpacing() {
        self.spacing = self.getSpacingUseCase.execute(theme: self.theme)
    }

    private func setAnimationType() {
        self.animationType = self.getAnimationTypeUseCase.execute(isOnAnimated: self.isOnAnimated, isReduceMotionEnabled: self.isReduceMotionEnabled)
    }
}
