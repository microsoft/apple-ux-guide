# Layout

## Auto Layout vs. Frame-Based Layout

### Convention
Using Auto Layout with declarative constraints is usually preferred to frame-based layout (explicitly setting properties like `frame` and `autoresizingMask`).

### Rationale
Using [AutoLayout](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/index.html) instead of frame-based layout will help your code automatically adapt to different configurations and OS capabilities like:
- Different window sizes on macOS and iPadOS
- Different iOS devices, including adapting to new devices without needing code updates
- Internationalizations with right-to-left layouts

### Examples

```swift
// Good: Auto Layout will properly mirror the layout for right-to-left languages
NSLayoutConstraint.activate([subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor,
                                                             constant: leadingPadding)])
```

```swift
// Bad: Frame-based layout requires special computation for right-to-left languages
let superviewSize = superview.bounds.size
let subviewOriginX = traitCollection.layoutDirection == .rightToLeft
                    ? superviewSize.width - leadingPadding - superviewSize.width 
                    : leadingPadding
subview.frame = CGRect(x: subviewOriginX,
                        y: 0.0,
                        width: superviewSize.width,
                        height: superviewSize.height)
```

### Exceptions
Auto Layout performance is sufficient for most experiences, even those with significant complexity. But for some layouts with an extremely large number of constraints active or complex layouts where the constraints are adjusted often based on current layout (multi-pass layouts), using frame-based layout may yield performance gains. 

Examples where you might want to consider manual layout:
- Calling `systemLayoutSizeFitting(_:)'` or `fittingSize` repeatedly to determine a layout that fits.
- Doing non-trivial frame/constraint/visibility adjustment in heavily hit layout override points like `layout`/`layoutSubviews`/`viewDidLayoutSubviews`/etc.
    - On iOS, if the adjustments are only in `viewWillTransition(to:with:)` and don't need to measure repeatedly using `systemLayoutSizeFitting(_:)'`, there shouldn't be much performance impact so Auto Layout is likely the better choice for all the benefits above.


## Compose Hierarchies with NSStackViews/UIStackViews

## Use Layout Anchor Constraints