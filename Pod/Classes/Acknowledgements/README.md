# Acknowledgements

An all-in-one solution for adding an acknowledgement section to your app. Includes all pod licenses from the [Cocoapods generated plist](https://github.com/CocoaPods/CocoaPods/wiki/Acknowledgements).

## Default Appearance

<details>
<summary>Screenshots</summary>

<p>
<img src="AcknowledgementsListViewController.png" width="200">
<img src="AcknowledgementViewController.png" width="200">
</p>

</details>

### Quick Start

To use `AcknowledgementsListViewController` as-is, follow these 4 easy steps:

1. Add `post_install` hook to the end of your `Podfile` to copy the generated `plist` into your project root folder. _Rememeber to replace `<project-name>` with your project's name_
```ruby
post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-<project-name>/Pods-<project-name>.plist', '<project-name>/Acknowledgements.plist', :remove_destination => true)
end
```

2. Create an instance of `AcknowledgementsListViewModel`. Requires a `try` to catch any `throw`.

3. Create an instance of `AcknowledgementsListViewController` using your view model.

4. Push your view controller onto your existing  `UINavigationController` to take advantage of the built-in back button.
```swift
do {
    let viewModel = try AcknowledgementsListViewModel() // STEP 2
    let viewController = AcknowledgementsListViewController(viewModel: viewModel) // STEP 3
    navigationController?.pushViewController(viewController, animated: true) // STEP 4
catch {
    print(error.localizedDescription)
}
```

## Custom Appearance

<details>
<summary>Screenshots</summary>

<p>
<img src="CustomAcknowledgementsListViewController.png" width="200">
<img src="CustomAcknowledgementViewController.png" width="200">
</p>

</details>

### AcknowledgementsListViewController

To customize, just subclass it. Please note that it is already subclassing `UITableViewController` so you may need to override table view methods to further customize the look and feel.

| Property | Type | Notes |
|----------|------|-------|
| childViewControllerClass | AcknowledgementViewController.Type | Be sure to set this if you are using a custom `AcknowledgementViewController` for the license view. |
| viewModel | AcknowledgementsListViewModel | Best to use as-is. |
| licenseFormatter | (String) -> NSAttributedString | Closure for formatting the text |
| licenseViewBackgroundColor | UIColor | Set the background color for the license view. |
| cellBackgroundColor | UIColor | Set the background color for the list view. |

```swift
class CustomAcknowledgementsListViewController: AcknowledgementsListViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = super.tableView(tableView, cellForRowAt: indexPath)
      cell.textLabel?.textColor = .random
      return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      defer { super.tableView(tableView, didSelectRowAt: indexPath) }
      guard let cell = tableView.cellForRow(at: indexPath) else { return }
      licenseViewBackgroundColor = .random
  }
}
```

```swift
do {
  let viewModel = try AcknowledgementsListViewModel()
  let viewController = CustomAcknowledgementsListViewController(viewModel: viewModel)
  navigationController?.pushViewController(viewController, animated: true)  
catch {
  print(error.localizedDescription)
}
```

### AcknowledgementViewController

There isn't that much benefit to subclassing this. Just use the parent view controller properties `licenseFormatter` and `licenseViewBackgroundColor` instead.

_Screenshots courtesy of [AcknowledgementSample](https://github.com/pauluhn/AcknowledgementSample)_
