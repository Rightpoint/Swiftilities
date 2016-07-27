Pod::Spec.new do |s|
  s.name             = "Swiftilities"
  s.version          = "0.2.0"
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

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.default_subspec = 'All'

  # Logging

  s.subspec "Logging" do |ss|
    ss.source_files = "Pod/Classes/Logging/*.swift"
    ss.frameworks   = "Foundation"
  end

  # RootViewController

  s.subspec "RootViewController" do |ss|
    ss.source_files = "Pod/Classes/RootViewController/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # Keyboard

  s.subspec "Keyboard" do |ss|
    ss.source_files = "Pod/Classes/Keyboard/*.swift"
    ss.frameworks   = ["UIKit"]
  end
  
  # Math
  
  s.subspec "Math" do |ss|
    ss.source_files = "Pod/Classes/Math/*.swift"
  end
  
  # Deselection

  s.subspec "Deselection" do |ss|
    ss.source_files = "Pod/Classes/Deselection/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # FieldValidation

  s.subspec "Deselection" do |ss|
    ss.source_files = "Pod/Classes/FieldValidation/*.swift"
    ss.frameworks   = "Foundation"
  end

  # Catch All

  s.subspec "All" do |ss|
    ss.dependency 'Swiftilities/Logging'
    ss.dependency 'Swiftilities/RootViewController'
    ss.dependency 'Swiftilities/Keyboard'
    ss.dependency 'Swiftilities/Math'
    ss.dependency 'Swiftilities/Deselection'
    ss.dependency 'Swiftilities/FieldValidation'
  end

end
