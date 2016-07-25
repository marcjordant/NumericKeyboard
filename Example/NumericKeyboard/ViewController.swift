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
    
    NKInputView.with(textFieldNumberPad, type: NKInputView.NKKeyboardType.NumberPad, returnKeyType: NKInputView.NKKeyboardReturnKeyType.Next)

    NKInputView.with(textFieldDecimalPad, type: NKInputView.NKKeyboardType.DecimalPad, returnKeyType: NKInputView.NKKeyboardReturnKeyType.Next)
    
    NKInputView.with(textFieldPhonePad, type: NKInputView.NKKeyboardType.PhonePad, returnKeyType: .Custom(text: "Hello"))
  }
  
  
  // MARK: - TextField delegate -

  func textFieldShouldReturn(textField: UITextField) -> Bool
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

