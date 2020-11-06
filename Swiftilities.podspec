Pod::Spec.new do |s|
  s.name             = "Swiftilities"
  s.version          = "0.26.0"
  s.summary          = "A collection of useful Swift utilities."
  s.swift_versions    = ['4.2', '5.0']

  s.description      = <<-DESC
                        A collection of useful Swift utilities. All components and
                        extensions found in this library are consise enough on their own
                        so as to not warrant their own project.
                       DESC

  s.homepage         = "https://github.com/rightpoint/Swiftilities"
  s.license          = 'MIT'
  s.authors          = {
                         "Rightpoint" => "opensource@rightpoint.com",
                       }
  s.source           = { :git => "https://github.com/rightpoint/Swiftilities.git", :tag => s.version.to_s }

  s.ios.deployment_target  = '9.0'
  s.osx.deployment_target = '10.11'
  s.watchos.deployment_target = '2.2'
  s.tvos.deployment_target = '10.0'

  s.requires_arc = true

  s.default_subspec = 'All'

  s.ios.framework  = 'UIKit'
  s.tvos.framework = 'UIKit'

  # About

  s.subspec "AboutView" do |ss|
    ss.ios.source_files = "Pod/Classes/AboutView/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.ios.frameworks = ['UIKit', 'MessageUI']
  end

  # AccessibilityHelpers

  s.subspec "AccessibilityHelpers" do |ss|
    ss.source_files = "Pod/Classes/AccessibilityHelpers/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
  end

  # Acknowledgements

  s.subspec "Acknowledgements" do |ss|
    ss.dependency 'Swiftilities/LicenseFormatter'
    ss.dependency 'Swiftilities/Deselection'
    ss.dependency 'Swiftilities/Compatibility'
    ss.ios.source_files = "Pod/Classes/Acknowledgements/*.swift"
    ss.ios.deployment_target  = '9.0'
  end

  # BetterButton
  
  s.subspec "BetterButton" do |ss|
    ss.source_files = "Pod/Classes/BetterButton/*.swift"
    ss.dependency 'Swiftilities/Shapes'
    ss.dependency 'Swiftilities/ImageHelpers'
    ss.dependency 'Swiftilities/ColorHelpers'
    ss.dependency 'Swiftilities/Math'
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
  end

  # ColorHelpers

  s.subspec "ColorHelpers" do |ss|
    ss.source_files = "Pod/Classes/ColorHelpers/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
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
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
  end

  # DeviceSize

  s.subspec "DeviceSize" do |ss|
    ss.ios.source_files = "Pod/Classes/DeviceSize/*.swift"
    ss.ios.deployment_target  = '9.0'
  end

  # FormattedTextField

  s.subspec "FormattedTextField" do |ss|
    ss.source_files = "Pod/Classes/FormattedTextField/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
  end

  # Forms

  s.subspec "Forms" do |ss|
    ss.source_files = "Pod/Classes/Forms/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
  end

  # HairlineView

  s.subspec "HairlineView" do |ss|
    ss.source_files = "Pod/Classes/HairlineView/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
  end
  
  s.subspec "ImageHelpers" do |ss|
    ss.source_files = "Pod/Classes/ImageHelpers/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0' 
  end

  # Keyboard

  s.subspec "Keyboard" do |ss|
    ss.ios.source_files = "Pod/Classes/Keyboard/*.swift"
    ss.ios.deployment_target  = '9.0'
  end

  # LicenseFormatter

  s.subspec "LicenseFormatter" do |ss|
    ss.source_files = "Pod/Classes/LicenseFormatter/*.swift"
  end

  # Lifecycle

  s.subspec "Lifecycle" do |ss|
    ss.dependency 'Swiftilities/Math'
    ss.dependency 'Swiftilities/HairlineView'
    ss.ios.source_files = ["Pod/Classes/Lifecycle/**/*.swift"]
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0' 
  end

  # Logging

  s.subspec "Logging" do |ss|
    ss.source_files = "Pod/Classes/Logging/*.swift"
  end

  # Math

  s.subspec "Math" do |ss|
    ss.source_files = "Pod/Classes/Math/*.swift"
    ss.frameworks = ["CoreGraphics"]
  end

  # RootViewController

  s.subspec "RootViewController" do |ss|
    ss.ios.source_files = "Pod/Classes/RootViewController/*.swift"
    ss.ios.frameworks   = ["UIKit", "MessageUI"]
    ss.ios.deployment_target  = '9.0'
  end

  # Shapes

  s.subspec "Shapes" do |ss|
    ss.source_files = "Pod/Classes/Shapes/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
  end

  # StackViewHelpers

  s.subspec "StackViewHelpers" do |ss|
    ss.source_files = "Pod/Classes/StackViewHelpers/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
  end
  
  # TableViewHelpers

  s.subspec "TableViewHelpers" do |ss|
    ss.source_files = "Pod/Classes/TableViewHelpers/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
  end

  # TintedButton

  s.subspec "TintedButton" do |ss|
    ss.source_files = "Pod/Classes/TintedButton/*.swift"
    ss.ios.deployment_target  = '9.0'
    ss.tvos.deployment_target = '10.0'
  end

  # Views

  s.subspec "Views" do |ss|
    ss.source_files = ["Pod/Classes/Views/**/*.swift"]
    ss.ios.deployment_target  = '9.0'
  end

  # Catch All

  s.subspec "All" do |ss|
    ss.ios.dependency  'Swiftilities/AboutView'
    ss.ios.dependency  'Swiftilities/AccessibilityHelpers'
    ss.tvos.dependency 'Swiftilities/AccessibilityHelpers'
    ss.ios.dependency  'Swiftilities/Acknowledgements'
    ss.ios.dependency  'Swiftilities/BetterButton'
    ss.tvos.dependency 'Swiftilities/BetterButton'
    ss.ios.dependency  'Swiftilities/ColorHelpers'
    ss.tvos.dependency 'Swiftilities/ColorHelpers'
    ss.dependency      'Swiftilities/Compatibility'
    ss.dependency      'Swiftilities/CoreDataStack'
    ss.ios.dependency  'Swiftilities/Deselection'
    ss.tvos.dependency 'Swiftilities/Deselection'
    ss.ios.dependency  'Swiftilities/DeviceSize'
    ss.ios.dependency  'Swiftilities/FormattedTextField'
    ss.tvos.dependency 'Swiftilities/FormattedTextField'
    ss.ios.dependency  'Swiftilities/Forms'
    ss.tvos.dependency 'Swiftilities/Forms'
    ss.ios.dependency  'Swiftilities/HairlineView'
    ss.tvos.dependency 'Swiftilities/HairlineView'
    ss.ios.dependency  'Swiftilities/ImageHelpers'
    ss.tvos.dependency 'Swiftilities/ImageHelpers'
    ss.ios.dependency  'Swiftilities/Keyboard'
    ss.dependency      'Swiftilities/LicenseFormatter'
    ss.ios.dependency  'Swiftilities/Lifecycle'
    ss.tvos.dependency 'Swiftilities/Lifecycle'
    ss.dependency      'Swiftilities/Logging'
    ss.dependency      'Swiftilities/Math'
    ss.ios.dependency  'Swiftilities/RootViewController'
    ss.ios.dependency  'Swiftilities/Shapes'
    ss.tvos.dependency 'Swiftilities/Shapes'
    ss.ios.dependency  'Swiftilities/StackViewHelpers'
    ss.tvos.dependency 'Swiftilities/StackViewHelpers'
    ss.ios.dependency  'Swiftilities/TableViewHelpers'
    ss.tvos.dependency 'Swiftilities/TableViewHelpers'
    ss.ios.dependency  'Swiftilities/TintedButton'
    ss.tvos.dependency 'Swiftilities/TintedButton'
    ss.ios.dependency  'Swiftilities/Views'
  end

end
