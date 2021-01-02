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
    
    let pdfWidth = CGFloat(8.5 * 72.0)
    let pdfHeight = CGFloat(11 * 72.0)
    
    lazy var pdfContentWidth: CGFloat = {
        return pdfWidth - 2 * Constants.PDF_HORIZONTAL_PADDING
    }()
    
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
        
        let pageRect = CGRect(x: 0, y: 0, width: pdfWidth, height: pdfHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            let drawContext = context.cgContext
            
            // draw cover page
            context.beginPage()
            var currentY = drawReportTitle()
            currentY = drawHorizontalLine(drawContext, startAt: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: currentY + Constants.DEFAULT_MARGIN), endAt: CGPoint(x: pdfWidth - Constants.PDF_HORIZONTAL_PADDING, y: currentY + Constants.DEFAULT_MARGIN), thickness: 5, color: UIColor(.blue).cgColor)
            
            // draw issues
            context.beginPage()
            let attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
            ]
            let text = "Second Page"
            text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        }
        
        return data
    }
    
    func drawReportTitle() -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: Constants.PDF_REPORT_TITLE_FONT_SIZE, weight: .bold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        let titleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: titleFont
        ]
        let attributedTitle = NSAttributedString(
            string: project.title ?? "",
            attributes: titleAttributes
        )
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(
            x: Constants.PDF_HORIZONTAL_PADDING,
            y: pdfHeight / 2.0,
            width: pdfContentWidth,
            height: getTextRectHeight(textWidth: titleStringSize.width, textHeight: titleStringSize.height, rectWidth: pdfContentWidth)
        )
        
        attributedTitle.draw(in: titleStringRect)
        
        
        
        return titleStringRect.origin.y + titleStringRect.height
    }
    
    func getTextRectHeight(textWidth: CGFloat, textHeight: CGFloat, rectWidth: CGFloat) -> CGFloat {
        return ceil(textWidth / rectWidth) * textHeight
    }
    
    func drawHorizontalLine(_ drawCtx: CGContext, startAt: CGPoint, endAt: CGPoint, thickness: CGFloat, color: CGColor) -> CGFloat {
        drawCtx.saveGState()
        drawCtx.setLineWidth(thickness)
        drawCtx.setStrokeColor(color)
        drawCtx.move(to: startAt)
        drawCtx.addLine(to: endAt)
        drawCtx.strokePath()
        drawCtx.restoreGState()
        
        return startAt.y + thickness
    }
}
