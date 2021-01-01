//
//  ReportController.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 1/1/21.
//

import Foundation
import UIKit
import PDFKit

class ReportController: UIViewController {
    let project: Project
    let pdfView: PDFView
    
    init(project: Project) {
        self.project = project
        self.pdfView = PDFView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PDFView
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        // PDFThumbnailView
        let thumnailView = PDFThumbnailView()
        thumnailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thumnailView)
        
        // layout
        NSLayoutConstraint.activate([
            thumnailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.DEFAULT_MARGIN),
            thumnailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.DEFAULT_MARGIN),
            thumnailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.DEFAULT_MARGIN),
            thumnailView.heightAnchor.constraint(equalToConstant: 60),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.DEFAULT_MARGIN),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.DEFAULT_MARGIN),
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.DEFAULT_MARGIN),
            pdfView.bottomAnchor.constraint(equalTo: thumnailView.topAnchor)
        ])
        
        thumnailView.thumbnailSize = CGSize(width: 26, height: 26)
        thumnailView.layoutMode = .horizontal
        thumnailView.pdfView = pdfView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }
            let pdfData = self.generatePDF()
            DispatchQueue.main.async { [weak self] in
                self?.pdfView.document = PDFDocument(data: pdfData)
            }
        }
    }
    
    func generatePDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Incremental Digital",
            kCGPDFContextAuthor: "Spencer Feng"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            var attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
            ]
            var text = "First Page"
            text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
            
            context.beginPage()
            
            attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
            ]
            text = "Second Page"
            text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        }
        
        return data
    }
}
