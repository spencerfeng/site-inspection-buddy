//
//  CanvasView.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 12/12/20.
//

import Foundation
import UIKit

class CanvasView: UIControl {
    var drawingImage: UIImage
    var drawColor: UIColor = .blue
    
    init(color: UIColor, drawingImage: UIImage) {
        self.drawingImage = drawingImage
        self.drawColor = color
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawingImage.draw(in: rect)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .valueChanged)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        drawingImage = UIGraphicsImageRenderer(size: bounds.size).image { context in
            UIColor.white.setFill()
            context.fill(bounds)
            drawingImage.draw(in: bounds)
            drawStroke(context: context.cgContext, touch: touch)
            setNeedsDisplay()
        }
    }
    
    private func drawStroke(context: CGContext, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        
        let lineWidth: CGFloat = 5
        context.setLineWidth(lineWidth)
        drawColor.setStroke()
        context.setLineCap(.round)
        
        context.move(to: previousLocation)
        context.addLine(to: location)
        context.strokePath()
      }
}

