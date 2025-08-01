//
//  SwitchUIImages.swift
//  SparkComponentSwitch
//
//  Created by robin.lemaire on 03/07/2023.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

import UIKit

public struct SwitchUIImages: Equatable {

    // MARK: - Properties

    public let on: UIImage
    public let off: UIImage

    // MARK: - Initialization

    public init(on: UIImage, off: UIImage) {
        self.on = on
        self.off = off
    }
}
