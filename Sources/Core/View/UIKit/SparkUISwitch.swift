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

// TODO: Add Action
// TODO: Add Target
// TODO: Haptic
// TODO: High Contrast
// TODO: OnOffLabels
// TODO: Add Pressed state (rounded rect)

// TODO: Comment
// TODO: Example
// TODO: Snapshots
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
        view.backgroundColor = .clear
        return view
    }()

    private lazy var toggleHidenLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = self.textLabel.adjustsFontForContentSizeCategory
        label.isHidden = true
        return label
    }()

    private lazy var toggleView: UIView = {
        let view = UIView()
        view.accessibilityTraits = [.button]
        if #available(iOS 17.0, *) {
            view.accessibilityTraits.insert(.toggleButton)
        }
        view.isAccessibilityElement = true
        view.accessibilityIdentifier = AccessibilityIdentifier.toggleView
        view.addSubview(self.toggleContentStackView)
        view.isUserInteractionEnabled = true
        view.setContentCompressionResistancePriority(.required,
                                                     for: .vertical)
        view.setContentCompressionResistancePriority(.required,
                                                     for: .horizontal)
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
        return stackView
    }()

    private var toggleLeftSpaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

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

    private var toggleRightSpaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    /// The UILabel used to display the switch text
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
    public var isOn: Bool {
        get {
            return self.viewModel.isOn
        }
        set {
            self.viewModel.setIsOn(newValue)
        }
    }

    /// The text of the switch.
    public var text: String? {
        get {
            return self.textLabel.text
        }
        set {
            self.textLabel.text = newValue
            self.toggleHidenLabel.text = newValue
            self.invalidateIntrinsicContentSize()
        }
    }

    /// The attributed text of the switch.
    public var attributedText: NSAttributedString? {
        get {
            return self.textLabel.attributedText
        }
        set {
            self.textLabel.attributedText = newValue
            self.toggleHidenLabel.attributedText = newValue
            self.invalidateIntrinsicContentSize()
        }
    }

    /// The state of the switch: enabled or not (retrieve and set without animation). .
    public override var isEnabled: Bool {
        get {
            return self.viewModel.isEnabled
        }
        set {
            self.viewModel.isEnabled = newValue
            self.updateToggleViewState()
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

    private var toggleDotLeadingConstraint: NSLayoutConstraint?
    private var toggleDotTopConstraint: NSLayoutConstraint?
    private var toggleDotTrailingConstraint: NSLayoutConstraint?
    private var toggleDotBottomConstraint: NSLayoutConstraint?

    private var toggleHeight: CGFloat = Constants.ToggleSizes.height
    private var toggleWidth: CGFloat = Constants.ToggleSizes.width
    private var toggleSpacing: CGFloat = Constants.ToggleSizes.padding
    private var toggleDotSpacing: CGFloat = Constants.toggleDotImagePadding

    private let onIcon: UIImage
    private let offIcon: UIImage

    private var isReduceMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    // TODO: Comment
    // TODO: Example
    // TODO: Snapshots
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
        print("LOGROB Deinit Switch")

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

        // Updates
        self.setupAccessibilityValue(isOn: self.isOn)
        self.updateToggleContentViewSpacings()
        self.updateToggleViewSize()
        self.updateToggleDotImageViewSpacings()

        // Load view model
        self.viewModel.load()
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

    // MARK: - Accessibility

    private func setupAccessibilityValue(isOn: Bool) {
//        self.toggleView.accessibilityValue = isOn ? "1" : "0"
    }

    // MARK: - Gesture

    private func setupGesturesRecognizer() {
        self.setupToggleTapGestureRecognizer()
        self.setupToggleSwipeGestureRecognizer()
    }

    private func setupToggleTapGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleTapGestureAction))
        self.toggleView.addGestureRecognizer(gestureRecognizer)
    }

    private func setupToggleSwipeGestureRecognizer() {
        let rightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.toggleSwipeGestureAction))
        rightGestureRecognizer.direction = .right
        self.toggleView.addGestureRecognizer(rightGestureRecognizer)

        let leftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.toggleSwipeGestureAction))
        leftGestureRecognizer.direction = .left
        self.toggleView.addGestureRecognizer(leftGestureRecognizer)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        // Global
        self.setupViewConstraints()
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

    private func setupViewConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
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
        self.toggleDotView.widthAnchor.constraint(equalTo: self.toggleDotView.heightAnchor).isActive = true
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
    }

    // MARK: - Actions

    @objc private func toggleTapGestureAction(_ sender: UITapGestureRecognizer) {
        self.toggle()
    }

    @objc private func toggleSwipeGestureAction(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left where self.isOn, .right where !self.isOn:
            self.toggle()
        default:
            break
        }
    }

    private func toggle() {
        self.viewModel.toggle()

        // Action
        self.sendActions(for: .valueChanged)
        self.isOnChangedSubject.send(isOn)

        // Haptic
        let generator = UIImpactFeedbackGenerator(style: .medium)
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

    private func updateToggleViewState() {
        self.toggleView.isUserInteractionEnabled = self.isEnabled
        if !isEnabled {
            self.toggleView.accessibilityTraits.insert(.notEnabled)
        } else {
            self.toggleView.accessibilityTraits.remove(.notEnabled)
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

    // MARK: - Subscribe

    private func setupSubscriptions() {
        // **
        // Static colors
        self.viewModel.$staticColors.subscribe(in: &self.subscriptions) { [weak self] staticColors in
            guard let self else { return }

            // staticColors.hoverColor // TODO:
            self.toggleDotView.backgroundColor = staticColors.dotBackgroundColor.uiColor
            self.textLabel.textColor = staticColors.textForegroundColor.uiColor
        }
        // **

        // **
        // Dynamic colors
        self.viewModel.$dynamicColors.subscribe(in: &self.subscriptions) { [weak self] dynamicColors in
            guard let self else { return }

            UIView.execute(animationType: self.viewModel.animationType()) { [weak self] in
                self?.toggleView.backgroundColor = dynamicColors.backgroundColors.uiColor
                self?.toggleDotImageView.tintColor = dynamicColors.dotForegroundColors.uiColor
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
                    animationType: self.viewModel.animationType(),
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
            let currentUserInteraction = self.toggleView.isUserInteractionEnabled
            self.toggleView.isUserInteractionEnabled = false

            UIView.execute(animationType: self.viewModel.animationType()) { [weak self] in
                self?.toggleLeftSpaceView.isHidden = !showSpace.showLeft
                self?.toggleRightSpaceView.isHidden = !showSpace.showRight
            } completion: { [weak self] _ in
                // Unlock interaction after animation
                self?.toggleView.isUserInteractionEnabled = currentUserInteraction
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
