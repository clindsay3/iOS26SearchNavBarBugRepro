# iOS 26.4 `UISearchController` navigation bar regression repro

## Summary

On **iOS 26.4 (Simulator)**, tapping the search field can cause the navigation bar area to turn white/disappear and the search field to lose keyboard focus.

This project also reproduces with an automated UI test:

- **iOS 26.2**: UITest passes
- **iOS 26.4**: UITest fails (search field disappears after tap)

## Key ingredients in the repro

- `UISplitViewController` + `UITabBarController`
- Migration of a `UINavigationController` stack during `splitViewControllerDidCollapse`
- Moving the *same* `UISearchController` instance from one `navigationItem.searchController` to another during collapse
- `UINavigationController` + `UITableViewController`
- `navigationItem.searchController`
- `navigationItem.preferredSearchBarPlacement = .stacked`
- `searchController.hidesNavigationBarDuringPresentation = true`

## Steps to reproduce

1. Open `SearchNavBarDisappearRepro.xcodeproj` in Xcode.
2. Run on an iOS **26.4** simulator.
3. Rotate to landscape and back to portrait (forces the collapse path).
4. Tap the search field.

## Expected

- The search field remains visible and focused.
- The keyboard appears.
- The Cancel button appears.

## Actual (iOS 26.4)

- The navigation bar area becomes blank/white.
- The search field disappears and loses keyboard focus.

## Automated check

Run the UITest `SearchNavBarDisappearReproUITests/testTapSearchFieldKeepsKeyboardFocus`.

Example:

```sh
cd /path/to/iOS26SearchNavBarBugRepro

# iOS 26.2: passes
xcodebuild test \
  -project SearchNavBarDisappearRepro.xcodeproj \
  -scheme SearchNavBarDisappearRepro \
  -destination 'platform=iOS Simulator,OS=26.2,name=iPhone 16' \
  -only-testing:SearchNavBarDisappearReproUITests/SearchNavBarDisappearReproUITests/testTapSearchFieldKeepsKeyboardFocus

# iOS 26.4: fails
xcodebuild test \
  -project SearchNavBarDisappearRepro.xcodeproj \
  -scheme SearchNavBarDisappearRepro \
  -destination 'platform=iOS Simulator,OS=26.4,name=iPhone 16' \
  -only-testing:SearchNavBarDisappearReproUITests/SearchNavBarDisappearReproUITests/testTapSearchFieldKeepsKeyboardFocus
```
