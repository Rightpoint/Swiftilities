# GradientView

A UIView that contains a gradient

## Default Appearance

<details>
<summary>Screenshots</summary>

<p>
<img src="HairlineTableCells.png" width="200">
</p>

</details>

### Quick Start

A simple 1 pixel, horizontal, darkGray hairline:
```swift
let hairline = HairlineView()
cell.contentView.addSubview(hairline)
hairline.translatesAutoresizingMaskIntoConstraints = false
hairline.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor).isActive = true
hairline.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true

```

## Custom Appearance

<details>
<summary>Screenshots</summary>

<p>
<img src="HairlineButtonDivide.png" width="200">
</p>

</details>

To customize, add init parameters for axis, thickness and color.

```swift
let hairline = HairlineView(axis: .vertical, thickness: 3.0, hairlineColor: .red)
view.addSubview(hairline)
hairline.translatesAutoresizingMaskIntoConstraints = false
hairline.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
hairline.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
hairline.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 20).isActive = true
```
