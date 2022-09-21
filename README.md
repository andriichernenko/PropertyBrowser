
# PropertyBrowser

### Target environment
Xcode 14.0, iOS 14.

### General information
- The architecture of the app MVVM.
- The views are created mostly using SwiftUI, except the top-level container, which uses UIKit (SwiftUI doesn not support split views on iOS 14).
- The app should work both on iPhone and iPad.

### Potential improvements
- Load images in the list more efficiently (currently, loading images seems to be causing dropped frames during scrolling).
- Consider image resizing and caching.
- Implement asynchronous tests for view models properly (without relying on delays).
- Implement snapshot tests for views.
- Implement end-to-end tests.
- Test the app with screen reader.
- Localize user-facing strings.
- Consider using a formatter for area units.
- Support dark mode.
- Fine-tune split view configuration to make sure there are no quirks on orientation/size class changes.
