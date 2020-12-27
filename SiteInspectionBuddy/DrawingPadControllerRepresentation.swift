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
    var strokeColor: UIColor
    let photo: Photo
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    func makeUIViewController(context: Context) -> DrawingPadController {
        var anonotationPaths: [StrokePath] = []
        if let annotation = photo.annotation {
            anonotationPaths = annotation.paths
        }
        
        let drawingPad = DrawingPadController(image: image, strokeColor: strokeColor, paths: anonotationPaths)
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
        
        func drawingPadControllerWillSaveDrawing(_ drawingPad: DrawingPadController, paths: [StrokePath]) {
            parent.photo.annotation = StrokePaths(paths: paths)
            parent.saveContext()
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
