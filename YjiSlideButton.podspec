

Pod::Spec.new do |s|

  s.name         = "YjiSlideButton"
  s.version      = "0.0.1"
  s.summary      = 'YjiSlideButton.'
  s.description  = <<-DESC
		Slide button
                   DESC

  s.homepage     = "https://github.com/Ericji1989114/YjiSlideButton"
  s.license = 'MIT'
  s.author    = { "Eric" => "jiyunshyp@gmail.com" }

  s.source = { :git => 'https://github.com/Ericji1989114/YjiSlideButton.git', :tag => 'v1.0' }
  s.swift_version = '4.2'
  s.source_files = 'YjiSlideButton/*.swift'
  s.ios.deployment_target = '12.0'


end
