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
  
  var returnType = NKInputView.NKKeyboardReturnKeyType.Default {
    didSet {
      self.setTitle(returnType.text(), forState: UIControlState.Normal)
      self.setTitleColor(returnType.textColor() ?? UIColor.blackColor(), forState: UIControlState.Normal)
      self.backgroundColor = returnType.backgroundColor() ?? backgroundColorForStateNormal
    }
  }
  
  override var highlighted: Bool
    {
    get {
      return super.highlighted
    }
    set {
      if newValue {
        self.backgroundColor = backgroundColorForStateHighlighted
      }
      else {
        self.backgroundColor = returnType.backgroundColor() ?? backgroundColorForStateNormal
      }
      super.highlighted = newValue
    }
  }
  

  // MARK: - Object lifecycle -

  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    
    layer.shadowColor = UIColor.lightGrayColor().CGColor
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 1
    layer.cornerRadius = 5
    
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
      self.backgroundColor = self.returnType.backgroundColor() ?? self.backgroundColorForStateNormal
    }
  }
 
  
  // MARK: - IBInspectable -

  override func prepareForInterfaceBuilder()
  {
    self.backgroundColor = self.returnType.backgroundColor() ?? self.backgroundColorForStateNormal
  }
}