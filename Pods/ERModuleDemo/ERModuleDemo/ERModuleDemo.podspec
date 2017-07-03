Pod::Spec.new do |s|
  s.name         = "ERModuleDemo"
  s.version      = "1.0.0"
  s.summary      = "ERModuleDemo"
  s.homepage     = "https://github.com/ErHu1993/ERModule.git"
  s.license      = "MIT"
  s.author             = { "胡广宇" => "" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/ErHu1993/ERModule.git", :tag => s.version }
  s.source_files  = "ERModuleDemo/Classes/*"
end
