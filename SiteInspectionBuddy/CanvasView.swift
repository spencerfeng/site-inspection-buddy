//
//  CanvasView.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 12/12/20.
//

import Foundation
import UIKit

class CanvasView: UIView {
    var strokeColor: UIColor
    var image: UIImage
    var paths: [Path]
    
    init(image: UIImage, strokeColor: UIColor, paths: [Path]) {
        self.strokeColor = strokeColor
        self.image = image
        self.paths = paths
        
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
        
        context.setLineCap(.round)
        
        paths.forEach { path in
            context.setStrokeColor(path.strokeColor.cgColor)
            context.setLineWidth(5)
            
            for (i, p) in path.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        paths.append(Path(strokeColor: strokeColor, points: []))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        guard let lastPath = paths.popLast() else { return }
        lastPath.points.append(point)
        paths.append(lastPath)
        
        setNeedsDisplay()
    }
}

