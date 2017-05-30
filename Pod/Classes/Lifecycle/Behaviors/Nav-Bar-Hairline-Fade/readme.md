# NavBarHarilineFadeBehavior

This behavior adds a hairline to the bottom of a `UINavigationBar` and animates its `alpha` alongside a `UIScrollView`'s `contentOffset`

## Usage
```swift
override func viewDidLoad() {
  super.viewDidLoad()
  
  let behavior = NavBarHarilineFadeBehavior(scrollView: scrollView)
  
  //optional configuration  
  behavior.contentOffsetFadeRange = 0...100
  behavior.hairlineColor = .lightGray
  behavior.hairlineThickenss = 1
  
  addBehaviors([behavior])
}
```

## Example
![](https://github.com/Raizlabs/Swiftilities/blob/feature/heyltsjay/behaviors/Pod/Classes/Lifecycle/Behaviors/Nav-Bar-Hairline-Fade/example.gif)
