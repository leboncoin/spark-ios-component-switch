//
//  SwitchView.swift
//  SparkComponentSwitch
//
//  Created by robin.lemaire on 11/09/2023.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

import SwiftUI
@_spi(SI_SPI) import SparkCommon
import SparkTheming

public struct SwitchView: View {

    // MARK: - Type alias

    private typealias AccessibilityIdentifier = SwitchAccessibilityIdentifier
    private typealias Constants = SwitchConstants

    // MARK: - Properties

    @ObservedObject private var viewModel: SwitchViewModel

    @Binding private var isOn: Bool

    private var contentStackViewSpacingMultiplier: CGFloat = .scaledMetricMultiplier
    private var toggleHeight: CGFloat = Constants.ToggleSizes.height
    private var toggleWidth: CGFloat = Constants.ToggleSizes.width
    private var togglePadding: CGFloat = Constants.ToggleSizes.padding
    private var toggleDotPadding: CGFloat = Constants.toggleDotImagePadding

    // MARK: - Initialization

    /// Initialize a new switch view
    /// - Parameters:
    ///   - theme: The spark theme of the switch.
    ///   - intent: The intent of the switch.
    ///   - alignment: The alignment of the switch.
    ///   - isOn: The Binding value of the switch.
    public init(
        theme: any Theme,
        intent: SwitchIntent,
        alignment: SwitchAlignment,
        isOn: Binding<Bool>
    ) {
        self.viewModel = .init(
            for: .swiftUI,
            theme: theme,
            isOn: isOn.wrappedValue,
            alignment: alignment,
            intent: intent,
            isEnabled: true,
            images: nil,
            text: nil,
            attributedText: nil
        )
        self._isOn = isOn
    }

    // MARK: - View

    public var body: some View {
        HStack(alignment: .top) {
            ForEach(self.subviewsTypes(), id: \.self) {
                self.makeSubview(from: $0)
            }
        }
        .onChange(of: self.viewModel.isOnChanged) { isOn in
            guard let isOn else { return }
            self.isOn = isOn
        }
        .isEnabledChanged { isEnabled in
            self.viewModel.set(isEnabled: isEnabled)
        }
        .disabled(!self.viewModel.isEnabled)
    }

    // MARK: - Subview Maker

    private func subviewsTypes() -> [SwitchSubviewType] {
        return SwitchSubviewType.allCases(
            isLeftAlignment: self.viewModel.isToggleOnLeft == true,
            showSpace: self.viewModel.horizontalSpacing ?? 0 > 0
        )
    }

    @ViewBuilder
    private func makeSubview(from type: SwitchSubviewType) -> some View {
        switch type {
        case .space:
            self.space()
        case .text:
            self.text()
                .layoutPriority(1)
        case .toggle:
            self.toggle()
        }
    }

    // MARK: - Subview Builder

    @ViewBuilder
    private func text(isUsedForAlignment: Bool = false) -> some View {
        if let text = self.viewModel.displayedText?.text {
            Text(text)
                .font(self.viewModel.textFontToken?.font)
                .foregroundColor(self.viewModel.textForegroundColorToken?.color ?? .clear)
                .lineLimit(isUsedForAlignment: isUsedForAlignment)
                .applyStyle(isUsedForAlignment: isUsedForAlignment)
        } else if let attributedText = self.viewModel.displayedText?.attributedText?.rightValue {
            Text(attributedText)
                .lineLimit(isUsedForAlignment: isUsedForAlignment)
                .applyStyle(isUsedForAlignment: isUsedForAlignment)
        }
    }

    @ViewBuilder
    private func space() -> some View {
        Spacer()
            .frame(
                width: self.viewModel.horizontalSpacing.scaledMetric(
                    with: self.contentStackViewSpacingMultiplier
                )
            )
    }

