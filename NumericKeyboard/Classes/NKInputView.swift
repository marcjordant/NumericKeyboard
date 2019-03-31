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
open class NKInputView: UIView, UIInputViewAudioFeedback
{
  // MARK: - Enum -

  /**
   The type of the numeric keyboard
   */
  public enum NKKeyboardType : Int {
    /**
     A number pad (0-9). Suitable for PIN entry.
     */
    case numberPad
    
    /**
     A number pad with a decimal point.
     */
    case decimalPad
    
    /**
     A phone pad (0-9, +).
     */
    case phonePad
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
    case `default`
    
    /**
     Shows the text "Search" in the return key
     */
    case search
    
    /**
     Shows the text "Next" in the return key
     */
    case next
    
    /**
     Shows the text "Save" in the return key
     */
    case save
    
    /**
     Shows the text "Go" in the return key
     */
    case go
    
    /**
     Shows the text "Join" in the return key
     */
    case join
    
    /**
     Shows the text "Route" in the return key
     */
    case route
    
    /**
     Shows the text "Send" in the return key
     */
    case send
    
    /**
     Shows the text "Done" in the return key
     */
    case done
    
    
    /**
     Use this value for specifying a custom text
     
     - parameters:
        - text: the custom text to use for the return key
     */
    case custom(text: String, actionButton: Bool)
    
    
    func text() -> String {
      switch self {
      case .custom(let text, _):
        return text
      default:
        let podBundle = Bundle(for: NKInputView.self)
        let bundleURL = podBundle.url(forResource: "NumericKeyboard", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        return NSLocalizedString("NumericKeyboard.return-key.\(self)", bundle: bundle, comment: "")
      }
    }
    
    func backgroundColor() -> UIColor? {
      switch self {
      case .save, .search, .go:
        return UIColor(red: 9/255.0, green: 126/255.0, blue: 254/255.0, alpha: 1)
      case .custom(_, let actionButton) where actionButton:
        return UIColor(red: 9/255.0, green: 126/255.0, blue: 254/255.0, alpha: 1)
      default:
        return nil
      }
    }
    
    func textColor() -> UIColor? {
      switch self {
      case .save, .search, .go:
        return UIColor.white
      case .custom(_, let actionButton) where actionButton:
        return UIColor.white
      default:
        return nil
      }
    }
  }
  
  /**
   Indexes of additional buttons (those that can be added on the left)
   */
  public enum AdditionalButtonIndex {
    case one, two, three, four
  }

  
  // MARK: - vars -

  fileprivate weak var textView: NumericTextInput?
  
  
  // MARK: - Private vars -
  
  fileprivate let TAG_B_DISMISS = 12
  fileprivate let TAG_B_BACKWARD = 13
  fileprivate let TAG_B_RETURN = 14

  fileprivate var bLeft1Action: (() -> Void)?
  fileprivate var bLeft2Action: (() -> Void)?
  fileprivate var bLeft3Action: (() -> Void)?
  fileprivate var bLeft4Action: (() -> Void)?
  
  
  // MARK: - Outlets -

  @IBOutlet fileprivate var bNext: NKKeyboardButton!
  @IBOutlet fileprivate var bPlus: UIButton!
  @IBOutlet fileprivate var bDot: UIButton!

  @IBOutlet fileprivate var bLeft1: NKKeyboardButton!
  @IBOutlet fileprivate var bLeft2: NKKeyboardButton!
  @IBOutlet fileprivate var bLeft3: NKKeyboardButton!
  @IBOutlet fileprivate var bLeft4: NKKeyboardButton!


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
    @discardableResult public static func with(_ textView: NumericTextInput,
                          type: NKKeyboardType = .decimalPad,
                          returnKeyType: NKKeyboardReturnKeyType = .default) -> NKInputView?
  {
    guard UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad else {
      // This is not an iPad, do nothing
      return nil
    }
    
    // Load the view from xib
    let podBundle = Bundle(for: NKInputView.self)
    let bundleURL = podBundle.url(forResource: "NumericKeyboard", withExtension: "bundle")
    let bundle = Bundle(url: bundleURL!)!
    let nibName = "NumericKeyboard"
    let nib = UINib(nibName: nibName, bundle: bundle)
    let instance = nib.instantiate(withOwner: self, options: nil).first as! NKInputView
    
    instance.setup(textView, type: type, returnKeyType: returnKeyType)
    
    return instance
  }

