//
//  CubicBezier.swift
//  Swiftilities
//
//  Created by Jason Clark on 8/10/17.
//
/*
 Derived from IBM's implementation of the CSS function cubic-bezier

 Licensed Materials - Property of IBM
 © Copyright IBM Corporation 2015. All Rights Reserved.
 This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
 */

import UIKit

// swiftlint:disable identifier_name
extension CubicBezier {

    static func value(for input: CGFloat, controlPoint1: CGPoint, controlPoint2: CGPoint) -> CGFloat {
        return CubicBezier(p1: controlPoint1, p2: controlPoint2).valueForX(x: input)
    }

}

struct CubicBezier {

    let cx: CGFloat, bx: CGFloat, ax: CGFloat, cy: CGFloat, by: CGFloat, ay: CGFloat

    init(p1: CGPoint, p2: CGPoint) {
        self.init(x1: p1.x, y1: p1.y, x2: p2.x, y2: p2.y)
    }

    init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {

        var p1 = CGPoint.zero
        var p2 = CGPoint.zero

        // Clamp to interval [0..1]
        p1.x = max(0.0, min(1.0, x1))
        p1.y = max(0.0, min(1.0, y1))

        p2.x = max(0.0, min(1.0, x2))
        p2.y = max(0.0, min(1.0, y2))

        // Implicit first and last control points are (0,0) and (1,1).
        cx = 3.0 * p1.x
        bx = 3.0 * (p2.x - p1.x) - cx
        ax = 1.0 - cx - bx

        cy = 3.0 * p1.y
        by = 3.0 * (p2.y - p1.y) - cy
        ay = 1.0 - cy - by
    }

    func valueForX(x: CGFloat) -> CGFloat {
        let epsilon: CGFloat = 1.0 / 200.0
        let xSolved = solveCurveX(x, epsilon: epsilon)
        let y = sampleCurveY(xSolved)
        return (y / epsilon).rounded(.toNearestOrAwayFromZero) * epsilon
    }

    private func solveCurveX(_ x: CGFloat, epsilon: CGFloat) -> CGFloat {

        var t0: CGFloat, t1: CGFloat, t2: CGFloat, x2: CGFloat, d2: CGFloat

        // First try a few iterations of Newton's method -- normally very fast.
        t2 = x
        for _ in 0...8 {
            x2 = sampleCurveX(t2) - x
            if fabs(x2) < epsilon {
                return t2
            }
            d2 = sampleCurveDerivativeX(t2)
            if fabs(d2) < 1e-6 {
                break
            }
            t2 -= x2 / d2
        }

        // Fall back to the bisection method for reliability.
        t0 = 0.0
        t1 = 1.0
        t2 = x

        if t2 < t0 {
            return t0
        }
        if t2 > t1 {
            return t1
        }

        while t0 < t1 {
            x2 = sampleCurveX(t2)
            if fabs(x2 - x) < epsilon {
                return t2
            }
            if x > x2 {
                t0 = t2
            }
            else {
                t1 = t2
            }
            t2 = (t1 - t0) * 0.5 + t0
        }

        // Failure.
        return t2
    }

    private func sampleCurveX(_ t: CGFloat) -> CGFloat {
        // 'ax t^3 + bx t^2 + cx t' expanded using Horner's rule.
        return ((ax * t + bx) * t + cx) * t
    }

    private func sampleCurveY(_ t: CGFloat) -> CGFloat {
        return ((ay * t + by) * t + cy) * t
    }

    private func sampleCurveDerivativeX(_ t: CGFloat) -> CGFloat {
        return (3.0 * ax * t + 2.0 * bx) * t + cx
    }

}

