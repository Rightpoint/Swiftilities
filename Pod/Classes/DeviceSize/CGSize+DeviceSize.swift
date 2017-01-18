//
//  CGSize+DeviceSize.swift
//  Swiftilities
//
//  Created by Rob Cadwallader on 11/4/16.
//
//

import Foundation

public extension CGSize {

    /**
     Calculates the ratio of a CGSize to a reference DeviceSize and then returns that ratio
     multiplied by the current DeviceSize. For example:

     let value: CGSize = CGSize(width: 100, height: 100)
     let result = value.proportional(toDeviceSize: .small)
     print(result) // Prints (117.1875, 138.958333333333) when DeviceSize.current == .large

     - parameter size: Reference DeviceSize value
     */
    func proportional(toDeviceSize size: DeviceSize) -> CGSize {
        let xDimension = size.dimensions.width
        let yDimension = size.dimensions.height
        guard xDimension != 0 && yDimension != 0 else {
            return self
        }

        let xRatio: CGFloat = self.width / xDimension
        let yRatio: CGFloat = self.height / yDimension

        return CGSize(width: (DeviceSize.current.dimensions.width * xRatio), height: (DeviceSize.current.dimensions.height * yRatio))
    }

}
