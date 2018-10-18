Pod::Spec.new do |s|
  s.name             = "Swiftilities"
  s.version          = "0.19.0"
  s.summary          = "A collection of useful Swift utilities."
  s.swift_version    = '4.2'

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

  # About

  s.subspec "AboutView" do |ss|
    ss.source_files = "Pod/Classes/AboutView/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # AccessibilityHelpers

  s.subspec "AccessibilityHelpers" do |ss|
    ss.source_files = "Pod/Classes/AccessibilityHelpers/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # Acknowledgements

  s.subspec "Acknowledgements" do |ss|
    ss.dependency 'Swiftilities/LicenseFormatter'
    ss.dependency 'Swiftilities/Deselection'
    ss.dependency 'Swiftilities/Compatibility'
    ss.source_files = "Pod/Classes/Acknowledgements/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # BetterButton
  
  s.subspec "BetterButton" do |ss|
    ss.source_files = "Pod/Classes/BetterButton/*.swift"
    ss.dependency 'Swiftilities/Shapes'
    ss.dependency 'Swiftilities/ImageHelpers'
    ss.dependency 'Swiftilities/ColorHelpers'
    ss.dependency 'Swiftilities/Math'
    ss.frameworks   = ["UIKit"]
  end

  # ColorHelpers

  s.subspec "ColorHelpers" do |ss|
    ss.source_files = "Pod/Classes/ColorHelpers/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # Compatibility

  s.subspec "Compatibility" do |ss|
    ss.source_files = "Pod/Classes/Compatibility/*.swift"
  end

  # CoreDataStack

  s.subspec "CoreDataStack" do |ss|
    ss.source_files = "Pod/Classes/CoreDataStack/*.swift"
    ss.frameworks   = ["Foundation", "CoreData"]
  end

  # Deselection

  s.subspec "Deselection" do |ss|
    ss.source_files = "Pod/Classes/Deselection/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # DeviceSize

  s.subspec "DeviceSize" do |ss|
    ss.source_files = "Pod/Classes/DeviceSize/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # FormattedTextField

  s.subspec "FormattedTextField" do |ss|
    ss.source_files = "Pod/Classes/FormattedTextField/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # Forms

  s.subspec "Forms" do |ss|
    ss.source_files = "Pod/Classes/Forms/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # HairlineView

  s.subspec "HairlineView" do |ss|
    ss.source_files = "Pod/Classes/HairlineView/*.swift"
    ss.frameworks   = ["UIKit"]
  end
  
  s.subspec "ImageHelpers" do |ss|
    ss.source_files = "Pod/Classes/ImageHelpers/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # Keyboard

  s.subspec "Keyboard" do |ss|
    ss.source_files = "Pod/Classes/Keyboard/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # LicenseFormatter

  s.subspec "LicenseFormatter" do |ss|
    ss.source_files = "Pod/Classes/LicenseFormatter/*.swift"
    ss.frameworks   = "Foundation"
  end

  # Lifecycle

  s.subspec "Lifecycle" do |ss|
    ss.dependency 'Swiftilities/Math'
    ss.dependency 'Swiftilities/HairlineView'
    ss.source_files = ["Pod/Classes/Lifecycle/**/*.swift"]
    ss.frameworks   = ["UIKit"]
  end

  # Logging

  s.subspec "Logging" do |ss|
    ss.source_files = "Pod/Classes/Logging/*.swift"
    ss.frameworks   = "Foundation"
  end

  # Math

  s.subspec "Math" do |ss|
    ss.ios.deployment_target = '9.0'
    ss.ios.source_files = "Pod/Classes/Math/*.swift"

    ss.tvos.deployment_target = '9.0'
    ss.tvos.source_files = "Pod/Classes/Math/*.swift"

    ss.osx.deployment_target = '10.11'
    ss.osx.source_files = "Pod/Classes/Math/*.swift"

    ss.watchos.deployment_target = '2.2'
    ss.watchos.source_files = "Pod/Classes/Math/*.swift"
  end

  # RootViewController

  s.subspec "RootViewController" do |ss|
    ss.source_files = "Pod/Classes/RootViewController/*.swift"
    ss.frameworks   = ["UIKit", "MessageUI"]
  end

  # Shapes

  s.subspec "Shapes" do |ss|
    ss.source_files = "Pod/Classes/Shapes/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # StackViewHelpers

  s.subspec "StackViewHelpers" do |ss|
    ss.source_files = "Pod/Classes/StackViewHelpers/*.swift"
    ss.frameworks   = ["UIKit"]
  end
  
  # TableViewHelpers

  s.subspec "TableViewHelpers" do |ss|
    ss.source_files = "Pod/Classes/TableViewHelpers/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # TintedButton

  s.subspec "TintedButton" do |ss|
    ss.source_files = "Pod/Classes/TintedButton/*.swift"
    ss.frameworks   = ["UIKit"]
  end

  # Views

  s.subspec "Views" do |ss|
    ss.source_files = ["Pod/Classes/Views/**/*.swift"]
    ss.frameworks   = ["UIKit"]
  end

  # Catch All

  s.subspec "All" do |ss|
    ss.dependency 'Swiftilities/AboutView'
    ss.dependency 'Swiftilities/AccessibilityHelpers'
    ss.dependency 'Swiftilities/Acknowledgements'
    ss.dependency 'Swiftilities/BetterButton'
    ss.dependency 'Swiftilities/ColorHelpers'
    ss.dependency 'Swiftilities/Compatibility'
    ss.dependency 'Swiftilities/CoreDataStack'
    ss.dependency 'Swiftilities/Deselection'
    ss.dependency 'Swiftilities/DeviceSize'
    ss.dependency 'Swiftilities/FormattedTextField'
    ss.dependency 'Swiftilities/Forms'
    ss.dependency 'Swiftilities/HairlineView'
    ss.dependency 'Swiftilities/ImageHelpers'
    ss.dependency 'Swiftilities/Keyboard'
    ss.dependency 'Swiftilities/LicenseFormatter'
    ss.dependency 'Swiftilities/Lifecycle'
    ss.dependency 'Swiftilities/Logging'
    ss.dependency 'Swiftilities/Math'
    ss.dependency 'Swiftilities/RootViewController'
    ss.dependency 'Swiftilities/Shapes'
    ss.dependency 'Swiftilities/StackViewHelpers'
    ss.dependency 'Swiftilities/TableViewHelpers'
    ss.dependency 'Swiftilities/TintedButton'
    ss.dependency 'Swiftilities/Views'
  end

end
