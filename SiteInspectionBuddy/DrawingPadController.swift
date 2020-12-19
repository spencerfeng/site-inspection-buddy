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
    
    weak var delegate: DrawingPadControllerDelegate?
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        let width = view.frame.width
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        navigationBar.barTintColor = UIColor.white
        
        view.addSubview(navigationBar)
        
        let navigationItem = UINavigationItem(title: "Annotation")
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(handleDoneBtnClick))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(handleCancelBtnClick))
        
        navigationItem.rightBarButtonItem = doneBtn
        navigationItem.leftBarButtonItem = cancelBtn
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.bounds.width
        let height = (image.size.height / image.size.width) * width
        let canvas = CanvasView(image: image, color: UIColor(.green))
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
   }
    
    @objc func handleCancelBtnClick() {
        self.delegate?.drawingPadControllerWillDismiss(self)
    }
    
    @objc func handleDoneBtnClick() {
        guard let viewWithTag = self.view.viewWithTag(100) else { return } // TODO: do something if the canvas view can not be found
        guard let canvas = viewWithTag as? CanvasView else { return }
        self.delegate?.drawingPadControllerWillSaveDrawing(self, canvas: canvas)
    }
}
