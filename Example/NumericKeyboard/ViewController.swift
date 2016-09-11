//
//  ViewController.swift
//  NumericKeyboard
//
//  Created by Marc Jordant on 23/07/2016.
//  Copyright (c) 2016 Marc Jordant. All rights reserved.
//

import UIKit
import NumericKeyboard

class ViewController: UIViewController, UITextFieldDelegate
{
  @IBOutlet var textFieldNumberPad: UITextField!
  @IBOutlet var textFieldDecimalPad: UITextField!
  @IBOutlet var textFieldPhonePad: UITextField!
  
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    let _ = NKInputView.with(textFieldNumberPad, type: NKInputView.NKKeyboardType.numberPad, returnKeyType: NKInputView.NKKeyboardReturnKeyType.next)

    let _ = NKInputView.with(textFieldDecimalPad, type: NKInputView.NKKeyboardType.decimalPad, returnKeyType: NKInputView.NKKeyboardReturnKeyType.next)
    
    let _ = NKInputView.with(textFieldPhonePad, type: NKInputView.NKKeyboardType.phonePad, returnKeyType: .custom(text: "Hello"))
  }
  
  
  // MARK: - TextField delegate -

  func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
    switch textField {
      
    case textFieldNumberPad:
      textFieldDecimalPad.becomeFirstResponder()
      return true
      
    case textFieldDecimalPad:
      textFieldPhonePad.becomeFirstResponder()
      return true
      
    case textFieldPhonePad:
      textFieldPhonePad.resignFirstResponder()
      return true

    default:
      return true
    }
  }
}

