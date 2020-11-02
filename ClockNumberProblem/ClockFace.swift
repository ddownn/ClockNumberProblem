//
//  ClockFace2.swift
//  New Clock
//
//  Created by Paul Bryan on 11/1/20.
//

import UIKit

// Vector Addition: CGPoint + CGPoint
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
// Vector Addition: CGPoint += CGPoint
public func += (left: inout CGPoint, right: CGPoint) {
    left = CGPoint(x: left.x + right.x, y: left.y + right.y)
}
// Vector Subtraction: CGPoint - CGPoint
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
// Vector Subtraction: CGPoint -= CGPoint
public func -= (left: inout CGPoint, right: CGPoint) {
    left = CGPoint(x: left.x - right.x, y: left.y - right.y)
}
// Vector Multiplication: CGPoint * CGFloat
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
// Vector Multiplication: CGPoint *= CGFloat
public func *= (point: inout CGPoint, scalar: CGFloat) {
    point = CGPoint(x: point.x * scalar, y: point.y * scalar)
}

@IBDesignable class ClockFace: UIView {
    
    private let numeralFont = UIFont(name: "Baskerville-SemiBold", size: 1)
    
    override var backgroundColor: UIColor? { didSet {} }
    
    // MARK: - UIView properties
    private var width: CGFloat {
        return self.bounds.width
    }
    private var height: CGFloat {
        return self.bounds.height
    }
    private var midX: CGFloat {
        return self.bounds.midX
    }
    private var midY: CGFloat {
        return self.bounds.midY
    }
    internal var viewCenter: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    // MARK: - Drawing variables
    private let twoPi = CGFloat.pi * 2
    private let halfPi = CGFloat.pi / 2
    private var angleOffset: CGFloat
    private var startAngle: CGFloat
    private var endAngle: CGFloat
    public var clockDiameter: CGFloat {
        return min(width, height)
    }
    private var clockRadius: CGFloat {
        return clockDiameter / 2
    }
    private var bezelWidth: CGFloat {
        round(clockDiameter / 33.0) * 2
    }
    private var numeralFontSize: CGFloat {
        return round(clockDiameter / 11.0)
    }
    private var numeralSize: CGSize {
        return CGSize(width: numeralFontSize, height: numeralFontSize)
    }
    private var numeralCenter: CGPoint {
        CGPoint(x: numeralSize.width / 2, y: numeralSize.height / 2)
    }
    private var numberMargin: CGFloat {
        round(clockDiameter / 5.0)
    }
    private var numberRadius: CGFloat {
        return clockRadius - numberMargin / 2 - bezelWidth / 2
    }
    private var numberOfMajorTicks: Int
    
    private let numeralLayers: [CATextLayer]
    
    // MARK: - Init
    override init(frame: CGRect) {
        angleOffset = -halfPi
        startAngle = angleOffset
        endAngle = startAngle + twoPi
        numberOfMajorTicks = 12
        numeralLayers = (0..<numberOfMajorTicks).map {_ in CATextLayer()}
        for lay in numeralLayers {
            lay.contentsScale = UIScreen.main.scale
            lay.font = numeralFont
            lay.alignmentMode = .center
            lay.foregroundColor = UIColor.black.cgColor
        }
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        angleOffset = -halfPi
        startAngle = angleOffset
        endAngle = startAngle + twoPi
        numberOfMajorTicks = 12
        numeralLayers = (0..<numberOfMajorTicks).map {_ in CATextLayer()}
        for lay in numeralLayers {
            lay.contentsScale = UIScreen.main.scale
            lay.font = numeralFont
            lay.alignmentMode = .center
            lay.foregroundColor = UIColor.black.cgColor
        }
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.layer.sublayers == nil {
            for lay in numeralLayers {
                self.layer.addSublayer(lay)
            }
        }
    }
    
    private func pointFromCAR(_ centerPoint: CGPoint, _ angle: CGFloat, _ radius: CGFloat) -> CGPoint {
        var point = CGPoint(x: cos(angle), y: sin(angle))
        point *= radius
        point += centerPoint
        return point
    }
    
    override func draw(_ rect: CGRect) {
        
        // MARK: - make numerals
        let numeralMax = 12
        var numeral = numeralMax
        
        for (index, angle) in stride(from: startAngle, to: startAngle + twoPi, by: twoPi / CGFloat(numberOfMajorTicks)).enumerated() {
            
            let pt = pointFromCAR(viewCenter, angle, numberRadius) - numeralCenter
            
            numeral = (numeral + (numeralMax - 1)) % numeralMax + 1
            
            let numeralText = String(numeral)
            numeralLayers[index].string = numeralText
            numeral += 1
            
            numeralLayers[index].frame = CGRect(origin: pt, size: numeralSize)
            numeralLayers[index].fontSize = numeralFontSize
        }
    }
}
