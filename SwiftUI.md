# SwiftUI

## GeometryReader

### Convention
Avoid using [`GeometryReaders`](https://developer.apple.com/documentation/swiftui/geometryreader) in your main view tree. To measure views, place `GeometryReaders` inside of a `.background` or `.overlay` and communicate the size up through a `Preference` or other methods.

### Rationale
`GeometryReaders` always fill all of their proposed size, essentially overriding the layout behavior of the views they wrap. They also override the children's ideal size.

Usage of `.background` or `.overlay` is recommended because the content of these modifiers doesn't affect the layout of the parent view, so this limits the GR's impact while still allowing you to measure the parent view final size (note this can be different from the proposed size).

### Example
```swift
// Good: Measure final size of Text without affecting its layout
Text("Sample text")
    .background { // Size proposed to this will be the final size of the Text view
        GeometryReader { proxy in
            Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
        }
    }
    .onPreferenceChange(SizePreferenceKey.self) { size in
        // Do things with the measured size
    }

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
```

```swift
// Bad: We measure size proposed to the Text view, but the GeometryReader won't fit the text. 
GeometryReader { proxy in 
    Text("Sample text")
}
```

### Exceptions
There are cases where you may need to read the size proposed to a view, instead of the final size (for example to do custom proportional layout). In these cases, first consider if a combination of stacks, spacers and frames can be used instead.

If you absolutely need the `GeometryReader`, expanding to fill the dimension you want to measure is unavoidable. You can still limit the impact using a few of these methods:
- Wrap the `GeometryReader` in a frame, constraining the dimension you don't care about.
- Place the geometry reader in a `ZStack`. Combined with the previous method, this can help you measure without affecting the layout of other views in the `ZStack`. Note this will still cause the `ZStack` to fill the dimension you're measuring.

## Multiline `UILabel` representables
### Convention
Use native `Text` instead of `UILabel` representable whenever possible.

### Rationale
SwiftUI-UIKit layout bridging is heavily dependent on `intrinsicContentSize`. `UILabel` calculates this size in a special way, taking its `preferredMaxLayoutWidth` into consideration to determine how many lines the label will need. In an Auto Layout environment this property is set automatically, but it won't be set by SwiftUI. This results in incorrect sizing for multiline `UILabels` when used in SwiftUI. The native `Text` doesn't suffer from these problems and takes the proposed width into consideration during a layout pass.

### Exceptions
There are cases where the use of `UILabel` is unavoidable, for example attributed text, which has only been supported in SwiftUI since iOS 15. In these cases you need to ensure `preferredMaxLayoutWidth` is set to the correct value. There are multiple methods of doing this:
- in static width cases, you can directly set the property in your representable
- if width is dynamic, you'll need to pass it down to your representable from the SwiftUI context
    - if the width is manually computed, you can pass it as a `@Binding`, making sure to update the `UILabel` in the representable's `updateUIView` function.
    - if the width follows from a SwiftUI layout pass, you might need to use a `GeometryReader` to measure the relevant views. See the `GeometryReader` sections for details.