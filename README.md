# NumericKeyboard

[![Version](https://img.shields.io/cocoapods/v/NumericKeyboard.svg?style=flat)](http://cocoapods.org/pods/NumericKeyboard)
[![License](https://img.shields.io/cocoapods/l/NumericKeyboard.svg?style=flat)](http://cocoapods.org/pods/NumericKeyboard)
[![Platform](https://img.shields.io/cocoapods/p/NumericKeyboard.svg?style=flat)](http://cocoapods.org/pods/NumericKeyboard)


## Description

This keyboard view is intended to replace the default keyboard on iPad for entering numerical values.
As the default keyboard on iPad still shows all keys even for numerical entry modes, this keyboard only focuses on numeric keys.

Here is an screenshot of the keyboard:

![screenshot](https://github.com/marcjordant/NumericKeyboard/blob/master/example.png)

## Example

```Swift
@IBOutlet var textField: UITextField!

NKInputView.with(textField, type: NKInputView.NKKeyboardType.NumberPad)
```

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
