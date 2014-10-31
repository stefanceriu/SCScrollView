Pod::Spec.new do |s|
  s.name     = 'SCScrollView'
  s.version  = '1.0.0'
  s.platform = :ios
  s.ios.deployment_target = '5.0'

  s.summary  = 'Custom scroll view subclass used in the stack and page view controllers'
  s.homepage = 'https://github.com/stefanceriu/SCScrollView'
  s.author   = { 'Stefan Ceriu' => 'stefan.ceriu@yahoo.com' }
  s.social_media_url = 'https://twitter.com/stefanceriu'
  s.source   = { :git => 'https://github.com/stefanceriu/SCScrollView.git', :tag => "v#{s.version}" }
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.source_files = 'SCScrollView/*'
  s.requires_arc = true
  s.frameworks = 'UIKit', 'QuartzCore','Foundation'

end