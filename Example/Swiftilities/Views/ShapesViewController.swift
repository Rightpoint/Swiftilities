//
//  ShapesViewController.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 5/9/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Swiftilities
import UIKit

class ShapesViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let images = [
            Shapes.image(for: .rectangle(cornerRadius: 8),
                         size: CGSize(width: 300, height: 64),
                         attributes:
                .fillColor(.lightGray),
                         .lineWidth(2),
                         .strokeColor(.blue)
            ),
            Shapes.image(for: .pill,
                         size: CGSize(width: 300, height: 64),
                         attributes:
                .fillColor(.clear),
                         .lineWidth(1),
                         .strokeColor(.orange)
            ),
            Shapes.image(for: .circle,
                         size: CGSize(width: 100, height: 100),
                         attributes:
                .fillColor(.clear),
                         .lineWidth(5),
                         .strokeColor(.green)
            ),
            Shapes.image(for: .rectangle(cornerRadius: 8),
                         size: CGSize(width: 300, height: 64),
                         attributes:
                .fillColor(.lightGray),
                         .lineWidth(2),
                         .strokeColor(.blue)
            ),
        ]

        images.forEach { (image) in
            let rectImageView = UIImageView(image: image)
            stackView.addArrangedSubview(rectImageView)
        }

        let layerSize = CGSize(width: 300, height: 44)
        let shapeLayer = Shapes.layer(for: .rectangle(cornerRadius: 8),
                                 size: layerSize,
                                 attributes:
                                  .fillColor(.darkGray),
                                 .lineWidth(4),
                                 .strokeColor(.red)
        )
        let shapeView = UIView(frame: CGRect(origin: .zero, size: layerSize))
        shapeView.widthAnchor.constraint(equalToConstant: layerSize.width).isActive = true
        shapeView.heightAnchor.constraint(equalToConstant: layerSize.height).isActive = true
        shapeView.layer.addSublayer(shapeLayer)
        stackView.addArrangedSubview(shapeView)
    }

}
