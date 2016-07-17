Pod::Spec.new do |s|
  s.name        = "OpenGraph"
  s.version     = "0.0.1"
  s.summary     = "A Swift wrapper for the Open Graph protocol."
  s.homepage    = "https://github.com/satoshi-takano/OpenGraph"
  s.license     = "MIT"
  s.author      = "satoshi-takano"

  s.ios.deployment_target = "8.0"
  s.source                = { :git => "https://github.com/satoshi-takano/OpenGraph.git", :tag => s.version.to_s }
  s.source_files          = "OpenGraph/*.{swift,h,m}"
end
