#
# Be sure to run `pod lib lint NumericKeyboard.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'NumericKeyboard'
  s.version          = '1.4.1'
  s.summary          = 'NumericKeyboard is a input view for UITextField & UITextView that shows a numeric entry keyboard on iPad.'

  s.description      = <<-DESC
This keyboard view is intended to replace the default keyboard on iPad for entering numerical values.
As the default keyboard on iPad still shows all keys even for numerical entry modes, this keyboard only focuses on numeric keys.
This is a fork of https://github.com/marcjordant/NumericKeyboard fixing some issues with more current Xcode & Swift versions.
                       DESC

  s.homepage         = 'https://github.com/Sevyls/NumericKeyboard'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Marc Jordant' => 'marcjordant@gmail.com' }
  s.source           = { :git => 'https://github.com/Sevyls/NumericKeyboard', :tag => s.version.to_s }
  s.screenshots      = 'https://github.com/marcjordant/NumericKeyboard/blob/master/example.png?raw=true'
  s.social_media_url = 'https://twitter.com/marcjordant'

  s.ios.deployment_target = '11.4'

  s.source_files = 'NumericKeyboard/Classes/**/*'
  
   s.resource_bundles = {
     'NumericKeyboard' => ['NumericKeyboard/Assets/**/*', 'NumericKeyboard/Resources/**/*']
   }

end
