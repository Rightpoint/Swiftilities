//
//  CGFloat+DeviceSize.swift
//  Swiftilities
//
//  Created by Rob Cadwallader on 11/4/16.
//
//

import Foundation

public extension CGFloat {

    public func proportional(toDeviceSize size: DeviceSize, axis: Axis) -> CGFloat {
        let defaultDimension = (axis == .x) ? size.dimensions.width : size.dimensions.height
        guard defaultDimension != 0, size != DeviceSize.current else {
            return self
        }

        let ratio: CGFloat = self/defaultDimension
        let currentDimension: CGFloat = (axis == .x) ? DeviceSize.current.dimensions.width : DeviceSize.current.dimensions.height

        return ratio * currentDimension
    }

}