    @ViewBuilder
    private func toggle() -> some View {
        ZStack {
            self.text(isUsedForAlignment: true)
                .frame(width: self.toggleWidth)
                .accessibilityHidden(true)
                .hidden()

            ZStack {
                RoundedRectangle(
                    cornerRadius: self.viewModel.theme.border.radius.full
                )
                .fill(self.viewModel.toggleBackgroundColorToken?.color ?? .clear)
                .opacity(self.viewModel.toggleOpacity ?? .zero)

                HStack {
                    // Left Space
                    if let showSpace = self.viewModel.showToggleLeftSpace,
                       showSpace {
                        Spacer()
                    }
                    ZStack {
                        // Dot
                        Circle()
                            .fill(self.viewModel.toggleDotBackgroundColorToken?.color ?? .clear)
                            .aspectRatio(1, contentMode: .fit)
                            .accessibilityIdentifier(AccessibilityIdentifier.toggleDotView)

                        ZStack {
                            // On icon
                            self.viewModel.toggleDotImagesState?.images.rightValue.on
                                .applyStyle(
                                    isForOnImage: true,
                                    viewModel: self.viewModel
                                )

                            // Off icon
                            self.viewModel.toggleDotImagesState?.images.rightValue.off
                                .applyStyle(
                                    isForOnImage: false,
                                    viewModel: self.viewModel
                                )
                        }
                        .opacity(self.viewModel.toggleOpacity ?? .zero)
                        .padding(.init(
                            all: self.toggleDotPadding
                        ))
                        .animation(
                            .custom,
                            value: self.viewModel.toggleDotImagesState
                        )
                    }

                    // Right Space
                    if let showSpace = self.viewModel.showToggleLeftSpace,
                       !showSpace {
                        Spacer()
                    }
                }
                .padding(.init(
                    all: self.togglePadding
                ))
                .animation(
                    .custom,
                    value: self.viewModel.showToggleLeftSpace
                )
            }
            .frame(
                width: self.toggleWidth,
                height: self.toggleHeight
            )
            .accessibilityAddTraits(self.getAccessibilityTraits())
            .accessibilityIdentifier(AccessibilityIdentifier.toggleView)
            .accessibilityValue(isOn ? "1" : "0")
            .accessibilityRepresentation {
                Toggle(isOn: $isOn) { }
            }
            .onTapGesture {
                withAnimation(.custom) {
                    self.viewModel.toggle()
                }
            }
        }
    }

    private func getAccessibilityTraits() -> AccessibilityTraits {
        var traits: AccessibilityTraits = [.isButton]
        if #available(iOS 17, *) {
            _ = traits.insert(.isToggle)
        }
        return traits
    }

    // MARK: - Modifier

    /// Set disabled
    /// - Parameters:
    ///   - isDisabled: true = disabled, false  = enabled
    public func disabled(_ isDisabled: Bool) -> Self {
        self.viewModel.set(isEnabled: !isDisabled)
        return self
    }

    /// Set the images on switch.
    /// - Parameters:
    ///   - images: The optional images of the switch.
    /// - Returns: Current Switch View.
    public func images(_ images: SwitchImages?) -> Self {
        self.viewModel.set(images: images.map { .right($0) })
        return self
    }

    /// Set the text of the switch.
    /// - Parameters:
    ///   - text: The optional text of the switch.
    /// - Returns: Current Switch View.
    public func text(_ text: String?) -> Self {
        self.viewModel.set(text: text)
        return self
    }

    /// Set the attributed text of the switch.
    /// - Parameters:
    ///   - text: The optional attributed text of the switch.
    /// - Returns: Current Switch View.
    public func attributedText(_ attributedText: AttributedString?) -> Self {
        self.viewModel.set(attributedText: attributedText.map { .right($0) })
        return self
    }
}

// MARK: - Extension

private extension Text {

    func lineLimit(isUsedForAlignment: Bool) -> some View {
        self.lineLimit(isUsedForAlignment ? 1 : nil)
    }
}

private extension View {

    func applyStyle(isUsedForAlignment: Bool) -> some View {
        return self.frame(
            maxHeight: isUsedForAlignment ? nil : .infinity,
            alignment: isUsedForAlignment ? .top : .center
        )
        .accessibilityIdentifier(SwitchAccessibilityIdentifier.text)
    }
}

private extension Image {

    @ViewBuilder
    func applyStyle(
        isForOnImage: Bool,
        viewModel: SwitchViewModel
    ) -> some View {
        if isForOnImage {
            self.applyImageStyle(viewModel: viewModel)
                .opacity(viewModel.toggleDotImagesState?.onImageOpacity ?? 0)
        } else {
            self.applyImageStyle(viewModel: viewModel)
                .opacity(viewModel.toggleDotImagesState?.offImageOpacity ?? 0)
        }
    }

    func applyImageStyle(viewModel: SwitchViewModel) -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(viewModel.toggleDotForegroundColorToken?.color)
            .accessibilityIdentifier(SwitchAccessibilityIdentifier.toggleDotImageView)
    }
}

private extension Animation {

    static var custom: Animation {
        return Animation.easeOut(duration: SwitchConstants.animationDuration)
    }
}
