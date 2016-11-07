# Swiftilities

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Adding A New Subspec
1. Create a new directory within the Classes folder (or Assets, if required)
2. Add the new files to the directory created in step 1
3. Add a subspec to the Swiftilities.podspec following this pattern:
    ```ruby
    # <Your Subsepc Name>
    
    s.subspec "<Your Subsepc Name>" do |ss|
    	ss.source_files = "Pod/Classes/<Your Subsepc Name>/*.swift"
    	ss.frameworks   = ["<Any Required Modules>"]
    end 
    ```
4. Apend an `ss.dependency` to `s.subsec` within the podspec file with the following format: 

    ```ruby
    ss.dependency 'Swiftilities/<Your Subsepc Name>'
    ```

5. Navigate to the example project directory and run `bundle exec pod update`

## Requirements

## Installation

Swiftilities is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Swiftilities"
```

## Author

Nicholas Bonatsakis, nick.bonatsakis@raizlabs.com

## Code of Conduct
Please read our contribution [Code of Conduct](./CONTRIBUTING.md).

## License

Swiftilities is available under the MIT license. See the LICENSE file for more info.
