//
//  NKInputView.swift
//  NumericKeyboard
//
//  Created by Marc Jordant on 23/07/16.
//  Copyright © 2016 singleTapps. All rights reserved.
//

import UIKit

/**
 The class of the input view that shows a numeric keyboard

 - Author:
 Marc Jordant
 
 This numeric keyboard input view is intended to be a replacement of the default numeric keyboard on iPad. It shows only numerical keys instead of all symbols (including letters)
 */
public class NKInputView: UIView, UIInputViewAudioFeedback
{
  // MARK: - Enum -

  /**
   The type of the numeric keyboard
   */
  public enum NKKeyboardType : Int {
    /**
     A number pad (0-9). Suitable for PIN entry.
     */
    case NumberPad
    
    /**
     A number pad with a decimal point.
     */
    case DecimalPad
    
    /**
     A phone pad (0-9, +).
     */
    case PhonePad
  }

  /**
   The type of the return key of the keyboard.
   
   You can use the 4 predefined values:
    - Default
    - Search
    - Next
    - Save
   
   or use the Custom value and pass it a custom text
   */
  public enum NKKeyboardReturnKeyType
  {
    /**
     Shows the text "Return" in the return key
     */
    case Default
    
    /**
     Shows the text "Search" in the return key
     */
    case Search
    
    /**
     Shows the text "Next" in the return key
     */
    case Next
    
    /**
     Shows the text "Save" in the return key
     */
    case Save
    
    /**
     Shows the text "Go" in the return key
     */
    case Go
    
    /**
     Shows the text "Join" in the return key
     */
    case Join
    
    /**
     Shows the text "Route" in the return key
     */
    case Route
    
    /**
     Shows the text "Send" in the return key
     */
    case Send
    
    /**
     Shows the text "Done" in the return key
     */
    case Done
    
    
    /**
     Use this value for specifying a custom text
     
     - parameters:
        - text: the custom text to use for the return key
     */
    case Custom(text: String)
    
    
    func text() -> String {
      switch self {
      case .Custom(let text):
        return text
      default:
        let podBundle = NSBundle(forClass: NKInputView.self)
        let bundleURL = podBundle.URLForResource("NumericKeyboard", withExtension: "bundle")
        let bundle = NSBundle(URL: bundleURL!)!
        return NSLocalizedString("NumericKeyboard.return-key.\(self)", bundle: bundle, comment: "")
      }
    }
    
    func backgroundColor() -> UIColor? {
      switch self {
      case .Default, .Next:
        return nil
      default:
        return UIColor(red: 9/255.0, green: 126/255.0, blue: 254/255.0, alpha: 1)
      }
    }
    
    func textColor() -> UIColor? {
      switch self {
      case .Save, .Search:
        return UIColor.whiteColor()
      default:
        return nil
      }
    }
  }
  
  
  // MARK: - vars -

  private weak var textView: UITextInput?
  
  
  // MARK: - Private vars -
  
  private let TAG_B_DISMISS = 12
  private let TAG_B_BACKWARD = 13
  private let TAG_B_RETURN = 14

  
  // MARK: - Outlets -

  @IBOutlet private var bNext: NKKeyboardButton!
  @IBOutlet private var bPlus: UIButton!
  @IBOutlet private var bDot: UIButton!
  
  
  // MARK: - Static methods -

