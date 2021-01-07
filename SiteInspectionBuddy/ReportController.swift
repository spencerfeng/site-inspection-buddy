//
//  ReportController.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 1/1/21.
//

import Foundation
import UIKit
import PDFKit

enum SingleLineTextPosition {
    case left, center, right
}

class ReportController: UIViewController {
    let project: Project
    let pdfView: PDFView
    
    let pdfWidth = CGFloat(8.5 * 72.0)
    let pdfHeight = CGFloat(11 * 72.0)
    
    var currentPageNumber = 0
    
    var pdfData: Data? = nil
    
    lazy var pdfContentWidth: CGFloat = {
        return pdfWidth - 2 * Constants.PDF_HORIZONTAL_PADDING
    }()
    
    lazy var pdfContentHeight: CGFloat = {
        return pdfHeight - 2 * Constants.PDF_VERTICAL_PADDING
    }()
    
    lazy var issuePhotoMaxHeight: CGFloat = {
        return pdfContentHeight * 0.3
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(sharePDF)
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }
            
            let data = self.generatePDF()
            self.pdfData = self.generatePDF()
            DispatchQueue.main.async { [weak self] in
                self?.pdfView.document = PDFDocument(data: data)
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
            addPage(context: context, pageNumber: &currentPageNumber)
            
            // draw report title
            let reportTitleTextRect = prepareDrawingMultiLineText(
                text: project.title ?? "",
                fontSize: Constants.PDF_REPORT_TITLE_FONT_SIZE,
                color: UIColor(.black),
                weight: .bold,
                at: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: Constants.PDF_VERTICAL_PADDING + pdfContentWidth * 5.0 / 12.0),
                withWidth: pdfContentWidth
            )
            
            var lastY = drawMultiLineText(text: reportTitleTextRect.text, in: reportTitleTextRect.rect)
            
            // draw issues
            addPage(context: context, pageNumber: &currentPageNumber)
            
            lastY = Constants.PDF_VERTICAL_PADDING
            
            for issue in project.issuesArray.reversed() {
                // we make sure that title, separator and image (if there is one) are display on the same page
                
                // prepare drawing issue title
                var issueTitleTextRect = prepareDrawingMultiLineText(
                    text: issue.title ?? "",
                    fontSize: Constants.PDF_ISSUE_TITLE_FONT_SIZE,
                    color: UIColor(.black),
                    weight: .bold,
                    at: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: lastY == Constants.PDF_VERTICAL_PADDING ? lastY : lastY + Constants.PDF_ISSUE_ITEM_SPACING),
                    withWidth: pdfContentWidth
                )
                
                if issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height + 1.5 * Constants.DEFAULT_MARGIN > pdfHeight - Constants.PDF_VERTICAL_PADDING {
                    // start a new page if title is at the very bottom of a page
                    addPage(context: context, pageNumber: &currentPageNumber)
                    
                    issueTitleTextRect = (
                        text: issueTitleTextRect.text,
                        rect: CGRect(
                            x: issueTitleTextRect.rect.origin.x,
                            y: Constants.PDF_VERTICAL_PADDING,
                            width: issueTitleTextRect.rect.width,
                            height: issueTitleTextRect.rect.height
                        )
                    )
                }
                
