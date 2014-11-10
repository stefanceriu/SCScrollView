Pod::Spec.new do |s|
  s.name     = 'SCScrollView'
  s.version  = '1.1.1'
  s.platform = :ios
  s.ios.deployment_target = '5.0'
  s.summary  = 'UIScrollView subclass that can use a custom easing function to animate the setting of the content offset'
  s.description = <<-DESC
                  UIScrollView subclass that can use a custom easing function to animate the setting of the content offset.
                    - supports all 30 easing functions defined in [AHEasing](https://github.com/warrenm/AHEasing) (wrapped inside SCEasingFunctions) which you can visualise at http://easings.net/
                    - adds a maximum number of touches property
                    - allows defining an UIBezierPath as a touch refusal area inside which touches will be ignored
                  DESC
  s.homepage = 'https://github.com/stefanceriu/SCScrollView'
  s.author   = { 'Stefan Ceriu' => 'stefan.ceriu@yahoo.com' }
  s.social_media_url = 'https://twitter.com/stefanceriu'
  s.source   = { :git => 'https://github.com/stefanceriu/SCScrollView.git', :tag => "v#{s.version}" }
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.source_files = 'SCScrollView/*'
  s.requires_arc = true
  s.frameworks = 'UIKit', 'QuartzCore','Foundation'

  s.dependency 'AHEasing', '~> 1.0'

end