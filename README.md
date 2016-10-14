# Swiftilities

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Adding A New Subspec
1. Create a new directory within the Classes folder (or Assets, if required)
2. Add the new files to the directory created in step 1
3. Add a subspec to the Swiftilities.podspec following this pattern:
    ```ruby
    # <Your Subsepc Name>

    s.subspec "<Your Subspec Name>" do |ss|
    	ss.source_files = "Pod/Classes/<Your Subspec Name>/*.swift"
    	ss.frameworks   = ["<Any Required Modules>"]
    end
    ```
4. Apend an `ss.dependency` to `s.subsec` within the podspec file with the following format:

    ```ruby
    ss.dependency 'Swiftilities/<Your Subspec Name>'
    ```

5. Navigate to the example project directory and run `pod update`

## Requirements

## Installation

Swiftilities is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
pod "Swiftilities"

## Swiftilities by default uses 3.0, if you need to use a lower version of swift
## Add this to the bottom of your Podfile
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
  end
end
```

## Author

Nicholas Bonatsakis, nick.bonatsakis@raizlabs.com

## Code of Conduct
Please read our contribution [Code of Conduct](./CONTRIBUTING.md).

## License

Swiftilities is available under the MIT license. See the LICENSE file for more info.
