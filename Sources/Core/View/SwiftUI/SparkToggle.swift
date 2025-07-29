//
//  SparkToggle.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 02/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import SwiftUI
@_spi(SI_SPI) import SparkCommon
import SparkTheming

/// A Spark control that toggles between on and off states.
///
/// There is some possibilities to init the component :
/// - Without title:
/// ```swift
/// struct MyView: View {
///     let theme: SparkTheming.Theme = MyTheme()
///     @State var isOn = false
///
///     var body: some View {
///         SparkToggle(
///             theme: self.theme,
///             isOn: self.$isOn,
///             onIcon: .init(systemName: "checkmark"),
///             offIcon: .init(systemName: "xmark")
///         )
///     }
/// ```
/// Toggle when isOn is **true** :
/// ![Toggle rendering.](component.png)
///
/// Toggle when isOn is **false**:
/// ![Toggle rendering.](component_disabled.png)
///
/// - With a localized string key or a string:
/// ```swift
/// struct MyView: View {
///     let theme: SparkTheming.Theme = MyTheme()
///     @State var isOn = false
///
///     var body: some View {
///         SparkToggle(
///             "My placeholder",
///             theme: self.theme,
///             isOn: self.$isOn,
///             onIcon: .init(systemName: "checkmark"),
///             offIcon: .init(systemName: "xmark")
///         )
///     }
/// ```
/// ![Toggle rendering with a title.](component_with_title.png)
///
/// ![Toggle rendering with a multiline text.](component_with_mutliline.png)
///
/// - With a custom Label:
/// **Use it carefully with Spark font and color !**
/// ```swift
/// struct MyView: View {
///     let theme: SparkTheming.Theme = MyTheme()
///     @State var isOn = false
///
///     var body: some View {
///         SparkToggle(
///             theme: self.theme,
///             isOn: self.$isOn,
///             onIcon: .init(systemName: "checkmark"),
///             offIcon: .init(systemName: "xmark"),
///             label: {
///                 VStack {
///                     Text("Hello")
///                     Text("World")
///                 }
///             }
///         )
///     }
/// ```
/// ![Toggle rendering with a Label.](component_with_label.png)
public struct SparkToggle<Label>: View where Label: View {

    // MARK: - Properties

