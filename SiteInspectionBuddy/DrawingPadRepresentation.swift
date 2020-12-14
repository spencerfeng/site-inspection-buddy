//
//  DrawingPadRepresentation.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 13/12/20.
//

import Foundation
import SwiftUI

struct DrawingPadRepresentation: UIViewRepresentable {
    @Binding var drawingImage: UIImage
    let pickedColor: PickedColor
    
    class Coordinator: NSObject {
        @Binding var drawingImage: UIImage
        
        init(drawingImage: Binding<UIImage>) {
            _drawingImage = drawingImage
        }
        
        @objc func drawingImageChanged(_ sender: CanvasView) {
            self.drawingImage = sender.drawingImage
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(drawingImage: $drawingImage)
    }
    
    func makeUIView(context: Context) -> CanvasView {
        let view = CanvasView(color: pickedColor.uiColor, drawingImage: drawingImage)
        
        view.addTarget(context.coordinator, action: #selector(Coordinator.drawingImageChanged(_:)), for: .valueChanged)
        return view
    }
    
    func updateUIView(_ uiView: CanvasView, context: Context) {
        uiView.drawColor = pickedColor.uiColor
    }
}