  /**
   Sets the additional button at the given index.
   
   Up to 4 additional buttons can be added on the left of the keyboard.
   The place of each is specified with the index parameter.
   
   - parameter title: the title of the button
   - parameter at: the index of the button
   - parameter action: the block of code to execute when the UIControlEvents.touchUpInside event is triggered for this button
   */
  open func setAdditionalButton(title: String, at index: AdditionalButtonIndex, action: @escaping () -> Void)
  {
    removeAdditionalButton(at: index)
    
    var button = bLeft1
    
    switch index {
    case .one:
      button = bLeft1
      bLeft1Action = action
    case .two:
      button = bLeft2
      bLeft2Action = action
    case .three:
      button = bLeft3
      bLeft3Action = action
    case .four:
      button = bLeft4
      bLeft4Action = action
    }
    
    button?.returnType = .custom(text: title, actionButton: true)
    button?.isHidden = false
    button?.addTarget(self, action: #selector(NKInputView.additionalButtonTouched(sender:)), for: UIControl.Event.touchUpInside)
  }

  /**
   Removes the additional button at the given index.
   
   - parameter at: the index of the button
   */
  open func removeAdditionalButton(at index: AdditionalButtonIndex)
  {
    var button = bLeft1
    
    switch index {
    case .one:
      button = bLeft1
    case .two:
      button = bLeft2
    case .three:
      button = bLeft3
    case .four:
      button = bLeft4
    }

    button?.isHidden = true
    button?.removeTarget(nil, action: nil, for: UIControl.Event.touchUpInside)
  }

  
  // MARK: - Private methods -

  // Initialize the view
  fileprivate func setup(_ textView: NumericTextInput, type: NKKeyboardType, returnKeyType: NKKeyboardReturnKeyType = .default)
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
    case .decimalPad:
      bPlus.isHidden = true
    case .numberPad:
      bDot.isHidden = true
      bPlus.isHidden = true
    case .phonePad:
      bDot.isHidden = true
    }
    
    bDot.setTitle((Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as? String, for: UIControl.State.normal)
  }
  
  // Remove the Undo/Redo toolbar
  @available(iOS 9.0, *)
  fileprivate func removeToolbar()
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
  
  fileprivate func isTextField() -> Bool
  {
    if let _ = self.textView as? UITextField {
      return true
    }
    return false
  }
  
  fileprivate func isTextView() -> Bool
  {
    if let _ = self.textView as? UITextView {
      return true
    }
    return false
  }

  
  // MARK: - Size management -

  override open var intrinsicContentSize : CGSize
  {
    return CGSize(width: 100, height: 313)
  }

  
  // MARK: - UIInputViewAudioFeedback -
  
  open var enableInputClicksWhenVisible: Bool {
    return true
  }
  

  // MARK: - Events -

  @IBAction fileprivate func buttonPressed(_ sender: UIButton)
  {
    UIDevice.current.playInputClick()
    
    switch sender.tag {
    case let (x) where x < 12:
      let decimalChar = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as? String ?? "."
      let buttonsValues = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", decimalChar, "+"]
      let char = buttonsValues[sender.tag]

      textView?.numericInsertText(char)

    case TAG_B_BACKWARD:
      textView?.numericDeleteBackward()
      
    case TAG_B_RETURN:
      textView?.numericInsertReturn()

    case TAG_B_DISMISS:
      textView?.numericDismiss()
      
    default:
      break
    }
  }
  
  @objc fileprivate func additionalButtonTouched(sender: UIButton)
  {
    switch sender {
    case bLeft1:
      bLeft1Action?()
    case bLeft2:
      bLeft2Action?()
    case bLeft3:
      bLeft3Action?()
    case bLeft4:
      bLeft4Action?()
    default:
      break
    }
  }
}

public protocol NumericTextInput: UITextInput {
    func numericInsertText(_ text: String)
    func numericDeleteBackward()
    func numericInsertReturn()
    func numericDismiss()

    var inputView: UIView? { get set }
}

public extension UITextRange {
    func range(for textField: UITextField) -> NSRange {
        let startPos = textField.offset(from: textField.beginningOfDocument, to: self.start)
        let endPos = textField.offset(from: textField.beginningOfDocument, to: self.end)

        return NSMakeRange(startPos, endPos - startPos)
    }
}

extension UITextField: NumericTextInput {
    func selectedRange() -> NSRange? {
        if let range = self.selectedTextRange {
            return range.range(for: self)
        }

        return nil
    }

    public func numericInsertText(_ text: String) {
        var shouldChange = true

        if let delegate = self.delegate, let range = self.selectedRange() {
            shouldChange = delegate.textField?(self, shouldChangeCharactersIn: range, replacementString: text) ?? true
        }

        if shouldChange {
            self.insertText(text)

            NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
        }
    }

    public func numericDeleteBackward() {
        var shouldChange = true

        if let delegate = self.delegate, let range = self.selectedTextRange {
            var newRange = range
            if let newStart = self.position(from: range.start, in: .left, offset: 1), range.start == range.end {
                newRange = self.textRange(from: newStart, to: range.end) ?? newRange
            }

            let nsRange = newRange.range(for: self)
            shouldChange = delegate.textField?(self, shouldChangeCharactersIn: nsRange, replacementString: "") ?? true
        }

        if shouldChange {
            self.deleteBackward()
            NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
        }
    }

    public func numericInsertReturn() {
        let _ = self.delegate?.textFieldShouldReturn?(self)
    }

    public func numericDismiss() {
        self.resignFirstResponder()
    }
}

extension UITextView: NumericTextInput {
    public func numericInsertText(_ text: String) {
        self.insertText(text)
        NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
    }

    public func numericDeleteBackward() {
        self.deleteBackward()
        NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
    }

    public func numericInsertReturn() {
        self.insertText("\n")
        NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
    }

    public func numericDismiss() {
        self.resignFirstResponder()
    }
}