    private let theme: Theme
    @Binding private var isOn: Bool
    private let onIcon: Image
    private let offIcon: Image
    private let label: () -> Label

    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.isEnabled) private var isEnabled

    @StateObject private var viewModel = SwitchViewModel()

    // MARK: - Initialization

    /// Creates a Spark toggle with an empty label.
    ///
    /// Note : You must provide an *accessibilityLabel* !
    ///
    /// - Parameters:
    ///   - theme: The current theme.
    ///   - isOn: A binding to a property that indicates whether the toggle is on or off.
    ///   - onIcon: The on icon. Displayed when the *UIAccessibility.isOnOffSwitchLabelsEnabled*
    ///   is **true** and the toogle is **on**.
    ///   - offIcon: The offIcon icon. Displayed when the *UIAccessibility.isOnOffSwitchLabelsEnabled*
    ///   is **true** and the toogle is **off**.
    ///
    /// Implementation example :
    /// ```swift
    /// struct MyView: View {
    ///     let theme: SparkTheming.Theme = MyTheme()
    ///     @State var isOn = false
    ///
    ///     var body: some View {
    ///         SparkToggle(
    ///             theme: self.theme,
    ///             isOn: self.$isOn,
    ///             onIcon: .init(systemName: "checkmark"),
    ///             offIcon: .init(systemName: "xmark")
    ///         )
    ///     }
    /// ```
    ///
    /// ![Toggle rendering.](component.png)
    public init(
        theme: Theme,
        isOn: Binding<Bool>,
        onIcon: Image,
        offIcon: Image
    ) where Label == EmptyView {
        self.theme = theme
        self._isOn = isOn
        self.onIcon = onIcon
        self.offIcon = offIcon
        self.label = { EmptyView() }
    }

    /// Creates a Spark toggle that generates its label from a localized string key.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the toggle's localized title, that describes
    ///     the purpose of the toggle.
    ///   - theme: The current theme.
    ///   - isOn: A binding to a property that indicates whether the toggle is on or off.
    ///   - onIcon: The on icon. Displayed when the *UIAccessibility.isOnOffSwitchLabelsEnabled*
    ///   is **true** and the toogle is **on**.
    ///   - offIcon: The offIcon icon. Displayed when the *UIAccessibility.isOnOffSwitchLabelsEnabled*
    ///   is **true** and the toogle is **off**.
    ///
    /// Implementation example :
    /// ```swift
    /// struct MyView: View {
    ///     let theme: SparkTheming.Theme = MyTheme()
    ///     @State var isOn = false
    ///
    ///     var body: some View {
    ///         SparkToggle(
    ///             "My placeholder",
    ///             theme: self.theme,
    ///             isOn: self.$isOn,
    ///             onIcon: .init(systemName: "checkmark"),
    ///             offIcon: .init(systemName: "xmark")
    ///         )
    ///     }
    /// ```
    ///
    /// ![Toggle rendering with a title.](component_with_title.png)
    public init(
        _ titleKey: LocalizedStringKey,
        theme: Theme,
        isOn: Binding<Bool>,
        onIcon: Image,
        offIcon: Image
    ) where Label == Text {
        self.theme = theme
        self._isOn = isOn
        self.onIcon = onIcon
        self.offIcon = offIcon
        self.label = { Text(titleKey) }
    }

    /// Creates a Spark toggle that generates its label from a string.
    ///
    /// - Parameters:
    ///   - text: The text for the toggle's localized title, that describes
    ///     the purpose of the toggle.
    ///   - theme: The current theme.
    ///   - isOn: A binding to a property that indicates whether the toggle is on or off.
    ///   - onIcon: The on icon. Displayed when the *UIAccessibility.isOnOffSwitchLabelsEnabled*
    ///   is **true** and the toogle is **on**.
    ///   - offIcon: The offIcon icon. Displayed when the *UIAccessibility.isOnOffSwitchLabelsEnabled*
    ///   is **true** and the toogle is **off**.
    ///
    /// Implementation example :
    /// ```swift
    /// struct MyView: View {
    ///     let theme: SparkTheming.Theme = MyTheme()
    ///     @State var isOn = false
    ///
    ///     var body: some View {
    ///         SparkToggle(
    ///             "My placeholder",
    ///             theme: self.theme,
    ///             isOn: self.$isOn,
    ///             onIcon: .init(systemName: "checkmark"),
    ///             offIcon: .init(systemName: "xmark")
    ///         )
    ///     }
    /// ```
    ///
    /// ![Toggle rendering with a title.](component_with_title.png)
    public init(
        _ text: String,
        theme: Theme,
        isOn: Binding<Bool>,
        onIcon: Image,
        offIcon: Image
    ) where Label == Text {
        self.theme = theme
        self._isOn = isOn
        self.onIcon = onIcon
        self.offIcon = offIcon
        self.label = { Text(text) }
    }

    /// Creates a Spark toggle that displays a custom label.
    ///
    /// - Parameters:
    ///   - theme: The current theme.
    ///   - isOn: A binding to a property that indicates whether the toggle is on or off.
    ///   - onIcon: The on icon. Displayed when the *UIAccessibility.isOnOffSwitchLabelsEnabled*
    ///   is **true** and the toogle is **on**.
    ///   - offIcon: The offIcon icon. Displayed when the *UIAccessibility.isOnOffSwitchLabelsEnabled*
    ///   is **true** and the toogle is **off**.
    ///   - label: A view that describes the purpose of the toggle.
    ///
    /// Implementation example :
    /// ```swift
    /// struct MyView: View {
    ///     let theme: SparkTheming.Theme = MyTheme()
    ///     @State var isOn = false
    ///
    ///     var body: some View {
    ///         SparkToggle(
    ///             theme: self.theme,
    ///             isOn: self.$isOn,
    ///             onIcon: .init(systemName: "checkmark"),
    ///             offIcon: .init(systemName: "xmark"),
    ///             label: {
    ///                 VStack {
    ///                     Text("Hello")
    ///                     Text("World")
    ///                 }
    ///             }
    ///         )
    ///     }
    /// ```
    /// ![Toggle rendering with a Label.](component_with_label.png)
    public init(
        theme: Theme,
        isOn: Binding<Bool>,
        onIcon: Image,
        offIcon: Image,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.theme = theme
        self._isOn = isOn
        self.onIcon = onIcon
        self.offIcon = offIcon
        self.label = label
    }

    // MARK: - View

    public var body: some View {
        Toggle(isOn: self.$isOn, label: self.label)
            .toggleStyle(.custom(
                viewModel: self.viewModel,
                onIcon: self.onIcon,
                offIcon: self.offIcon
            ))
            .accessibilityIdentifier(SwitchAccessibilityIdentifier.view)
            .onAppear() {
                self.viewModel.setup(
                    theme: self.theme,
                    isOn: self.isOn,
                    isOnOffSwitchLabelsEnabled: UIAccessibility.isOnOffSwitchLabelsEnabled,
                    contrast: self.contrast,
                    isEnabled: self.isEnabled,
                    isCustomLabel: Label.self != EmptyView.self && Label.self != Text.self
                )
            }
            .onChange(of: self.isOn) { isOn in
                self.viewModel.isOn = isOn
            }
            .onChange(of: UIAccessibility.isOnOffSwitchLabelsEnabled) { isOnOffSwitchLabelsEnabled in
                self.viewModel.isOnOffSwitchLabelsEnabled = isOnOffSwitchLabelsEnabled
            }
            .onChange(of: self.contrast) { contrast in
                self.viewModel.contrast = contrast
            }
            .onChange(of: self.isEnabled) { isEnabled in
                self.viewModel.isEnabled = isEnabled
            }
    }
}
