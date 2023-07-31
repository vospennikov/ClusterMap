Pod::Spec.new do |spec|
  spec.name                  = 'ClusterMap'
  spec.version               = '1.1.0'
  spec.license               = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage              = 'https://github.com/vospennikov/ClusterMap'
  spec.authors               = { 'efremidze' => 'efremidzel@hotmail.com', 'Mikhail Vospennikov' => 'm.vospennikov@gmail.com' }
  spec.summary               = 'High performance MKMap annotation clustering.'
  spec.description           = <<-DESC
Apple provides a native and nice clustering of MKMapKit. Apple's solution is preferable if you're working with tens or thousands of annotations. You'll face performance issues if you want to work with tens or hundreds of thousands of annotations. This solution aggregates annotations in a background thread using an efficient method (QuadTree). Use demo project to compare performance and choose better solution for your task.
                               DESC
  spec.source                = { :git => 'https://github.com/vospennikov/ClusterMap.git', :tag => spec.version.to_s }
  spec.source_files          = 'Sources/ClusterMap/**/*'
  
  spec.swift_versions        = '5.7.1'
  spec.ios.deployment_target = '13.0'
  spec.osx.deployment_target = '11.0'

  spec.frameworks            = 'MapKit', 'Foundation', 'CoreLocation'
  spec.ios.frameworks        = 'UIKit'
  spec.osx.frameworks        = 'AppKit'
end
