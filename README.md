# NumericKeyboard

[![Version](https://img.shields.io/cocoapods/v/NumericKeyboard.svg?style=flat)](http://cocoapods.org/pods/NumericKeyboard)
[![License](https://img.shields.io/cocoapods/l/NumericKeyboard.svg?style=flat)](http://cocoapods.org/pods/NumericKeyboard)
[![Platform](https://img.shields.io/cocoapods/p/NumericKeyboard.svg?style=flat)](http://cocoapods.org/pods/NumericKeyboard)


## Description

This keyboard view is intended to replace the default keyboard on iPad for entering numerical values.
As the default keyboard on iPad still shows all keys even for numerical entry modes, this keyboard only focuses on numeric keys.

#### screenshot

![screenshot](https://github.com/marcjordant/NumericKeyboard/blob/master/example.png?raw=true)


## Localisation

The return key texts are available in 

  * English
  * French
  * Dutch
  * German
  * Spanish
  * Italian
  * Hebrew
  * Swedish


#### New language
If you want a new language to be supported, just [contact me](mailto:marcjordant@gmail.com?subject=NumericKeyboard) !

#### Custom text
You can also use the 

```Swift
NKKeyboardReturnKeyType.Custom(text: String) 
```

value as the return key type and use any text you want.


## Example

To set the Numeric Keyboard as an input view of a text field, just use NKInputView.with(_:, _:) :

_Declaration of the UITextField_

```Swift
@IBOutlet var textField: UITextField!
```

_Somewhere in viewDidLoad (for example), add this line_

```Swift
NKInputView.with(textField, type: .NumberPad, returnKeyType: .Next)
```

#### Example project

There is an example project where you can see how it works.
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8+

## Installation

NumericKeyboard is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NumericKeyboard"
```

## Author

Marc Jordant, marcjordant@gmail.com

## License

NumericKeyboard is available under the MIT license. See the LICENSE file for more info.
