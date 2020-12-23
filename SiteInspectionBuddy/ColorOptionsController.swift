//
//  ColorOptionsController.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 23/12/20.
//

import UIKit

class ColorOptionsController: UIViewController {
    let sfSymbolImageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
    
    override func loadView() {
        super.loadView()
        
        let yellowBtn = UIButton(type: .custom)
        yellowBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.yellow), renderingMode: .alwaysOriginal), for: .normal)
        
        let greenBtn = UIButton(type: .custom)
        greenBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.green), renderingMode: .alwaysOriginal), for: .normal)
        
        let blueBtn = UIButton(type: .custom)
        blueBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.blue), renderingMode: .alwaysOriginal), for: .normal)
        
        let blackBtn = UIButton(type: .custom)
        blackBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.black), renderingMode: .alwaysOriginal), for: .normal)
        
        let whiteBtn = UIButton(type: .custom)
        whiteBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.white), renderingMode: .alwaysOriginal), for: .normal)
        
        let orangeBtn = UIButton(type: .custom)
        orangeBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.orange), renderingMode: .alwaysOriginal), for: .normal)
        
        let pinkBtn = UIButton(type: .custom)
        pinkBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.pink), renderingMode: .alwaysOriginal), for: .normal)
        
        let redBtn = UIButton(type: .custom)
        redBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.red), renderingMode: .alwaysOriginal), for: .normal)
        
        let grayBtn = UIButton(type: .custom)
        grayBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.gray), renderingMode: .alwaysOriginal), for: .normal)
        
        let purpleBtn = UIButton(type: .custom)
        purpleBtn.setImage(UIImage(systemName: "circle.fill", withConfiguration: sfSymbolImageConfig)?.withTintColor(UIColor(.purple), renderingMode: .alwaysOriginal), for: .normal)
        
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
}
