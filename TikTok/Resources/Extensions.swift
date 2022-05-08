//
//  Extensions.swift
//  TikTok
//
//  Created by Ivan Potapenko on 21.04.2022.
//

import Foundation
import UIKit

extension UIView {
    public var width: CGFloat {
        return frame.size.width
    }

    public var height: CGFloat {
        return frame.size.height
    }

    public var top: CGFloat {
        return frame.origin.y
    }

    public var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }

    public var left: CGFloat {
        return frame.origin.x
    }

    public var right: CGFloat {
        return frame.size.width + frame.origin.x
    }
}

extension DateFormatter {
    static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "d MMMM HH:mm"
        return formatter
    }()
}

extension String {
    static func date(with date: Date) -> String {
        return DateFormatter.defaultFormatter.string(from: date)
    }
}

extension UIView {
    func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.3
        rotation.isCumulative = true
        rotation.repeatCount = 0
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
