Pod::Spec.new do |s|
  s.name        = "OpenGraph"
  s.version     = "0.0.1"
  s.summary     = "A Swift wrapper for the Open Graph protocol."
  s.homepage    = "https://github.com/satoshi-takano/OpenGraph"
  s.license     = "MIT"
  s.author      = "satoshi-takano"
  s.description = <<-DESC
OpenGraph is a Swift wrapper for the Open Graph protocol. You can fetch OpenGraph,then you can access the attributes with subscript and the key provided by enum type.
DESC

  s.ios.deployment_target     = "8.0"
  s.source                    = { :git => "https://github.com/satoshi-takano/OpenGraph.git", :tag => s.version.to_s }
  s.source_files              = "OpenGraph/*.{swift,h,m}"
  s.osx.deployment_target     = "10.9"
  s.ios.deployment_target     = "8.0"
  s.tvos.deployment_target    = "9.0"
  s.watchos.deployment_target = "2.0"
end
