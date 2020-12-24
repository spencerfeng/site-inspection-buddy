//
//  DrawingPadControllerRepresentation.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 16/12/20.
//

import SwiftUI
import UIKit

struct DrawingPadControllerRepresentation: UIViewControllerRepresentable {
    @Binding var image: UIImage
    var drawColor: UIColor
    let issue: Issue
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    func makeUIViewController(context: Context) -> DrawingPadController {
        let drawingPad = DrawingPadController(image: image, drawColor: drawColor)
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

            guard let imageWithMarkup = viewScreenshot else { return }
            let thisPhoto = parent.issue.photosArray[0]
            thisPhoto.photoData = imageWithMarkup.jpegData(compressionQuality: 0.5)
            parent.saveContext()
            parent.image = imageWithMarkup
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
