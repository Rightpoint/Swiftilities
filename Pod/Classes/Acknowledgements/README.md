# Acknowledgements

An all-in-one solution for adding an acknowledgement section to your app. Includes all pod licenses from the [Cocoapods generated plist](https://github.com/CocoaPods/CocoaPods/wiki/Acknowledgements).

## Screenshots

### Default

<p>
<img src="AcknowledgementsListViewController.png" width="200">
<img src="AcknowledgementViewController1.png" width="200">
<img src="AcknowledgementViewController2.png" width="200">
</p>

### Custom

<p>
<img src="CustomAcknowledgementsListViewController.png" width="200">
<img src="CustomAcknowledgementViewController1.png" width="200">
<img src="CustomAcknowledgementViewController2.png" width="200">
</p>

## How To

### Default

To use the existing `AcknowledgementsListViewController` as-is, you'll want to do these 4 steps:

1. Add `post_install` hook to your `Podfile` to copy the generated `plist`.
2. Create an instance of `AcknowledgementsListViewModel`. Requires a `try` to catch any `throw`.
3. Create an instance of `AcknowledgementsListViewController` using your view model.
4. Push your view controller onto your existing  `UINavigationController` to take advantage of the built-in back button.

### Custom

#### AcknowledgementsListViewController

To customize, just subclass it. Please note that it is already subclassing `UITableViewController` so you may need to override table view methods to further customize the look and feel.

| Property | Type | Notes |
|----------|------|-------|
| childViewControllerClass | AcknowledgementViewController.Type | Be sure to set this if you are using a custom `AcknowledgementViewController` for the license view. |
| viewModel | AcknowledgementsListViewModel | Best to use as-is. |
| licenseFormatter | (String) -> NSAttributedString | Closure for formatting the text |
| licenseViewBackgroundColor | UIColor | Set the background color for the license view. |
| cellBackgroundColor | UIColor | Set the background color for the list view. |

#### AcknowledgementViewController

There isn't that much benefit to subclassing this. Just use the parent view controller properties `licenseFormatter` and `licenseViewBackgroundColor` instead.

## Code Samples

### Podfile

```ruby
post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-<project-name>/Pods-<project-name>.plist', '<project-name>/Acknowledgements.plist', :remove_destination => true)
end
```
This `post_install` hook copies the generated `plist` into your project root folder. _Rememeber to replace `<project-name>` with your project's name_

### Default

```swift
do {
  let viewModel = try AcknowledgementsListViewModel()
  let viewController = AcknowledgementsListViewController(viewModel: viewModel)
  navigationController?.pushViewController(viewController, animated: true)  
catch {
  print(error.localizedDescription)
}
```

### Custom

#### AcknowledgementsListViewController

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

_Screenshots courtesy of [AcknowledgementSample](https://github.com/pauluhn/AcknowledgementSample)_
