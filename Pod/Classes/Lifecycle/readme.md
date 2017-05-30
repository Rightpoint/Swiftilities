# View Controller Lifecycle Behaviors

This is a colleciton of handy [View Controller Lifecycle Behaviors](http://irace.me/lifecycle-behaviors), useful for formalizing reusable bits of common lifecycle-dependent functionality. 

### Usage

Behaviors are implmented by consuming `ViewController`s simply by leveraging the category method `addBehaviors(_ behaviors: [ViewControllerLifecycleBehavior]` in `viewDidLoad`: 
```
override func viewDidLoad() {
    super.viewDidLoad()
    let behavior1 = MyBehavior()
    let behavior2 = AnotherBehavior()
    addBehaviors([behavior1, behavior2])
}
```

### Default Behaviors

Default behaviors are behaviors that are automatically injected into all view controllers using method swizzling. This may be convenient for functionality akin to analytics screen tagging, for instance. Default behaviors are injected using:
```
let behavior = MyBehavior()
DefaultBehaviors(behaviors: [behavior]).inject()
```

# Included Behaviors

- [Nav Bar Hairline Fade](https://github.com/Raizlabs/Swiftilities/tree/feature/heyltsjay/behaviors/Pod/Classes/Lifecycle/Behaviors/Nav-Bar-Hairline-Fade)
- [Nav Bar Title Transition](https://github.com/Raizlabs/Swiftilities/tree/feature/heyltsjay/behaviors/Pod/Classes/Lifecycle/Behaviors/Nav-Bar-Title-Transition)