  /**
   Sets a NKInputView instance as the inputView of the specified textField or textView.
   
   - returns:
   The NKInputView instance if the inputView has been set, nil otherwise

   - parameters:
      - textView: The textField or textView on which set this numeric keyboard input view.
      - type: the type of the numeric keyboard. Default value is NKKeyboardType.DecimalPad
      - returnKeyType: the type of the return key. Default value is NKKeyboardReturnKeyType.Default
   
   - important:
   Only affect the input view on iPad. Do nothing on iPhone or iPod
   */
  public static func with(textView: UITextInput,
                          type: NKKeyboardType = .DecimalPad,
                          returnKeyType: NKKeyboardReturnKeyType = .Default) -> NKInputView?
  {
    guard UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad else {
      // This is not an iPad, do nothing
      return nil
    }
    
    // Load the view from xib
    let podBundle = NSBundle(forClass: NKInputView.self)
    let bundleURL = podBundle.URLForResource("NumericKeyboard", withExtension: "bundle")
    let bundle = NSBundle(URL: bundleURL!)!
    let nibName = "NumericKeyboard"
    let nib = UINib(nibName: nibName, bundle: bundle)
    let instance = nib.instantiateWithOwner(self, options: nil).first as! NKInputView
    
    instance.setup(textView, type: type, returnKeyType: returnKeyType)
    
    return instance
  }

  
  // MARK: - Private methods -

  // Initialize the view
  private func setup(textView: UITextInput, type: NKKeyboardType, returnKeyType: NKKeyboardReturnKeyType = .Default)
  {
    self.textView = textView
    
    if let textView = self.textView as? UITextField {
      textView.inputView = self
    }
    if let textView = self.textView as? UITextView {
      textView.inputView = self
    }

    if #available(iOS 9.0, *) {
      removeToolbar()
    }
    
    bNext.returnType = returnKeyType
    
    switch type {
    case .DecimalPad:
      bPlus.hidden = true
    case .NumberPad:
      bDot.hidden = true
      bPlus.hidden = true
    case .PhonePad:
      bDot.hidden = true
    }
    
    bDot.setTitle(NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as? String, forState: UIControlState.Normal)
  }
  
  // Remove the Undo/Redo toolbar
  @available(iOS 9.0, *)
  private func removeToolbar()
  {
    var item : UITextInputAssistantItem?
    if let txtView = self.textView as? UITextField {
      item = txtView.inputAssistantItem
    }
    if let txtView = self.textView as? UITextView {
      item = txtView.inputAssistantItem
    }
    item?.leadingBarButtonGroups = []
    item?.trailingBarButtonGroups = []
  }
  
  private func isTextField() -> Bool
  {
    if let _ = self.textView as? UITextField {
      return true
    }
    return false
  }
  
  private func isTextView() -> Bool
  {
    if let _ = self.textView as? UITextView {
      return true
    }
    return false
  }

  
  // MARK: - Size management -

  override public func intrinsicContentSize() -> CGSize
  {
    return CGSize(width: 100, height: 313)
  }

  
  // MARK: - UIInputViewAudioFeedback -
  
  public var enableInputClicksWhenVisible: Bool {
    return true
  }
  

  // MARK: - Events -

  @IBAction private func buttonPressed(sender: UIButton)
  {
    UIDevice.currentDevice().playInputClick()
    
    switch sender.tag {
    case let (x) where x < 12:
      let decimalChar = NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as? String ?? "."
      let buttonsValues = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", decimalChar, "+"]
      let char = buttonsValues[sender.tag]
      textView?.insertText(char)
      
      if isTextField() {
        NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidChangeNotification, object: self.textView)
      }
      else if isTextView() {
        NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self.textView)
      }
      
    case TAG_B_BACKWARD:
      textView?.deleteBackward()

      if isTextField() {
        NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidChangeNotification, object: self.textView)
      }
      else if isTextView() {
        NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self.textView)
      }
      
    case TAG_B_RETURN:
      if isTextField() {
        let textField = textView as! UITextField
        textField.delegate?.textFieldShouldReturn?(textField)
      }
      else if isTextView() {
        textView?.insertText("\n")
        NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self.textView)
      }

    case TAG_B_DISMISS:
      if let textView = self.textView as? UITextField {
        textView.resignFirstResponder()
      }
      if let textView = self.textView as? UITextView {
        textView.resignFirstResponder()
      }
      
    default:
      break
    }
  }
}
