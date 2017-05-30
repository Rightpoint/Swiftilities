# NavTitleTransitionBehavior.swift

This behavior manages the interactivity between a title, anywhere in a `UIScrollView` and the title of a `UINavigationBar`. The behavior is defined so as the title subview scrolls under the title, the Nav Bar's title will translate into place. 

This behavior is accomplished by leveraging the `UINavigationBar().titleVerticalPositionAdjustment`, allowing the title to play nicely with other `UINavigationItem`s, (since it is using the normal `navigationItem.title`.)

## Usage
```
override func viewDidLoad() {
  super.viewDidLoad()
  navigationItem.setTitle("My Title")
  let behavior = NavTitleTransitionBehavior(scrollView: scrollSubview, titleView: titleLabelSubview)
  addBehaviors([behavior])
}
```

## Example

![](https://raw.githubusercontent.com/Raizlabs/Swiftilities/feature/heyltsjay/behaviors/Pod/Classes/Lifecycle/Behaviors/Nav-Bar-Title-Transition/example.gif)
