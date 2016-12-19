//
//  CGFloat+DeviceSize.swift
//  Swiftilities
//
//  Created by Rob Cadwallader on 11/4/16.
//
//

import Foundation

public extension CGFloat {

    /**
     Calculates the ratio of a CGFloat to an axis of a reference DeviceSize and then returns that ratio
     multiplied by the same axis of the current DeviceSize. For example:

     let value: CGFloat = 100.0
     let result = value.proportional(toDeviceSize: .small, axis: .y)
     print(result) // Prints 138.958333333333 when DeviceSize.current == .large

     - parameter size: Reference DeviceSize value
     - parameter axis: Axis to compare
     */
    public func proportional(toDeviceSize size: DeviceSize, axis: Axis) -> CGFloat {
        let defaultDimension = (axis == .x) ? size.dimensions.width : size.dimensions.height
        guard defaultDimension != 0, size != DeviceSize.current else {
            return self
        }

        let ratio: CGFloat = self / defaultDimension
        let currentDimension: CGFloat = (axis == .x) ? DeviceSize.current.dimensions.width : DeviceSize.current.dimensions.height

        return ratio * currentDimension
    }

}
