//
//  CanvasView.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 12/12/20.
//

import Foundation
import UIKit

protocol CanvasViewDelegate: AnyObject {
    func canvasDidAddStroke(_ canvasView: CanvasView)
}

class CanvasView: UIView {
    var annotationImage: UIImage?
    var strokeColor: UIColor
    var paths: [StrokePath] = []
    
    weak var delegate: CanvasViewDelegate?
    
    init(annotationImage: UIImage?, strokeColor: UIColor) {
        self.annotationImage = annotationImage
        self.strokeColor = strokeColor
        
        super.init(frame: CGRect.zero)
        
        self.isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if let annotationImage = annotationImage {
            annotationImage.draw(in: rect)
        }
        
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
        paths.append(StrokePath(strokeColor: strokeColor, points: []))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        guard var lastPath = paths.popLast() else { return }
        lastPath.points.append(point)
        paths.append(lastPath)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.canvasDidAddStroke(self)
    }
    
    func undo() {
        let _ = paths.popLast()
        setNeedsDisplay()
    }
    
    func clearAnnotation() {
        annotationImage = nil
        paths = []
        setNeedsDisplay()
    }
    
    func isAnnotationEmpty() -> Bool {
        return paths.count == 0 && annotationImage == nil
    }
}

