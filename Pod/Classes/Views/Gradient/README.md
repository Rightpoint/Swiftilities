# GradientView

A UIView that contains a gradient

## Default Appearance

<details>
<summary>Screenshots</summary>

<img src="GradioentSimple.png" width="200">

</details>

### Quick Start

A linear gradient transitioning from white to blue:
```swift
let gradientView = GradientView(direction: .leftToRight, colors: [.white, .blue])
cell.contentView.addSubview(gradientView)
gradientView.translatesAutoresizingMaskIntoConstraints = false
gradientView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
gradientView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true

```

## Custom Appearance

<details>
<summary>Screenshots</summary>

<img src="GradientCustom.png" width="200">

</details>

Direction can be changed or a custom direction can be defined with Floats from 0.0 to 1.0 describing the start and end position within the view. Locations can be provided to define how the color array should be spaced; if no locations are provided, the colors will be evenly spaced between the start and end positions.

```swift
let gradients = [
    GradientView(direction: .leftToRight, colors: [.red, .white, .blue]),
    GradientView(direction: .topToBottom, colors: [.green, .black, .orange]),
    // Gradient starting in top left corner (0,0) and ending in bottom right corner (1,1):
    GradientView(
        direction: .custom(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 1, y: 1)),
        colors: [.blue, .orange, .purple]
    ),
    // Gradient confined to bottom 10%:
    GradientView(direction: .topToBottom, colors: [.purple, .black], locations: [0.9, 1.0]),
]
gradients.forEach { view in
    stackView.addArrangedSubview(view)
    view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    view.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 6.0
}
```
