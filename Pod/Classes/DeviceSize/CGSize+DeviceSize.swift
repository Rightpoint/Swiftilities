//
//  CGSize+DeviceSize.swift
//  Swiftilities
//
//  Created by Rob Cadwallader on 11/4/16.
//
//

import Foundation

public extension CGSize {

    func proportional(toDeviceSize size: DeviceSize) -> CGSize {
        let xDimension = size.dimensions.width
        let yDimension = size.dimensions.height
        guard xDimension != 0 && yDimension != 0 else {
            return self
        }

        let xRatio: CGFloat = self.width/xDimension
        let yRatio: CGFloat = self.height/yDimension

        return CGSize(width: (DeviceSize.current.dimensions.width * xRatio), height: (DeviceSize.current.dimensions.height * yRatio))
    }

}
