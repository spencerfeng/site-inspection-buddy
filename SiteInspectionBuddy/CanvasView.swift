//
//  CanvasView.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 12/12/20.
//

import Foundation
import UIKit

class CanvasView: UIView {
    var drawColor: UIColor
    var image: UIImage
    
    var paths = [[CGPoint]]()
    
    init(image: UIImage, drawColor: UIColor) {
        self.drawColor = drawColor
        self.image = image
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        image.draw(in: rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setStrokeColor(drawColor.cgColor)
        context.setLineWidth(5)
        context.setLineCap(.butt)
        
        paths.forEach { path in
            for (i, p) in path.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
        }
        
        context.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        paths.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        guard var lastPath = paths.popLast() else { return }
        lastPath.append(point)
        paths.append(lastPath)
        
        setNeedsDisplay()
    }
}

