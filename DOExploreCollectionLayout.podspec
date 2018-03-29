Pod::Spec.new do |s|
  s.name = "DOExploreCollectionLayout"
  s.version = "1.1"
  s.summary = "Netflix / Amazon Prime inspired CollectionViewLayout with inbuilt horizontal scrolling."
  s.homepage = "https://github.com/docterd/DOExploreCollectionLayout"
  s.license = { :type => "MIT" }
  s.author = { "Dennis Oberhoff" => "dennis@obrhoff.de" }
  s.source = { :git => "https://github.com/docterd/DOExploreCollectionLayout.git", :tag => "1.1"}
  s.source_files = "DOExploreCollectionLayout/*.swift"
  s.ios.deployment_target = "11.0"
  s.ios.framework  = 'UIKit'
  s.swift_version = '4.0'
end
