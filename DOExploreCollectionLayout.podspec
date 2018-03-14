Pod::Spec.new do |s|
  s.name = "DOExploreCollectionLayout"
  s.version = "1.0"
  s.summary = "CollectionViewLayout inspired by Netflix"
  s.homepage = "https://github.com/docterd/DOExploreCollectionLayout"
  s.license = { :type => "MIT" }
  s.author = { "Dennis Oberhoff" => "dennis@obrhoff.de" }
  s.source = { :git => "https://github.com/docterd/DOExploreCollectionLayout.git", :tag => "1.0"}
  s.source_files = "Classes/*.swift"
  s.ios.deployment_target = "11.0"
  s.ios.framework  = 'UIKit'
  s.swift_version = '4.0'
end
