//
//  ColorOptionsController.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 23/12/20.
//

import UIKit

protocol ColorOptionsControllerDelegate: AnyObject {
    func colorOptionsController(_ colorOptions: ColorOptionsController, didFinishPickingColor: UIColor)
}

class ColorOptionsController: UIViewController {
    let sfSymbolImageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
    
    weak var delegate: ColorOptionsControllerDelegate?
    
    override func loadView() {
        super.loadView()
        
        let yellowBtn = SolidColoredCircleButton(color: UIColor(.yellow))
        yellowBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.yellow), renderingMode: .alwaysOriginal), for: .normal)
        yellowBtn.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        
        let greenBtn = SolidColoredCircleButton(color: UIColor(.green))
        greenBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.green), renderingMode: .alwaysOriginal), for: .normal)
        greenBtn.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        
        let blueBtn = SolidColoredCircleButton(color: UIColor(.blue))
        blueBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal), for: .normal)
        blueBtn.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        
        let blackBtn = SolidColoredCircleButton(color: UIColor(.black))
        blackBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.black), renderingMode: .alwaysOriginal), for: .normal)
        blackBtn.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        
        let whiteBtn = SolidColoredCircleButton(color: UIColor(.white))
        whiteBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.white), renderingMode: .alwaysOriginal), for: .normal)
        whiteBtn.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        
        let orangeBtn = SolidColoredCircleButton(color: UIColor(.orange))
        orangeBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.orange), renderingMode: .alwaysOriginal), for: .normal)
        orangeBtn.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        
        let pinkBtn = SolidColoredCircleButton(color: UIColor(.pink))
        pinkBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.pink), renderingMode: .alwaysOriginal), for: .normal)
        pinkBtn.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        
        let redBtn = SolidColoredCircleButton(color: UIColor(.red))
        redBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.red), renderingMode: .alwaysOriginal), for: .normal)
        redBtn.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        
        let grayBtn = SolidColoredCircleButton(color: UIColor(.gray))
        grayBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.gray), renderingMode: .alwaysOriginal), for: .normal)
        grayBtn.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        
        let purpleBtn = SolidColoredCircleButton(color: UIColor(.purple))
        purpleBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.purple), renderingMode: .alwaysOriginal), for: .normal)
        purpleBtn.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        
        view.addSubview(yellowBtn)
        view.addSubview(greenBtn)
        view.addSubview(blueBtn)
        view.addSubview(blackBtn)
        view.addSubview(whiteBtn)
        view.addSubview(orangeBtn)
        view.addSubview(pinkBtn)
        view.addSubview(redBtn)
        view.addSubview(grayBtn)
        view.addSubview(purpleBtn)
        
        yellowBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yellowBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            yellowBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            yellowBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            yellowBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -Constants.POPOVER_ARROW_HEIGHT / 2.0)
        ])
        
        greenBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greenBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            greenBtn.leadingAnchor.constraint(equalTo: yellowBtn.trailingAnchor, constant: 0),
            greenBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            greenBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -Constants.POPOVER_ARROW_HEIGHT / 2.0)
        ])
        
        blueBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blueBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            blueBtn.leadingAnchor.constraint(equalTo: greenBtn.trailingAnchor, constant: 0),
            blueBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            blueBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -Constants.POPOVER_ARROW_HEIGHT / 2.0)
        ])
        
        blackBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blackBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            blackBtn.leadingAnchor.constraint(equalTo: blueBtn.trailingAnchor, constant: 0),
            blackBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            blackBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -Constants.POPOVER_ARROW_HEIGHT / 2.0)
        ])
        
        whiteBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            whiteBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            whiteBtn.leadingAnchor.constraint(equalTo: blackBtn.trailingAnchor, constant: 0),
            whiteBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            whiteBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -Constants.POPOVER_ARROW_HEIGHT / 2.0)
        ])
        
        orangeBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            orangeBtn.topAnchor.constraint(equalTo: yellowBtn.bottomAnchor, constant: 0),
            orangeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            orangeBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            orangeBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -Constants.POPOVER_ARROW_HEIGHT / 2.0)
        ])
        
        pinkBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pinkBtn.topAnchor.constraint(equalTo: yellowBtn.bottomAnchor, constant: 0),
            pinkBtn.leadingAnchor.constraint(equalTo: orangeBtn.trailingAnchor, constant: 0),
            pinkBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            pinkBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -Constants.POPOVER_ARROW_HEIGHT / 2.0)
        ])
        
        redBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            redBtn.topAnchor.constraint(equalTo: yellowBtn.bottomAnchor, constant: 0),
            redBtn.leadingAnchor.constraint(equalTo: pinkBtn.trailingAnchor, constant: 0),
            redBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            redBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -Constants.POPOVER_ARROW_HEIGHT / 2.0)
        ])
        
        grayBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            grayBtn.topAnchor.constraint(equalTo: yellowBtn.bottomAnchor, constant: 0),
            grayBtn.leadingAnchor.constraint(equalTo: redBtn.trailingAnchor, constant: 0),
            grayBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            grayBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -Constants.POPOVER_ARROW_HEIGHT / 2.0)
        ])
        
        purpleBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            purpleBtn.topAnchor.constraint(equalTo: yellowBtn.bottomAnchor, constant: 0),
            purpleBtn.leadingAnchor.constraint(equalTo: grayBtn.trailingAnchor, constant: 0),
            purpleBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            purpleBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -Constants.POPOVER_ARROW_HEIGHT / 2.0)
        ])
    }
    
    @objc func handleColorSelection(_ sender: SolidColoredCircleButton) {
        self.delegate?.colorOptionsController(self, didFinishPickingColor: sender.color)
    }
}
