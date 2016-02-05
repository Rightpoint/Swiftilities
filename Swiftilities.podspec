Pod::Spec.new do |s|
  s.name             = "Swiftilities"
  s.version          = "0.1.0"
  s.summary          = "A collection of useful Swift utilities."

  s.description      = <<-DESC
                        A collection of useful Swift utilities. All components and
                        extensions found in this library are consise enough on their own
                        so as to not warrant their own project.
                       DESC

  s.homepage         = "https://github.com/raizlabs/Swiftilities"
  s.license          = 'MIT'
  s.author           = { "Nicholas Bonatsakis" => "nick.bonatsakis@raizlabs.com" }
  s.source           = { :git => "https://github.com/raizlabs/Swiftilities.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Swiftilities' => ['Pod/Assets/*.png']
  }
  s.default_subspec = 'All'

  # Logging

  s.subspec "Logging" do |ss|
    ss.source_files = "Pod/Logging"
    ss.frameworks   = "Foundation"
  end

  # Catch All

  s.subspec "All" do |ss|
    ss.dependency 'Swiftilities/Logging'
  end

end
