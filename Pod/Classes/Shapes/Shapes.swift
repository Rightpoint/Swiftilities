//
//  Shapes.swift
//  Swiftilities
//
//  Created by Nick Bonatsakis on 5/1/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

public class Shapes {

    public enum Shape {

        case rectangle(cornerRadius: CGFloat)
        case circle
        case pill

    }

    public enum Attribute {

        case fillColor(UIColor)
        case strokeColor(UIColor)
        case lineWidth(CGFloat)

    }

    fileprivate static let shared = Shapes()

    fileprivate let imageCache: NSCache<AnyObject, UIImage> = {
        let cache = NSCache<AnyObject, UIImage>()
        cache.name = "com.raizlabs.Swiftilities.Shapes.ImageCache"
        return cache
    }()

    public static func image(for shape: Shape, size: CGSize, attributes: [Attribute]) -> UIImage {
        return Shapes.shared.image(for: shape, size: size, attributes: attributes)
    }

    public static func image(for shape: Shape, size: CGSize, attributes: Attribute...) -> UIImage {
        return Shapes.shared.image(for: shape, size: size, attributes: attributes)
    }

    public static func layer(for shape: Shape, size: CGSize, attributes: Attribute...) -> CAShapeLayer {
        return Shapes.shared.layer(for: shape, size: size, attributes: attributes)
    }

}

// MARK: Internal

private extension Shapes {

    func image(for shape: Shape, size: CGSize, attributes: [Attribute]) -> UIImage {
        let cacheKey = imageCacheKey(for: shape, size: size, attributes: attributes) as AnyObject
        if let existingImage = imageCache.object(forKey: cacheKey) {
            return existingImage
        }

        var image: UIImage?

        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: size)
            image = renderer.image { (context) in
                Shapes.draw(shape, size: size, attributes: attributes, context: context.cgContext)
            }
        }
        else {
            UIGraphicsBeginImageContext(size)
            if let context = UIGraphicsGetCurrentContext() {
                Shapes.draw(shape, size: size, attributes: attributes, context: context)
                image = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()
        }

        if let newImage = image {
            imageCache.setObject(newImage, forKey: cacheKey)
        }

        return image ?? UIImage()
    }

    func layer(for shape: Shape, size: CGSize, attributes: [Attribute]) -> CAShapeLayer {
        return shape.shapeLayer(for: size, attributes: attributes)
    }

    static func draw(_ shape: Shape, size: CGSize, attributes: [Attribute], context: CGContext) {
        let path = shape.path(for: size)

        context.addPath(path.cgPath)
        context.clip()

        context.setLineWidth(0.0)
        attributes.forEach({ $0.apply(to: context) })
        context.addPath(path.cgPath)
        context.drawPath(using: .fillStroke)
    }

}

// MARK: Rendering

private extension Shapes.Shape {

    func shapeLayer(for size: CGSize, attributes: [Shapes.Attribute]) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        maskLayer.path = path(for: size).cgPath
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.masksToBounds = true

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layer.path = path(for: size).cgPath
        layer.mask = maskLayer
        attributes.forEach({ $0.apply(to: layer) })
        return layer
    }

    func path(for size: CGSize) -> UIBezierPath {
        let frame = CGRect(origin: .zero, size: size)
        switch self {
        case .rectangle(let cornerRadius):
            return UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius)
        case .circle:
            let halfWidth = size.width / 2
            return UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfWidth), radius: halfWidth, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        case .pill:
            let radius: CGFloat = size.height / 2
            let path = UIBezierPath()
            let halfPi = CGFloat(Double.pi / 2.0)

            // Top edge
            path.move(to: CGPoint(x: radius, y: 0))
            path.addLine(to: CGPoint(x: size.width - radius, y: 0))

            // Right cap
            path.addArc(withCenter: CGPoint(x: size.width - radius, y: radius), radius: radius, startAngle: halfPi * 3, endAngle: halfPi, clockwise: true)

            // Bottom edge
            path.addLine(to: CGPoint(x: radius, y: size.height))

            // Left cap
            path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: halfPi, endAngle: halfPi * 3, clockwise: true)

            return path
        }
    }

}

private extension Shapes.Attribute {

    func apply(to layer: CAShapeLayer) {
        switch self {
        case .fillColor(let fill):
            layer.fillColor = fill.cgColor
        case .strokeColor(let stroke):
            layer.strokeColor = stroke.cgColor
        case .lineWidth(let width):
            layer.lineWidth = width * 2 // Double line width to account for shape clipping

        }
    }

    func apply(to context: CGContext) {
        switch self {
        case .fillColor(let fill):
            context.setFillColor(fill.cgColor)
        case .strokeColor(let stroke):
            context.setStrokeColor(stroke.cgColor)
        case .lineWidth(let width):
            context.setLineWidth(width * 2) // Double line width to account for shape clipping

        }
    }

}

// MARK: Image Cache

extension Shapes.Shape: CustomStringConvertible {

    public var description: String {
        switch self {
        case .rectangle(let cornerRadius):
            return "rectangle(radius=\(cornerRadius))"
        case .circle:
            return "circle"
        case .pill:
            return "pill"
        }
    }

}

extension Shapes.Attribute: CustomStringConvertible {

    public var description: String {
        switch self {
        case .fillColor(let fill):
            return "fillColor=\(String(describing: fill))"
        case .strokeColor(let stroke):
            return "strokeColor=\(String(describing: stroke))"
        case .lineWidth(let width):
            return "lineWidth=\(width)"
        }
    }
}

private extension Shapes {

    func imageCacheKey(for shape: Shape, size: CGSize, attributes: [Attribute]) -> String {
        let keyDelimiter = "|"

        var key: String =
                String(describing: shape) +
                keyDelimiter +
                "size=\(String(describing: size))"

        attributes.map({ String(describing: $0) })
        .sorted()
        .forEach { (attr) in
            key += (keyDelimiter + attr)
        }

        return key
    }

}
