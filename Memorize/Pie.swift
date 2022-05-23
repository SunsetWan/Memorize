//
//  Pie.swift
//  Memorize
//
//  Created by sunsetwan on 2022/5/23.
//

import SwiftUI

/// Custom Shape
struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise = false
    
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(x: center.x + radius * cos(startAngle.radians),
                            y: center.y + radius * sin(startAngle.radians))
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: !clockwise)
        
        p.addLine(to: center)
        
        return p
    }
}


