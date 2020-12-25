//
//  DrawingPadController.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 16/12/20.
//

import UIKit

protocol DrawingPadControllerDelegate: AnyObject {
    func drawingPadControllerWillDismiss(_ drawingPad: DrawingPadController)
    func drawingPadControllerWillSaveDrawing(_ drawingPad: DrawingPadController, canvas: CanvasView)
}

class DrawingPadController: UIViewController {
    let image: UIImage
    let sfSymbolImageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
    let colorPickerBtnImg = UIImage(systemName: "circle.fill")
    let undoBtnImg = UIImage(systemName: "arrow.counterclockwise")
    let colorPickerBtn = UIButton(type: .custom)
    let undoBtn = UIButton(type: .custom)
    let colorPickerBarButtonItem = UIBarButtonItem()
    let canvas: CanvasView
    
    var strokeColor: UIColor
    weak var delegate: DrawingPadControllerDelegate?
    
    init(image: UIImage, strokeColor: UIColor) {
        self.image = image
        self.strokeColor = strokeColor
        self.canvas = CanvasView(image: image, strokeColor: strokeColor)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. add top navigation bar
        let navigationBar: UINavigationBar = UINavigationBar()
        navigationBar.barTintColor = UIColor.white
        
        let navigationItem = UINavigationItem(title: "Annotation")
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(handleDoneBtnClick))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(handleCancelBtnClick))
        
        navigationItem.rightBarButtonItem = doneBtn
        navigationItem.leftBarButtonItem = cancelBtn
        navigationBar.setItems([navigationItem], animated: false)
        
        view.addSubview(navigationBar)
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        // 2. add image canvas
        let width = view.bounds.width
        let height = (image.size.height / image.size.width) * width
        canvas.tag = 100
        canvas.isUserInteractionEnabled = true
        
        view.addSubview(canvas)
        
        canvas.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvas.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvas.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            canvas.widthAnchor.constraint(equalToConstant: width),
            canvas.heightAnchor.constraint(equalToConstant: height)
        ])
        
        // 3. add bottom toolbar
        
        // for some reason, if we do not initialise UIToolbar with a frame with a width value, we will get auto layout constraint conflicts with its bar items. Related issue on stackoverflow: https://stackoverflow.com/questions/54284029/uitoolbar-with-uibarbuttonitem-layoutconstraint-issue
        let bottomToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        bottomToolbar.barTintColor = UIColor.white
        
        // color picker button
        colorPickerBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(strokeColor, renderingMode: .alwaysOriginal), for: .normal)
        colorPickerBtn.addTarget(self, action: #selector(handleColorPickerBtnClicked), for: .touchUpInside)
        colorPickerBarButtonItem.customView = colorPickerBtn
        
        // undo button
        undoBtn.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: sfSymbolImageConfig), for: .normal)
        undoBtn.addTarget(self, action: #selector(handleUndoBtnClicked), for: .touchUpInside)
        let undoBarButtonItem = UIBarButtonItem(customView: undoBtn)
        
        // spacer
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        bottomToolbar.items = [spacer, colorPickerBarButtonItem, spacer, undoBarButtonItem, spacer]
        
        view.addSubview(bottomToolbar)
        
        bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomToolbar.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottomToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
   }
    
    @objc func handleCancelBtnClick() {
        self.delegate?.drawingPadControllerWillDismiss(self)
    }
    
    @objc func handleDoneBtnClick() {
        guard let viewWithTag = self.view.viewWithTag(100) else { return } // TODO: do something if the canvas view can not be found
        guard let canvas = viewWithTag as? CanvasView else { return }
        self.delegate?.drawingPadControllerWillSaveDrawing(self, canvas: canvas)
    }
    
    @objc func handleColorPickerBtnClicked() {
        let colorOptionsVC = ColorOptionsController()
        colorOptionsVC.delegate = self
        colorOptionsVC.preferredContentSize = CGSize(width: Constants.POPOVER_WIDTH, height: Constants.COLOR_PICKER_POPOVER_HEIGHT)
        colorOptionsVC.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = colorOptionsVC.popoverPresentationController!
        popover.sourceView = view
        popover.delegate = self
        popover.barButtonItem = colorPickerBarButtonItem
        present(colorOptionsVC, animated: true)
    }
    
    @objc func handleUndoBtnClicked() {
        print("undo button clicked")
    }
}

extension DrawingPadController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension DrawingPadController: ColorOptionsControllerDelegate {
    func colorOptionsController(_ colorOptions: ColorOptionsController, didFinishPickingColor color: UIColor) {
        strokeColor = color
        colorPickerBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(strokeColor, renderingMode: .alwaysOriginal), for: .normal)
        canvas.strokeColor = strokeColor
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
