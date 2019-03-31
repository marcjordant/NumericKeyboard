//
//  NKKeyboardButton.swift
//  NumericKeyboard
//
//  Created by Marc Jordant on 23/07/16.
//  Copyright © 2016 singleTapps. All rights reserved.
//

import UIKit

class NKKeyboardButton: UIButton
{
  @IBInspectable var backgroundColorForStateNormal: UIColor?
  @IBInspectable var backgroundColorForStateHighlighted: UIColor?
  
  var returnType = NKInputView.NKKeyboardReturnKeyType.default {
    didSet {
        self.setTitle(returnType.text(), for: UIControl.State())
        self.setTitleColor(returnType.textColor() ?? UIColor.black, for: UIControl.State.normal)
      self.backgroundColor = returnType.backgroundColor() ?? backgroundColorForStateNormal
    }
  }
  
  override var isHighlighted: Bool
    {
    get {
      return super.isHighlighted
    }
    set {
      if newValue {
        self.backgroundColor = backgroundColorForStateHighlighted
      }
      else {
        self.backgroundColor = returnType.backgroundColor() ?? backgroundColorForStateNormal
      }
      super.isHighlighted = newValue
    }
  }
  

  // MARK: - Object lifecycle -

  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 1
    layer.cornerRadius = 5
    
    DispatchQueue.main.async { () -> Void in
      self.backgroundColor = self.returnType.backgroundColor() ?? self.backgroundColorForStateNormal
    }
  }
 
  
  // MARK: - IBInspectable -

  override func prepareForInterfaceBuilder()
  {
    self.backgroundColor = self.returnType.backgroundColor() ?? self.backgroundColorForStateNormal
  }
}
