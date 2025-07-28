//
//  SparkUISwitch.swift
//  SparkSwitch
//
//  Created by robin.lemaire on 04/07/2025.
//  Copyright © 2025 Leboncoin. All rights reserved.
//

import UIKit
import Combine
import SwiftUI
@_spi(SI_SPI) import SparkCommon
import SparkTheming

/// A Spark control that offers a binary choice, such as on/off.
///
/// This component inherits from **UIControl**.
///
/// Initialization :
/// ```swift
/// let theme: SparkTheming.Theme = MyTheme()
///
/// let mySwitch = SparkUISwitch(
///     theme: self.theme,
///     onIcon: .init(systemName: "checkmark")!,
///     offIcon: .init(systemName: "xmark")!
/// )
/// ```
///
/// Toggle when isOn is **true** :
/// ![Toggle rendering.](component.png)
///
/// Toggle when isOn is **false**:
/// ![Toggle rendering.](component_disabled.png)
///
/// To add a text, you must provide a **text** or a **attributedText**:
/// ```swift
/// let theme: SparkTheming.Theme = MyTheme()
///
/// let mySwitch = SparkUISwitch(
///     theme: self.theme,
///     onIcon: .init(systemName: "checkmark")!,
///     offIcon: .init(systemName: "xmark")!
/// )
/// mySwitch.text = "My switch"
/// ```
/// *Note*: Please **do not set a text/attributedText** on the ``textLabel`` but use the ``text`` and
/// ``attributedText`` directly on the ``SparkUISwitch``.
/// ![Toggle rendering with a text.](component_with_title.png)
///
/// ![Toggle rendering with a multiline text.](component_with_mutliline.png)
public final class SparkUISwitch: UIControl {

    // MARK: - Type alias

    private typealias AccessibilityIdentifier = SwitchAccessibilityIdentifier
    private typealias Constants = SwitchConstants

    // MARK: - Components

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                self.toggleContentView,
                self.textLabel
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.isBaselineRelativeArrangement = true