                // prepare drawing issue assignee
                var issueAssigneeTextRect = prepareDrawingMultiLineText(
                    text: issue.assignee != nil ? "Assigned to: \(issue.assignee!)" : "",
                    fontSize: Constants.PDF_ISSUE_ASSIGNEE_FONT_SIZE,
                    color: UIColor(.gray),
                    weight: .regular,
                    at: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height + 0.5 * Constants.DEFAULT_MARGIN),
                    withWidth: pdfContentWidth
                )
                
                if issueAssigneeTextRect.rect.origin.y + issueAssigneeTextRect.rect.height + 1.5 * Constants.DEFAULT_MARGIN > pdfHeight - Constants.PDF_VERTICAL_PADDING {
                    // start a new page if assignee is at the very bottom of a page
                    addPage(context: context, pageNumber: &currentPageNumber)
                    
                    issueTitleTextRect = (
                        text: issueTitleTextRect.text,
                        rect: CGRect(
                            x: issueTitleTextRect.rect.origin.x,
                            y: Constants.PDF_VERTICAL_PADDING,
                            width: issueTitleTextRect.rect.width,
                            height: issueTitleTextRect.rect.height
                        )
                    )
                    
                    issueAssigneeTextRect = (
                        text: issueAssigneeTextRect.text,
                        rect: CGRect(
                            x: issueAssigneeTextRect.rect.origin.x,
                            y: issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height,
                            width: issueAssigneeTextRect.rect.width,
                            height: issueAssigneeTextRect.rect.height
                        )
                    )
                }
                
                var issueTitleSeparatorBottomY = prepareDrawingHorizontalLine(
                    startY: issueAssigneeTextRect.rect.origin.y + issueAssigneeTextRect.rect.height + Constants.DEFAULT_MARGIN,
                    thickness: 5
                )
                
                if issueTitleSeparatorBottomY + 1.5 * Constants.DEFAULT_MARGIN > pdfHeight - Constants.PDF_VERTICAL_PADDING {
                    // start a new page if issue title separator is at the very bottom of a page
                    addPage(context: context, pageNumber: &currentPageNumber)
                    
                    issueTitleTextRect = (
                        text: issueTitleTextRect.text,
                        rect: CGRect(
                            x: issueTitleTextRect.rect.origin.x,
                            y: Constants.PDF_VERTICAL_PADDING,
                            width: issueTitleTextRect.rect.width,
                            height: issueTitleTextRect.rect.height
                        )
                    )
                    
                    issueAssigneeTextRect = (
                        text: issueAssigneeTextRect.text,
                        rect: CGRect(
                            x: issueAssigneeTextRect.rect.origin.x,
                            y: issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height,
                            width: issueAssigneeTextRect.rect.width,
                            height: issueAssigneeTextRect.rect.height
                        )
                    )
                    
                    issueTitleSeparatorBottomY = prepareDrawingHorizontalLine(
                        startY: issueAssigneeTextRect.rect.origin.y + issueAssigneeTextRect.rect.height + Constants.DEFAULT_MARGIN,
                        thickness: 5
                    )
                }
                
                if let issuePhoto = issue.firstPhoto {
                    // this isssue has a photo
                    var issuePhotoDrawingRect = prepareDrawingImage(
                        image: issuePhoto,
                        at: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: issueTitleSeparatorBottomY + Constants.DEFAULT_MARGIN),
                        withWidth: pdfContentWidth * 0.3,
                        maxHeight: issuePhotoMaxHeight
                    )
                    
                    // if the image can not fit in this page, we start a new page
                    if issuePhotoDrawingRect.origin.y + issuePhotoDrawingRect.height > pdfHeight - Constants.PDF_VERTICAL_PADDING {
                        // start a new page if issue photo is at the very bottom of a page
                        addPage(context: context, pageNumber: &currentPageNumber)
                        
                        issueTitleTextRect = (
                            text: issueTitleTextRect.text,
                            rect: CGRect(
                                x: issueTitleTextRect.rect.origin.x,
                                y: Constants.PDF_VERTICAL_PADDING,
                                width: issueTitleTextRect.rect.width,
                                height: issueTitleTextRect.rect.height
                            )
                        )
                        
                        issueAssigneeTextRect = (
                            text: issueAssigneeTextRect.text,
                            rect: CGRect(
                                x: issueAssigneeTextRect.rect.origin.x,
                                y: issueTitleTextRect.rect.origin.y + issueTitleTextRect.rect.height,
                                width: issueAssigneeTextRect.rect.width,
                                height: issueAssigneeTextRect.rect.height
                            )
                        )
                        
                        issueTitleSeparatorBottomY = prepareDrawingHorizontalLine(
                            startY: issueAssigneeTextRect.rect.origin.y + issueAssigneeTextRect.rect.height + Constants.DEFAULT_MARGIN,
                            thickness: 5
                        )
                        
                        issuePhotoDrawingRect = prepareDrawingImage(
                            image: issuePhoto,
                            at: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: issueTitleSeparatorBottomY + Constants.DEFAULT_MARGIN),
                            withWidth: pdfContentWidth * 0.3,
                            maxHeight: issuePhotoMaxHeight
                        )
                    }
                    
                    // draw issue title
                    let _ = drawMultiLineText(text: issueTitleTextRect.text, in: issueTitleTextRect.rect)
                    // draw issue assignee
                    let _ = drawMultiLineText(text: issueAssigneeTextRect.text, in: issueAssigneeTextRect.rect)
                    // draow issue title separator
                    let _ = drawHorizontalLine(
                        drawContext,
                        startAt: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: issueAssigneeTextRect.rect.origin.y + issueAssigneeTextRect.rect.height + Constants.DEFAULT_MARGIN),
                        endAt: CGPoint(x: pdfWidth - Constants.PDF_HORIZONTAL_PADDING, y: issueAssigneeTextRect.rect.origin.y + issueAssigneeTextRect.rect.height + Constants.DEFAULT_MARGIN),
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
                    let infoOfAddedText = drawMultiPageText(
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
                    let _ = drawMultiLineText(text: issueTitleTextRect.text, in: issueTitleTextRect.rect)
                    // draw issue assignee
                    let _ = drawMultiLineText(text: issueAssigneeTextRect.text, in: issueAssigneeTextRect.rect)
                    // draow issue title separator
                    let _ = drawHorizontalLine(
                        drawContext,
                        startAt: CGPoint(x: Constants.PDF_HORIZONTAL_PADDING, y: issueAssigneeTextRect.rect.origin.y + issueAssigneeTextRect.rect.height + Constants.DEFAULT_MARGIN),
                        endAt: CGPoint(x: pdfWidth - Constants.PDF_HORIZONTAL_PADDING, y: issueAssigneeTextRect.rect.origin.y + issueAssigneeTextRect.rect.height + Constants.DEFAULT_MARGIN),
                        thickness: 5,
                        color: UIColor(.blue).cgColor
                    )
                    // draw issue comment
                    let infoOfAddedText = drawMultiPageText(
                        issue.comment ?? "",
                        context: context,
                        in: CGRect(
                            x: Constants.PDF_HORIZONTAL_PADDING,
                            // TODO: write an article about this: why we need to negate it.
                            y: -(issueTitleSeparatorBottomY + Constants.DEFAULT_MARGIN),
                            width: pdfContentWidth,
                            height: pdfContentHeight - (issueTitleSeparatorBottomY + Constants.DEFAULT_MARGIN)
                        ),
                        fromY: issueTitleSeparatorBottomY + Constants.DEFAULT_MARGIN
                    )
                    
                    lastY = infoOfAddedText.textBottom
                }
            }
        }
        
        return data
    }
    
    @objc func sharePDF(_ sender: UIBarButtonItem) {
        guard let data = pdfData else { return }
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityVC.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .markupAsPDF,
            .postToFacebook,
            .postToFlickr,
            .postToTencentWeibo,
            .postToTwitter,
            .postToVimeo,
            .postToWeibo,
            .saveToCameraRoll
        ]
        activityVC.popoverPresentationController?.barButtonItem = sender
        present(activityVC, animated: true, completion: nil)
    }
    
    func prepareDrawingSingleLineText(text: String, fontSize: CGFloat, color: UIColor, weight: UIFont.Weight) -> NSAttributedString {
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let textAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: color
        ]
        let attributedText = NSAttributedString(
            string: text,
            attributes: textAttributes
        )
        
        return attributedText
    }
    
    func drawSingleLineText(text: NSAttributedString, in container: CGRect, position: SingleLineTextPosition = .left) -> CGFloat {
        switch position {
        case .left:
            text.draw(at: CGPoint(x: container.origin.x, y: container.origin.y))
        case .right:
            text.draw(at: CGPoint(x: container.width - text.size().width + container.origin.x, y: container.origin.y))
        case .center:
            text.draw(at: CGPoint(x: (container.width - text.size().width) / 2.0 + container.origin.x, y: container.origin.y))
        }
        
        return container.origin.y + text.size().height
    }
    
    func prepareDrawingMultiLineText(text: String, fontSize: CGFloat, color: UIColor, weight: UIFont.Weight, at: CGPoint, withWidth: CGFloat) -> (text: NSAttributedString, rect: CGRect) {
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: color
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
    
    func drawMultiLineText(text: NSAttributedString, in rect: CGRect) -> CGFloat {
        text.draw(in: rect)
        
        return rect.origin.y + rect.height
    }
    
    func getTextRectHeight(textWidth: CGFloat, textHeight: CGFloat, rectWidth: CGFloat) -> CGFloat {
        return ceil(textWidth / rectWidth) * textHeight
    }
    
    func prepareDrawingImage(image: UIImage, at: CGPoint, withWidth: CGFloat, maxHeight: CGFloat) -> CGRect {
        var drawingW = withWidth
        
        let aspectRatio = image.size.height / image.size.width
        var drawingH = aspectRatio * drawingW
        
        if drawingH > maxHeight {
            drawingW = maxHeight / aspectRatio
            drawingH = maxHeight
        }
        
        return CGRect(x: at.x, y: at.y, width: drawingW, height: drawingH)
    }
    
    func drawImage(bgImage: UIImage, annotationImage: UIImage?, in rect: CGRect) -> CGFloat {
        bgImage.draw(in: rect)
        
        if let annotationImage = annotationImage {
            annotationImage.draw(in: rect)
        }
        
        return rect.origin.y + rect.height
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
    
    func drawMultiPageText(_ text: String, context: UIGraphicsPDFRendererContext, in initialRect: CGRect, fromY lastY: CGFloat) -> (textBottom: CGFloat, numberOfPages: Int) {
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
                addPage(context: context, pageNumber: &currentPageNumber)
                
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
            
            currentRange = renderMultiPageTextRange(
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
    
    func renderMultiPageTextRange(withTextRange currentRange: CFRange, andFramesetter framesetter: CTFramesetter?, in rect: CGRect) -> CFRange {
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
    
    func drawPageNumber(_ pageNumber: Int) {
        let attributedPageNumber = prepareDrawingSingleLineText(
            text: "Page \(pageNumber)",
            fontSize: Constants.PDF_PAGE_NUMBER_FONT_SIZE,
            color: UIColor(.black),
            weight: .regular
        )
        
        let _ = drawSingleLineText(
            text: attributedPageNumber,
            in: CGRect(
                x: Constants.PDF_HORIZONTAL_PADDING,
                y: pdfHeight - 0.5 * Constants.PDF_VERTICAL_PADDING,
                width: pdfContentWidth,
                height: attributedPageNumber.size().height
            ),
            position: .center
        )
    }
    
    func addPage(context: UIGraphicsPDFRendererContext, pageNumber: inout Int) {
        context.beginPage()
        pageNumber += 1
        drawPageNumber(pageNumber)
    }
}
