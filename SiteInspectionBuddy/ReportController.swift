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
    
    lazy var pdfContentHeight: CGFloat = {
        return pdfHeight - 2 * Constants.PDF_VERTICAL_PADDING
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
            var lastY = drawReportTitle()
            
            // draw issues
            context.beginPage()
            lastY = Constants.PDF_VERTICAL_PADDING
            
            for issue in project.issuesArray.reversed() {
                // prepare drawing issue title
                var issueTitleTextRect = prepareDrawingText(
                    text: issue.title ?? "",
                    fontSize: Constants.PDF_ISSUE_TITLE_FONT_SIZE,
                    weight: .bold,
                    at: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: lastY == Constants.PDF_VERTICAL_PADDING ? lastY : lastY + Constants.PDF_ISSUE_ITEM_SPACING),
                    withWidth: pdfContentWidth
                )
                
                var issueTitleSeparatorBottomY = prepareDrawingHorizontalLine(
                    startY: issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height + Constants.DEFAULT_MARGIN,
                    thickness: 5
                )
                
                if let issuePhoto = issue.firstPhoto {
                    // this isssue has a photo
                    var issuePhotoDrawingRect = prepareDrawingImage(
                        image: issuePhoto,
                        at: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: issueTitleSeparatorBottomY + Constants.DEFAULT_MARGIN),
                        withWidth: pdfContentWidth * 0.3
                    )
                    
                    // if the image can not fit in this page, we start a new page
                    if issuePhotoDrawingRect.origin.y + issuePhotoDrawingRect.height > pdfHeight - Constants.PDF_VERTICAL_PADDING {
                        context.beginPage()
                        
                        issueTitleTextRect = (
                            text: issueTitleTextRect.text,
                            rect: CGRect(
                                x: issueTitleTextRect.rect.origin.x,
                                y: Constants.PDF_VERTICAL_PADDING,
                                width: issueTitleTextRect.rect.width,
                                height: issueTitleTextRect.rect.height
                            )
                        )
                        
                        issueTitleSeparatorBottomY = prepareDrawingHorizontalLine(
                            startY: issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height + Constants.DEFAULT_MARGIN,
                            thickness: 5
                        )
                        
                        issuePhotoDrawingRect = prepareDrawingImage(
                            image: issuePhoto,
                            at: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: issueTitleSeparatorBottomY + Constants.DEFAULT_MARGIN),
                            withWidth: pdfContentWidth * 0.3
                        )
                    }
                    
                    // draw issue title
                    drawTextInRect(text: issueTitleTextRect.text, in: issueTitleTextRect.rect)
                    // draow issue title separator
                    let _ = drawHorizontalLine(
                        drawContext,
                        startAt: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height + Constants.DEFAULT_MARGIN),
                        endAt: CGPoint(x: pdfWidth - Constants.PDF_HORIZONTAL_PADDING, y: issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height + Constants.DEFAULT_MARGIN),
                        thickness: 5,
                        color: UIColor(.blue).cgColor
                    )
                    // draw image
                    let _ = drawImage(
                        bgImage: issuePhoto,
                        annotationImage: issue.annotationOfFirstPhoto,
                        in: issuePhotoDrawingRect
                    )
                    // draw issue comment
                    let infoOfAddedText = addComment(
                        issue.comment ?? "",
                        context: context,
                        in: CGRect(
                            x: Constants.PDF_HORIZONTAL_PADDING + pdfContentWidth * 0.35,
                            // TODO: write an article about this: why we need to negate it.
                            y: -(issueTitleSeparatorBottomY + Constants.DEFAULT_MARGIN),
                            width: pdfContentWidth * 0.65,
                            height: pdfContentHeight - (issueTitleSeparatorBottomY + Constants.DEFAULT_MARGIN)
                        ),
                        fromY: issueTitleSeparatorBottomY + Constants.DEFAULT_MARGIN
                    )
                    
                    if (infoOfAddedText.numberOfPages > 1) {
                        lastY = infoOfAddedText.textBottom
                    } else {
                        lastY = max(issuePhotoDrawingRect.origin.y + issuePhotoDrawingRect.height, infoOfAddedText.textBottom)
                    }
                } else {
                    // This issue does not have a photo
                    // draw issue title
                    drawTextInRect(text: issueTitleTextRect.text, in: issueTitleTextRect.rect)
                    // draow issue title separator
                    let _ = drawHorizontalLine(
                        drawContext,
                        startAt: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height + Constants.DEFAULT_MARGIN),
                        endAt: CGPoint(x: pdfWidth - Constants.PDF_HORIZONTAL_PADDING, y: issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height + Constants.DEFAULT_MARGIN),
                        thickness: 5,
                        color: UIColor(.blue).cgColor
                    )
                    lastY = issueTitleSeparatorBottomY
                }
            }
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
    
    func prepareDrawingText(text: String, fontSize: CGFloat, weight: UIFont.Weight, at: CGPoint, withWidth: CGFloat) -> (text: NSAttributedString, rect: CGRect) {
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        let attributedText = NSAttributedString(
            string: text,
            attributes: textAttributes
        )
        let textStringSize = attributedText.size()
        let textStringRect = CGRect(
            x: at.x,
            y: at.y,
            width: withWidth,
            height: getTextRectHeight(textWidth: textStringSize.width, textHeight: textStringSize.height, rectWidth: withWidth)
        )
        
        return (text: attributedText, rect: textStringRect)
    }
    
    func prepareDrawingImage(image: UIImage, at: CGPoint, withWidth: CGFloat) -> CGRect {
        let aspectRatio = image.size.height / image.size.width
        let drawingH = aspectRatio * withWidth
        
        return CGRect(x: at.x, y: at.y, width: withWidth, height: drawingH)
    }
    
    func prepareDrawingHorizontalLine(startY: CGFloat, thickness: CGFloat) -> CGFloat {
        return startY + thickness
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
    
    func drawImage(bgImage: UIImage, annotationImage: UIImage?, in rect: CGRect) -> CGFloat {
        bgImage.draw(in: rect)
        
        if let annotationImage = annotationImage {
            annotationImage.draw(in: rect)
        }
        
        return rect.origin.y + rect.height
    }
    
    func drawTextInRect(text: NSAttributedString, in rect: CGRect) {
        text.draw(in: rect)
    }
    
    func addComment(_ text: String, context: UIGraphicsPDFRendererContext, in initialRect: CGRect, fromY lastY: CGFloat) -> (textBottom: CGFloat, numberOfPages: Int) {
        let textFont = UIFont.systemFont(ofSize: Constants.PDF_ISSUE_BODY_FONT_SIZE, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        
        let currentText = CFAttributedStringCreate(nil, text as CFString, textAttributes as CFDictionary)
        let framesetter = CTFramesetterCreateWithAttributedString(currentText!)
        
        var currentRange = CFRangeMake(0, 0)
        var done = false
        var rect: CGRect
        var textFrameSuggestedSize: CGSize
        var numberOfPages = 0
        var lastY = lastY
        
        repeat {
            if currentRange.location == CFIndex(0) {
                rect = initialRect
            } else {
                context.beginPage()
                
                rect = CGRect(
                    x: initialRect.origin.x,
                    y: -Constants.PDF_VERTICAL_PADDING,
                    width: initialRect.width,
                    height: pdfContentHeight
                )
            }
            
            textFrameSuggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
                framesetter,
                currentRange,
                nil,
                CGSize(width: initialRect.width, height: pdfContentHeight),
                nil
            )
            
            currentRange = renderComment(
                withTextRange: currentRange,
                andFramesetter: framesetter,
                in: rect
            )
            
            if currentRange.location == CFAttributedStringGetLength(currentText) {
                done = true
                
                if numberOfPages > 0 {
                    lastY = Constants.PDF_VERTICAL_PADDING
                }
            }
            
            numberOfPages += 1
            
        } while !done
        
        return (textBottom: lastY + textFrameSuggestedSize.height, numberOfPages: numberOfPages)
    }
    
    func renderComment(withTextRange currentRange: CFRange, andFramesetter framesetter: CTFramesetter?, in rect: CGRect) -> CFRange {
        var currentRange = currentRange
        
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.textMatrix = .identity
        
        let framePath = CGMutablePath()
        framePath.addRect(rect, transform: .identity)
        
        let frameRef = CTFramesetterCreateFrame(framesetter!, currentRange, framePath, nil)
    
        currentContext?.translateBy(x: 0, y: rect.height)
        currentContext?.scaleBy(x: 1.0, y: -1.0)
        
        CTFrameDraw(frameRef, currentContext!)
        
        currentRange = CTFrameGetVisibleStringRange(frameRef)
        currentRange.location += currentRange.length
        currentRange.length = CFIndex(0)
        
        // restore the old coordinate
        currentContext?.translateBy(x: 0, y: rect.height)
        currentContext?.scaleBy(x: 1.0, y: -1.0)
        
        return currentRange
    }
}
