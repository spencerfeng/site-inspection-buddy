//
//  DrawingPadControllerRepresentation.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 16/12/20.
//

import SwiftUI
import UIKit

struct DrawingPadControllerRepresentation: UIViewControllerRepresentable {
    var backgroundImage: UIImage
    @Binding var annotationImage: UIImage
    var strokeColor: UIColor
    let photo: Photo
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    func makeUIViewController(context: Context) -> DrawingPadController {
        let drawingPad = DrawingPadController(backgroundImage: backgroundImage, annotationImage: annotationImage, strokeColor: strokeColor)
        drawingPad.delegate = context.coordinator
        
        return drawingPad
    }
    
    func updateUIViewController(_ uiViewController: DrawingPadController, context: Context) {
        // TODO
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            // TODO: proper error handling
            print("Error saving managed object context: \(error)")
        }
    }
    
    final class Coordinator: DrawingPadControllerDelegate {
        var parent: DrawingPadControllerRepresentation
        
        init(_ parent: DrawingPadControllerRepresentation) {
            self.parent = parent
        }
        
        func drawingPadControllerWillDismiss(_ drawingPad: DrawingPadController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func drawingPadControllerWillSaveDrawing(_ drawingPad: DrawingPadController, canvas: CanvasView) {
            UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, canvas.isOpaque, 0.0)
            canvas.drawHierarchy(in: canvas.bounds, afterScreenUpdates: false)
            let viewScreenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            guard let annotation = viewScreenshot else { return }
            parent.photo.annotationData = annotation.pngData()
            parent.photo.updatedAt = Date()
            parent.saveContext()
            parent.annotationImage = annotation
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
