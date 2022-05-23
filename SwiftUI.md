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
There are cases where you may need to read the size proposed to a view instead of the final size (for example to do custom proportional layout). In these cases, first consider if a combination of stacks, spacers and frames can be used instead.

If you absolutely need the `GeometryReader`, expanding to fill the dimension you want to measure is unavoidable.

#### Example 1
Let's say you want to ensure a view's width is always 0.65x of the proposed width and the height is self sized.

Wrap a `GeometryReader` in a frame, constraining the dimension you don't care about.
```swift
GeometryReader { proxy in 
    ...
}
.frame(height: 0) // The GeometryReader won't fill all proposed height
```
Note that if you place your content inside of this `GeometryReader`, as far as the `GeometryReader`'s parent is concerned, the height will always be 0. This can cause layout issues because the inner view will render out of bounds.
```swift
GeometryReader { proxy in 
    Rectangle()
        // The Rectangle will take 20pts, but this height will be ignored by the layout system.
        .frame(width: proxy.size.width * 0.65, height: 20) 
}
.frame(height: 0)
```
This is caused by the `.frame` we used to constrain the `GeometryReader` to 0 height. To get the benefits of a height-constrained `GeometryReader` and a correctly sized content view, you can place the `GeometryReader` in a `ZStack` and bubble up its measurement. Combined with the previous method, this means:
- you measure the proposed width
- you avoid taking up all of the proposed height
- the height proposed to the content view is untouched
- the height returned by the content view is untouched

Note that a `ZStack` will match the size of its largest child in each dimension, so it will still fill all width due to the contained `GeometryReader`.
```swift
// The Rectangle will have a width proportional to the proposed width without taking up all the proposed height.
// This is a two pass layout
@State var availableWidth: CGFloat = 0

ZStack {
    GeometryReader { proxy in 
        Color.clear.preference(key: WidthPreferenceKey.self,
                               value: proxy.size.width)
    }
    .frame(height: 0)
    .onPreferenceChange(WidthPreferenceKey.self) { newWidth in
        availableWidth = newWidth
    }

    Rectangle()
        .frame(width: availableWidth * 0.65, height: 20)
}
```
#### Example 2
If your inner view is flexible and wants to span the proposed height anyways, the `ZStack` trick is unnecessary.

You will find that the `GeometryReader` aligns the smaller inner view based on undocumented logic (top-leading as of 5/20/22). To make the alignment explicit and customizable, wrap your view in essentially a passthrough frame with an explicit alignment parameter.
```swift
// This view will span the proposed width and height
// The Rectangle will span the proposed height and take 0.65x of the proposed width.
// It will be centered in the proposed width.
GeometryReader { proxy in
    Rectangle() 
        .frame(width: proxy.size.width * 0.65)
        // This frame has the same sizing behavior as the GeometryReader, but allows you to change the alignment.
        .frame(width: proxy.size.width,
               height: proxy.size.height,
               alignment: .center)
}
```


## Multiline text
### Convention
Use native `Text` instead of a `UIViewRepresentable` containing a `UILabel` whenever possible.

### Rationale
SwiftUI-UIKit layout bridging is heavily dependent on `intrinsicContentSize`. `UILabel` calculates this size in a special way, taking its `preferredMaxLayoutWidth` into consideration to determine how many lines the label will need. In an Auto Layout environment this property is set automatically, but it won't be set by SwiftUI. This results in incorrect sizing for multiline `UILabels` when used in SwiftUI. The native `Text` doesn't suffer from these problems and takes the proposed width into consideration during a layout pass.

### Exceptions
There are cases where the use of `UILabel` is unavoidable, for example attributed text, which has only been supported in SwiftUI since iOS 15. In these cases you need to ensure `preferredMaxLayoutWidth` is set to the correct value. There are multiple methods of doing this:
- in static width cases, you can directly set the property in your representable
- if width is dynamic, you'll need to pass it down to your representable from the SwiftUI context
    - if the width is manually computed, you can pass it as a `@Binding`, making sure to update the `UILabel` in the representable's `updateUIView` function.
    - if the width follows from a SwiftUI layout pass, you might need to use a `GeometryReader` to measure the relevant views. See the `GeometryReader` sections for details.