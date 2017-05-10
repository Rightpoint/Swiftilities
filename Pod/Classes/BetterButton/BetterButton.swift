//
//  BetterButton.swift
//  Swiftilities
//
//  Created by Nick Bonatsakis on 5/1/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

public class BetterButton: UIButton {

    public enum Shape {

        case rectangle
        case circle
        case pill

    }

    enum Style {

        case solid
        case outlineOnly
        case outlineInvert

    }

    init(shape: Shape, style: Style, color: UIColor) {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
    }

}