        return stackView
    }()

    // This view (and the label subview) is needed to align
    // the toggle to the first line of the textLabel. (required when accessibility
    // dynamic type is enabled)
    private lazy var toggleContentView: UIView = {
        let view = UIView()
        view.addSubview(self.toggleHidenLabel)
        view.addSubview(self.toggleView)
        return view
    }()

    private lazy var toggleHidenLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = self.textLabel.adjustsFontForContentSizeCategory
        label.isHidden = true
        return label
    }()

    private lazy var toggleView: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = AccessibilityIdentifier.toggleView
        view.addSubview(self.toggleContentStackView)
        view.isUserInteractionEnabled = true
        view.setContentCompressionResistancePriority(.required,
                                                     for: .vertical)
        view.setContentCompressionResistancePriority(.required,
                                                     for: .horizontal)
        view.isAccessibilityElement = true
        return view
    }()

    private lazy var toggleContentStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews:
                [
                    self.toggleLeftSpaceView,
                    self.toggleDotView,
                    self.toggleRightSpaceView
                ]
        )
        stackView.axis = .horizontal
        stackView.isUserInteractionEnabled = false
        stackView.accessibilityElementsHidden = true
        return stackView
    }()

    private let toggleLeftSpaceView = UIView()

    private lazy var toggleDotView: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = AccessibilityIdentifier.toggleDotView
        view.addSubview(self.toggleDotImageView)
        return view
    }()

    private var toggleDotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = AccessibilityIdentifier.toggleDotImageView
        return imageView
    }()

    private let toggleRightSpaceView = UIView()

    /// The UILabel used to display the switch text.
    ///
    /// Please **do not set a text/attributedText** in this label but use
    /// the ``text`` and ``attributedText`` directly on the ``SparkUISwitch``.
    public var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = AccessibilityIdentifier.text
        label.setContentCompressionResistancePriority(.required,
                                                      for: .vertical)
        label.isUserInteractionEnabled = false
        label.isAccessibilityElement = false
        return label
    }()

    // MARK: - Public Properties

    private let isOnChangedSubject = PassthroughSubject<Bool, Never>()
    /// The publisher used to notify when isOn value changed on switch.
    public private(set) lazy var isOnChangedPublisher: AnyPublisher<Bool, Never> = self.isOnChangedSubject.eraseToAnyPublisher()

    /// The spark theme of the switch.
    public var theme: Theme {
        get {
            return self.viewModel.theme
        }
        set {
            self.viewModel.theme = newValue
        }
    }

    /// The value of the switch (retrieve and set without animation).
    ///
    ///
    /// Toggle when isOn is **true** :
    /// ![Toggle rendering.](component.png)
    ///
    /// Toggle when isOn is **false**:
    /// ![Toggle rendering.](component_disabled.png)
    public var isOn: Bool {
        get {
            return self.viewModel.isOn
        }
        set {
            self.viewModel.setIsOn(newValue)
            self.updateAccessibilityValue()
        }
    }

    /// The text of the switch.
    public var text: String? {
        get {
            return self.textLabel.text
        }
        set {
            self.textLabel.isHidden = newValue == nil
            self.textLabel.attributedText = nil
            self.textLabel.text = newValue
            self.toggleHidenLabel.text = newValue
            self.invalidateIntrinsicContentSize()

            self.toggleView.accessibilityLabel = newValue
        }
    }

    /// The attributed text of the switch.
    public var attributedText: NSAttributedString? {
        get {
            return self.textLabel.attributedText
        }
        set {
            self.textLabel.isHidden = newValue == nil
            self.textLabel.text = nil
            self.textLabel.attributedText = newValue
            self.toggleHidenLabel.attributedText = newValue
            self.invalidateIntrinsicContentSize()

            self.toggleView.accessibilityLabel = newValue?.string
        }
    }

    /// The state of the switch: enabled or not.
    /// ![Toggle rendering with when it's disabled.](component_disabled.png)
    public override var isEnabled: Bool {
        get {
            return self.viewModel.isEnabled
        }
        set {
            self.viewModel.isEnabled = newValue
            self.updateToggleViewUserInteractionEnabled()
            self.updateAccessibilityEnabledTrait()
        }
    }

    // MARK: - Private Properties

    private let viewModel: SwitchUIViewModel

    private var toggleWidthConstraint: NSLayoutConstraint?
    private var toggleHeightConstraint: NSLayoutConstraint?

    private var toggleContentLeadingConstraint: NSLayoutConstraint?
    private var toggleContentTopConstraint: NSLayoutConstraint?
    private var toggleContentTrailingConstraint: NSLayoutConstraint?
    private var toggleContentBottomConstraint: NSLayoutConstraint?

    private var toggleDotWidthConstraint: NSLayoutConstraint?
    private var toggleDotLeadingConstraint: NSLayoutConstraint?
    private var toggleDotTopConstraint: NSLayoutConstraint?
    private var toggleDotTrailingConstraint: NSLayoutConstraint?
    private var toggleDotBottomConstraint: NSLayoutConstraint?

    private let toggleHeight: CGFloat = Constants.ToggleSizes.height
    private let toggleWidth: CGFloat = Constants.ToggleSizes.width
    private let toggleSpacing: CGFloat = Constants.ToggleSizes.padding
    private let toggleDotSpacing: CGFloat = Constants.toggleDotImagePadding

    private let onIcon: UIImage
    private let offIcon: UIImage

    private var isReduceMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    private var hoverToggleLayer: CAShapeLayer?

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Creates a Spark switch.
    ///
    /// Note : You must provide an *accessibilityLabel* !
    ///
    /// - Parameters:
    ///   - theme: The current theme.
    ///   - onIcon: The on icon. Displayed when the *UIAccessibility.isOnOffSwitchLabelsEnabled*
    ///   is **true** and the toogle is **on**.
    ///   - offIcon: The offIcon icon. Displayed when the *UIAccessibility.isOnOffSwitchLabelsEnabled*
    ///   is **true** and the toogle is **off**.
    ///
    /// Implementation example :
    /// ```swift
    /// let theme: SparkTheming.Theme = MyTheme()
    ///
    /// let mySwitch = SparkUISwitch(
    ///     theme: self.theme,
    ///     onIcon: .init(systemName: "checkmark")!,
    ///     offIcon: .init(systemName: "xmark")!
    /// )
    /// ```
    ///
    /// ![Toggle rendering.](component.png)
    public init(
        theme: Theme,
        onIcon: UIImage,
        offIcon: UIImage
    ) {
        self.viewModel = .init(
            theme: theme
        )

        self.onIcon = onIcon
        self.offIcon = offIcon

        super.init(frame: .zero)

        // Setup
        self.setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    deinit {
        // Remove notifications
        NotificationCenter.default.removeObserver(
            self,
            name: UIAccessibility.onOffSwitchLabelsDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil
        )
    }

    // MARK: - View setup

    private func setupView() {
        // Add subview
        self.addSubview(self.contentStackView)

        // View properties
        self.backgroundColor = .clear

        // Setup gestures
        self.setupGesturesRecognizer()

        // Setup constraints
        self.setupConstraints()

        // Setup publisher subcriptions
        self.setupSubscriptions()

        // Setup Notification
        self.setupNotifications()

        // Setup Accessibility
        self.setupAccessibility()

        // Updates
        self.updateToggleContentViewSpacings()
        self.updateToggleViewSize()
        self.updateToggleDotImageViewSpacings()

        // Load view model
        self.viewModel.load(
            isOnOffSwitchLabelsEnabled: UIAccessibility.isOnOffSwitchLabelsEnabled,
            isReduceMotionEnabled: UIAccessibility.isReduceMotionEnabled,
            contrast: self.traitCollection.accessibilityContrast
        )
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.updateCornerRadius()
    }

    // MARK: - Instrinsic Content Size

    public override var intrinsicContentSize: CGSize {
        // Calculate height
        let toggleHeight = self.toggleHeight
        let labelHeight = self.textLabel.intrinsicContentSize.height
        let height = max(toggleHeight, labelHeight)

        // Calculate width
        let toggleWidth = self.toggleWidth
        let contentStackViewSpacing = self.viewModel.spacing
        var width = toggleWidth + contentStackViewSpacing

        if let attributedText {
            let computedSize = attributedText.boundingRect(
                with: CGSize(
                    width: CGFloat.greatestFiniteMagnitude,
                    height: CGFloat.greatestFiniteMagnitude
                ),
                options: .usesLineFragmentOrigin,
                context: nil)
            width += computedSize.width
        } else if text != nil {
            width += self.textLabel.intrinsicContentSize.width
        }
        return CGSize(width: width, height: height)
    }

    public override func invalidateIntrinsicContentSize() {
        self.textLabel.invalidateIntrinsicContentSize()

        super.invalidateIntrinsicContentSize()
    }

    // MARK: - Gesture

    private func setupGesturesRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.toggleLongGestureAction))
        gestureRecognizer.minimumPressDuration = 0
        self.toggleView.addGestureRecognizer(gestureRecognizer)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        // Global
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupContentStackViewConstraints()

        // Toggle View and subviews
        self.setupToggleContentViewConstraints()
        self.setupToggleHidenLabelConstraints()
        self.setupToggleViewConstraints()
        self.setupToggleContentStackViewConstraints()
        self.setupToggleDotViewConstraints()
        self.setupToggleDotImageViewConstraints()

        // Text Label
        self.setupTextLabelContraints()
    }

    private func setupContentStackViewConstraints() {
        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.stickEdges(
            from: self.contentStackView,
            to: self,
            insets: .zero
        )
    }

    private func setupToggleContentViewConstraints() {
        self.toggleContentView.translatesAutoresizingMaskIntoConstraints = false

        self.toggleContentView.heightAnchor.constraint(greaterThanOrEqualTo: self.toggleView.heightAnchor).isActive = true
    }

    private func setupToggleHidenLabelConstraints() {
        self.toggleHidenLabel.translatesAutoresizingMaskIntoConstraints = false

        self.toggleHidenLabel.heightAnchor.constraint(greaterThanOrEqualTo: self.toggleView.heightAnchor).isActive = true
        NSLayoutConstraint.stickEdges(
            from: self.toggleHidenLabel,
            to: self.toggleContentView
        )
    }

    private func setupToggleViewConstraints() {
        self.toggleView.translatesAutoresizingMaskIntoConstraints = false

        self.toggleWidthConstraint = self.toggleView.widthAnchor.constraint(equalToConstant: .zero)
        self.toggleHeightConstraint = self.toggleView.heightAnchor.constraint(equalToConstant: .zero)

        self.toggleView.trailingAnchor.constraint(equalTo: self.toggleContentView.trailingAnchor).isActive = true
        self.toggleView.leadingAnchor.constraint(equalTo: self.toggleContentView.leadingAnchor).isActive = true
        NSLayoutConstraint.center(
            from: self.toggleView,
            to: self.toggleContentView
        )
    }

    private func setupToggleContentStackViewConstraints() {
        self.toggleContentStackView.translatesAutoresizingMaskIntoConstraints = false

        self.toggleContentLeadingConstraint = self.toggleContentStackView.leadingAnchor.constraint(equalTo: self.toggleView.leadingAnchor)
        self.toggleContentLeadingConstraint?.isActive = true
        self.toggleContentTopConstraint = self.toggleContentStackView.topAnchor.constraint(equalTo: self.toggleView.topAnchor)
        self.toggleContentTopConstraint?.isActive = true
        self.toggleContentTrailingConstraint = self.toggleContentStackView.trailingAnchor.constraint(equalTo: self.toggleView.trailingAnchor)
        self.toggleContentTrailingConstraint?.isActive = true
        self.toggleContentBottomConstraint = self.toggleContentStackView.bottomAnchor.constraint(equalTo: self.toggleView.bottomAnchor)
        self.toggleContentBottomConstraint?.isActive = true
    }

    private func setupToggleDotViewConstraints() {
        self.toggleDotView.translatesAutoresizingMaskIntoConstraints = false

        self.toggleDotWidthConstraint = self.toggleDotView.widthAnchor.constraint(equalTo: self.toggleDotView.heightAnchor)
        self.toggleDotWidthConstraint?.isActive = true
    }

    private func setupToggleDotImageViewConstraints() {
        self.toggleDotImageView.translatesAutoresizingMaskIntoConstraints = false

        self.toggleDotLeadingConstraint = self.toggleDotImageView.leadingAnchor.constraint(equalTo: self.toggleDotView.leadingAnchor)
        self.toggleDotLeadingConstraint?.isActive = true
        self.toggleDotTopConstraint = self.toggleDotImageView.topAnchor.constraint(equalTo: self.toggleDotView.topAnchor)
        self.toggleDotTopConstraint?.isActive = true
        self.toggleDotTrailingConstraint = self.toggleDotImageView.trailingAnchor.constraint(equalTo: self.toggleDotView.trailingAnchor)
        self.toggleDotTrailingConstraint?.isActive = true
        self.toggleDotBottomConstraint = self.toggleDotImageView.bottomAnchor.constraint(equalTo: self.toggleDotView.bottomAnchor)
        self.toggleDotBottomConstraint?.isActive = true
    }

    private func setupTextLabelContraints() {
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.heightAnchor.constraint(greaterThanOrEqualTo: self.toggleView.heightAnchor).isActive = true
    }

    // MARK: - Notification

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onOffSwitchLabelsDidChangeAction(_:)),
            name: UIAccessibility.onOffSwitchLabelsDidChangeNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reduceMotionStatusDidChangeAction(_:)),
            name: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil
        )
    }

    // MARK: - Setter

    /// Sets the state of the switch to the on or off position, optionally animating the transition.
    public func setOn(_ isOn: Bool, animated: Bool) {
        self.viewModel.setIsOn(
            isOn,
            animated: animated
        )

        self.updateAccessibilityValue()
    }

    // MARK: - Actions

    @objc private func toggleLongGestureAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began where !self.isReduceMotionEnabled:
            UIView.execute(animationType: self.viewModel.animationType) { [weak self] in
                guard let self else { return }

                self.toggleDotWidthConstraint?.constant = Constants.ToggleSizes.dotIncreasePressedSize
                self.updateHover(show: true)
                self.layoutIfNeeded()
            }

        case .ended:
            self.toggle()

            UIView.execute(animationType: self.viewModel.animationType) { [weak self] in
                guard let self else { return }

                self.toggleDotWidthConstraint?.constant = 0
                self.updateHover(show: false)
                self.layoutIfNeeded()
            }

        default: break
        }
    }

    private func toggle() {
        self.viewModel.toggle()

        // Accessibility
        self.updateAccessibilityValue()

        // Action
        self.sendActions(for: .valueChanged)
        self.isOnChangedSubject.send(self.isOn)

        // Haptic
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc private func onOffSwitchLabelsDidChangeAction(_ notification: Notification) {
        self.viewModel.isOnOffSwitchLabelsEnabled = UIAccessibility.isOnOffSwitchLabelsEnabled
    }

    @objc private func reduceMotionStatusDidChangeAction(_ notification: Notification) {
        self.viewModel.isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
    }

    // MARK: - Update UI

    private func updateToggleContentViewSpacings() {
        // Reload spacing only if value changed
        if self.toggleSpacing != self.toggleContentLeadingConstraint?.constant {

            self.toggleContentLeadingConstraint?.constant = self.toggleSpacing
            self.toggleContentTopConstraint?.constant = self.toggleSpacing
            self.toggleContentTrailingConstraint?.constant = -self.toggleSpacing
            self.toggleContentBottomConstraint?.constant = -self.toggleSpacing

            self.toggleContentStackView.updateConstraintsIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }

    private func updateToggleViewSize() {
        // Reload size only if value changed
        var valueChanged = false

        if self.toggleWidth > 0 && self.toggleWidth != self.toggleWidthConstraint?.constant {
            self.toggleWidthConstraint?.constant = self.toggleWidth
            self.toggleWidthConstraint?.isActive = true
            valueChanged = true
        }

        if self.toggleHeight > 0 && self.toggleHeight != self.toggleHeightConstraint?.constant {
            self.toggleHeightConstraint?.constant = self.toggleHeight
            self.toggleHeightConstraint?.isActive = true
            valueChanged = true
        }
        if valueChanged {
            self.toggleView.updateConstraints()
            self.invalidateIntrinsicContentSize()
        }
    }

    private func updateToggleDotImageViewSpacings() {
        // Reload spacing only if value changed
        if self.toggleDotSpacing != self.toggleDotLeadingConstraint?.constant {
            self.toggleDotLeadingConstraint?.constant = self.toggleDotSpacing
            self.toggleDotTopConstraint?.constant = self.toggleDotSpacing
            self.toggleDotTrailingConstraint?.constant = -self.toggleDotSpacing
            self.toggleDotBottomConstraint?.constant = -self.toggleDotSpacing

            self.toggleDotImageView.updateConstraintsIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }

    private func updateCornerRadius(_ value: CGFloat? = nil) {
        self.toggleView.layoutIfNeeded()

        self.toggleView.setCornerRadius(value ?? self.viewModel.contentRadius)
        self.toggleDotView.setCornerRadius(value ?? self.viewModel.contentRadius)
    }

    private func updateHover(show: Bool) {
        if show {
            let width = Constants.ToggleSizes.hoverPadding
            let inset = -width / 2

            let path = UIBezierPath(
                roundedRect: self.toggleView.bounds.insetBy(dx: inset, dy: inset),
                byRoundingCorners: [.topLeft, .bottomLeft, .topRight, .bottomRight],
                cornerRadii: CGSize(width: self.toggleView.frame.size.height / 2, height: self.toggleView.frame.size.height / 2)
            )

            let shape = CAShapeLayer()
            shape.lineWidth = width
            shape.path = path.cgPath
            shape.strokeColor = self.viewModel.staticColors.hoverColor.uiColor.cgColor
            shape.fillColor = UIColor.clear.cgColor

            self.toggleView.layer.insertSublayer(shape, at: 0)
            self.hoverToggleLayer = shape

        } else if let hoverToggleLayer {
            hoverToggleLayer.removeFromSuperlayer()
        }
    }

    private func updateToggleViewUserInteractionEnabled() {
        self.toggleView.isUserInteractionEnabled = self.isEnabled
    }

    // MARK: - Accessibility

    private func setupAccessibility() {
        self.toggleView.accessibilityTraits.insert(.button)
        if #available(iOS 17.0, *) {
            self.toggleView.accessibilityTraits.insert(.toggleButton)
        }

        self.updateAccessibility()
    }

    private func updateAccessibility() {
        self.updateAccessibilityValue()
        self.updateAccessibilityEnabledTrait()
    }

    private func updateAccessibilityValue() {
        self.toggleView.accessibilityValue = self.isOn ? "1" : "0"
    }

    private func updateAccessibilityEnabledTrait() {
        if self.isEnabled {
            self.toggleView.accessibilityTraits.remove(.notEnabled)
        } else {
            self.toggleView.accessibilityTraits.insert(.notEnabled)
        }
    }

    // MARK: - Subscribe

    private func setupSubscriptions() {
        // **
        // Static colors
        self.viewModel.$staticColors.subscribe(in: &self.subscriptions) { [weak self] staticColors in
            guard let self else { return }

            self.toggleDotView.backgroundColor = staticColors.dotBackgroundColor.uiColor
            self.textLabel.textColor = staticColors.textForegroundColor.uiColor
        }
        // **

        // **
        // Dynamic colors
        self.viewModel.$dynamicColors.subscribe(in: &self.subscriptions) { [weak self] dynamicColors in
            guard let self else { return }

            UIView.execute(animationType: self.viewModel.animationType) { [weak self] in
                guard let self else { return }
                self.toggleView.backgroundColor = dynamicColors.backgroundColors.uiColor
                self.toggleDotImageView.tintColor = dynamicColors.dotForegroundColors.uiColor
            }
        }
        // **

        // **
        // Content Radius
        self.viewModel.$contentRadius.subscribe(in: &self.subscriptions) { [weak self] contentRadius in
            guard let self else { return }

            self.updateCornerRadius(contentRadius)
        }
        // **

        // **
        // Dim
        self.viewModel.$dim.subscribe(in: &self.subscriptions) { [weak self] dim in
            guard let self else { return }

            self.toggleView.alpha = dim
        }
        // **

        // **
        // Title font
        self.viewModel.$titleFont.subscribe(in: &self.subscriptions) { [weak self] titleFont in
            guard let self else { return }

            self.textLabel.font = titleFont
            self.toggleHidenLabel.font = titleFont
        }
        // **

        // Is Icon
        self.viewModel.$isIcon.subscribe(in: &self.subscriptions) { [weak self] isIcon in
            guard let self else { return }

            if isIcon {
                let image = self.isOn ? self.onIcon : self.offIcon

                UIView.execute(
                    with: self.toggleDotImageView,
                    animationType: self.viewModel.animationType,
                    options: .transitionCrossDissolve,
                    instructions: { [weak self] in
                        self?.toggleDotImageView.image = image
                    },
                    completion: nil
                )

            } else {
                self.toggleDotImageView.image = nil
            }
        }

        // **
        // Spacing
        self.viewModel.$spacing.subscribe(in: &self.subscriptions) { [weak self] spacing in
            guard let self else { return }

            self.contentStackView.spacing = spacing
            self.invalidateIntrinsicContentSize()
        }
        // **

        // **
        // Show space
        self.viewModel.$showSpace.subscribe(in: &self.subscriptions) { [weak self] showSpace in
            guard let self else { return }

            // showLeftSpace MUST be different to continue
            // Or if the both space have the same isHidden (default state)
            guard self.toggleLeftSpaceView.isHidden == showSpace.showLeft ||
            self.toggleRightSpaceView.isHidden == self.toggleLeftSpaceView.isHidden else {
                return
            }

            // Lock interaction before animation
            self.toggleView.isUserInteractionEnabled = false

            UIView.execute(animationType: self.viewModel.animationType) { [weak self] in
                guard let self else { return }

                self.toggleLeftSpaceView.isHidden = !showSpace.showLeft
                self.toggleRightSpaceView.isHidden = !showSpace.showRight
            } completion: { [weak self] _ in
                // Reset interaction after animation
                self?.updateToggleViewUserInteractionEnabled()
            }
        }
        // **
    }

    // MARK: - Trait Collection

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.accessibilityContrast != self.traitCollection.accessibilityContrast {
            self.viewModel.contrast = self.traitCollection.accessibilityContrast
        }
    }
}
