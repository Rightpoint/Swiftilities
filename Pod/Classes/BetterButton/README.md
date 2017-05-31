# BetterButton

BetterButton is a `UIButton` subclass that allows a wider array of button styles than offered by UIKit out of the box. It uses performant drawing to render all content in images, avoiding common pitfalls associated with custom buttons that must override various control states. 

## Installation

BetterButton is part of Swiftilities, available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Swiftilities/BetterButton"
```
## Usage

BetterButton is a subclass of `UIButton`. You simply need to use its custom initializer then you can use it as you would a normal `UIButton`:

```
let pillButton = BetterButton(
	shape: .pill, 
	style: .outlineInvert(backgroundColor: .white, foregroundColor: .green)
	)
pillButton.setTitle("Pill (Outline-Invert)", for: .normal)
```
If you need to use an image glyph, set the `iconImage` property instead of using the default `setImage:forState:` method of `UIButton`. This will take your single image and configure the button with the appropriate rendered versions for various states. 

```
button.iconImage = UIImage(...)
```
Finally, BetterButton also supports a loading state. Set the `isLoading` property to `true` and the button content will be replaced with an activity indicator. Set it back to `false` to restore the initial button style. 

```
button.isLoading = true
// Do some long-running task
button.isLoading = false
```
For more usage examples, `pod try Swiftilities` and run the sample app, then choose "Buttons" from the menu. 