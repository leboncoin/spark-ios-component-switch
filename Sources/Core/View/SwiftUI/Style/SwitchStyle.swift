//
//  SwitchStyle.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 02/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import SwiftUI
@_spi(SI_SPI) import SparkCommon

struct SwitchStyle: ToggleStyle {

    // MARK: - Type Alias

    private typealias ToggleConstants = SwitchConstants.ToggleSizes

    // MARK: - Properties

    private let viewModel: SwitchViewModel
    private let onIcon: Image
    private let offIcon: Image

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State var isPressed: Bool = false

    // MARK: - Initialization

    init(viewModel: SwitchViewModel, onIcon: Image, offIcon: Image) {
        self.viewModel = viewModel
        self.onIcon = onIcon
        self.offIcon = offIcon
    }

    // MARK: - Body

    func makeBody(configuration: Configuration) -> some View {
        ScaledHStack(alignment: .top, spacing: self.viewModel.spacing) {

            ZStack(alignment: .center) {
                configuration.label
                    .lineLimit(1)
                    .frame(width: ToggleConstants.width, alignment: .top)
                    .accessibilityHidden(true)
                    .hidden()

                // Toggle
                Button {
                    configuration.isOn.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: self.viewModel.contentRadius)
                        .fill(self.viewModel.dynamicColors.backgroundColors)
                        .overlay {
                            ZStack {
                                HStack(alignment: .center, spacing: 0) {
                                    if configuration.isOn {
                                        Spacer()
                                    }

                                    RoundedRectangle(cornerRadius: self.viewModel.contentRadius)
                                        .fill(self.viewModel.staticColors.dotBackgroundColor)
                                        .padding(ToggleConstants.padding)
                                        .frame(
                                            width: self.canChangeDotSize() ? ToggleConstants.dotPressedSize : ToggleConstants.dotSize
                                        )
                                        .overlay {
                                            if self.viewModel.isIcon {
                                                self.icon(configuration: configuration)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundStyle(self.viewModel.dynamicColors.dotForegroundColors)
                                                    .frame(size: ToggleConstants.dotIconSize)
                                            }
                                        }

                                    if !configuration.isOn {
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .opacity(self.viewModel.dim)
                        .frame(
                            width: ToggleConstants.width,
                            height: ToggleConstants.height
                        )
                        .transaction {
                            if self.reduceMotion {
                                $0.animation = nil
                            }
                        }
                        .overlay(
                            self.pressedView()
                        )
                }
                .buttonPressedStyle(self.$isPressed)
                .sensoryFeedback(trigger: configuration.isOn)
                .optionalAnimation(
                    .easeInOut(duration: SwitchConstants.animationDuration),
                    value: self.isPressed
                )
                .optionalAnimation(
                    .easeOut(duration: SwitchConstants.animationDuration),
                    value: configuration.isOn
                )
            }

            // Title
            configuration.label
                .font(self.viewModel.titleFont)
                .foregroundStyle(self.viewModel.staticColors.textForegroundColor)
                .frame(minHeight: ToggleConstants.height)
        }
    }

    // MARK: - Subview

    private func icon(configuration: Configuration) -> Image {
        if configuration.isOn {
            self.onIcon
        } else {
            self.offIcon
        }
    }

    @ViewBuilder func pressedView() -> some View {
        if self.isPressed {
            RoundedRectangle(cornerRadius: self.viewModel.contentRadius)
                .inset(by: -ToggleConstants.hoverPadding / 2)
                .stroke(self.viewModel.staticColors.hoverColor.color, lineWidth: ToggleConstants.hoverPadding)
        } else {
            EmptyView()
        }
    }

    // MARK: - Getter

    private func canChangeDotSize() -> Bool {
        self.isPressed && !self.reduceMotion
    }
}

// MARK: - Extension

extension ToggleStyle where Self == SwitchStyle {

    static func custom(viewModel: SwitchViewModel, onIcon: Image, offIcon: Image) -> SwitchStyle {
        .init(viewModel: viewModel, onIcon: onIcon, offIcon: offIcon)
    }
}

// MARK: - Private Extension

private extension View {

    func frame(size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }

    @ViewBuilder
    func sensoryFeedback<T>(trigger: T) -> some View where T: Equatable {
        if #available(iOS 17.0, *) {
            self.sensoryFeedback(.impact, trigger: trigger)
        } else {
            self
        }
    }

    @ViewBuilder
    func buttonPressedStyle(_ value: Binding<Bool>) -> some View {
        self.buttonStyle(PressedButtonStyle(isPressed: value))
    }
}
