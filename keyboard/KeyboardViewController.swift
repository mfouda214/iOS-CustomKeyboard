//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Mohamed Sobhi Fouda on 8/5/18.
//  Copyright © 2017 Quintin Gunter. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    private var capsLockOn = false
    
    private let mainKeyboardTitles = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["Z", "X", "C", "V", "B", "N", "M"],
        ["⇔", "Sym", "↑", "Space", "←", "↵"]
    ]
    
    private let symbolKeyboardTitles = [
        ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"],
        ["=", "+", "-", "-", "~", "`", ":", ";"],
        ["\\", "{", "}", "[", "]", "'", "\""],
        ["<", ">", ",", ".", "?", "/", "|"],
        ["⇔", "A-Z", "Space", "←", "↵"]
    ]
    
    private var mainKeyboardStackView: UIStackView!
    private var symbolKeyboardStackView: UIStackView!
    
    private let capsLockOnColor = UIColor(red: 0.5922, green: 0.5922, blue: 0.5922, alpha: 1.0)
    private let capsLockOffColor = UIColor.lightGray
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9862861037, green: 0.3796869516, blue: 0.3478165269, alpha: 1)
        
        mainKeyboardStackView = createKeyboardRowsInStackView(keyboardTitles: mainKeyboardTitles)
        mainKeyboardStackView.isHidden = false
        
        symbolKeyboardStackView = createKeyboardRowsInStackView(keyboardTitles: symbolKeyboardTitles)
        symbolKeyboardStackView.isHidden = true
        
    }
    
    private func createKeyboardRowsInStackView(keyboardTitles: [[String]]) -> UIStackView {
        var rowStackViews = [UIStackView]()
        
        for rowTitles in keyboardTitles {
            let newStackView = createButtonsRowStackView(titles: rowTitles)
            rowStackViews.append(newStackView)
        }
        let allRowsStackView = UIStackView(arrangedSubviews: rowStackViews)
        
        allRowsStackView.axis = .vertical
        allRowsStackView.alignment = .center
        allRowsStackView.spacing = 1
        view.addSubview(allRowsStackView)
        
        allRowsStackView.translatesAutoresizingMaskIntoConstraints = false
        allRowsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        allRowsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1).isActive = true
        
        return allRowsStackView
    }
    
    func createButtonsRowStackView(titles: [String]) -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 1
        
        for title in titles {
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            button.heightAnchor.constraint(equalToConstant: 42).isActive = true
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9)
            button.layer.cornerRadius = 3
            button.addTarget(self, action: #selector(KeyboardViewController.tappedButton(button:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }
    
    
    func tappedButton(button: UIButton) {
        let keyTitle = button.titleLabel!.text
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        switch keyTitle! {
        case "↑":
            capsLockOn = !capsLockOn
            button.backgroundColor = capsLockOn ? capsLockOnColor : capsLockOffColor
        case "⇔":
            advanceToNextInputMode()
        case "Space":
            proxy.insertText(" ")
        case "←":
            proxy.deleteBackward()
        case "↵":
            proxy.insertText("\n")
        case "Sym":
            mainKeyboardStackView.isHidden = true
            symbolKeyboardStackView.isHidden = false
        case "A-Z":
            mainKeyboardStackView.isHidden = false
            symbolKeyboardStackView.isHidden = true
        default:
            let textToInset = capsLockOn ? keyTitle!.uppercased() : keyTitle!.lowercased()
            proxy.insertText(textToInset)
        }
    }
    
}
