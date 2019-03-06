# PlaceholderTextView

A UITextView that can show placeholder text when empty

## Default Appearance

<details>
<summary>Screenshots</summary>

<img src="PlaceholderTextSimple.png" width="200">

</details>

### Quick Start

A simple TextView with placeholder text:
```swift
let aTextView = PlaceholderTextView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
aTextView.placeholder = "Type Here"
view.addSubview(aTextView)
aTextView.translatesAutoresizingMaskIntoConstraints = false
aTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
aTextView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
aTextView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
aTextView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
```
A text color can be assigned to `.placeholderTextColor`, or fully styled text can be assigned to the `.attributedPlaceholder` property.

# ExpandingTextView

A PlaceholderTextView that resizes height to fit text entered

## Default Appearance

<details>
<summary>Screenshots</summary>

<img src="TailorTextView.png" width="200">

</details>

### Quick Start

A simple TextView with placeholder text:
```swift
let expandingTextView = ExpandingTextView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
expandingTextView.backgroundColor = .red
expandingTextView.textColor = .white
expandingTextView.font = .systemFont(ofSize: 18)
view.addSubview(expandingTextView)
expandingTextView.translatesAutoresizingMaskIntoConstraints = false
expandingTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
expandingTextView.topAnchor.constraint(equalTo: aTextView.bottomAnchor, constant: 20).isActive = true
expandingTextView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
```
