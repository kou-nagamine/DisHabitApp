//
//  SwiftUIView.swift
//  DisHabitApp
//
//  Created by 長峯 幸佑 on 2025/05/25.
//

import SwiftUI

struct TicketTearOffArea: Shape {
    let notchRadius: CGFloat
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX + notchRadius, y: rect.minY))

        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        
        path.addArc(
            center: CGPoint(x: rect.maxX, y: rect.minY),
            radius: cornerRadius,
            startAngle: .degrees(-0),
            endAngle: .degrees(90),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: rect.minX + notchRadius, y: rect.maxY))

        path.addArc(
            center: CGPoint(x: rect.minX, y: rect.maxY),
            radius: notchRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(-90),
            clockwise: true
        )

        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + notchRadius * 2))

        path.addArc(
            center: CGPoint(x: rect.minX, y: rect.minY),
            radius: notchRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(0),
            clockwise: true
        )

        path.closeSubpath()
        return path
    }
}

struct TicketTitleArea: Shape {
    let notchRadius: CGFloat
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))

        path.addLine(to: CGPoint(x: rect.maxX - notchRadius, y: rect.minY))
        
        path.addArc(
            center: CGPoint(x: rect.maxX, y: rect.minY),
            radius: notchRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(90),
            clockwise: true
        )

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - notchRadius))
        path.addArc(
            center: CGPoint(x: rect.maxX, y: rect.maxY),
            radius: notchRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(180),
            clockwise: true
        )

        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius ,
            startAngle: .degrees(180),
            endAngle: .degrees(-90),
            clockwise: false
        )

        path.closeSubpath()
        return path
    }
}
