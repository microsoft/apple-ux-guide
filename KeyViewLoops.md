# Key View Loops

### Convention
It is recommended to let the window automatically calculate your key view loop for you. There are very few cases in which the automatically calculated key view loop is not sufficient.

### Rationale
Allowing the window to automatically calculate the key view loop (by setting `window.autoRecalculatesKeyViewLoop = true`), you can:
- Better conform to the user's expectation of the key view loop laid out in geometric order (left to right, top to bottom for the english locale at the time of writing)
- Protect against future OS updates where Apple may change the behavior of the key-view loop.
- Save yourself a lot of hassle of manually managing a key view loop

One thing to note: setting `autoRecalculatesKeyViewLoop` to `true` means that any NSView whose `nextKeyView` property you have manually set will be ignored. This is seemingly because AppKit will constantly recalculate the key view loop every time a view is added or the user tabs to a new view, stamping over any customizations to the key view loop done by  the developer.

Manually managing your own key-view loop (by setting `window.autoRecalculatesKeyViewLoop = false`) has a few major downsides:
- Doing so means you will have no key view loop except for whichever views you have manually set the `nextKeyView` property of in your project.
- Any call to `window.recalculateKeyViewLoop()` will stamp over your customizations, as we have already described.

### Alternatives
Rather than modifying the key view loop, consider if there is an existing AppKit control that could fit your needs. Both NSTableView and NSCollectionView will allow you to create a list / grid of views and use keyboard arrow keys to move selection between them. This plays nicely with the key view loop, as the entire table (in the case of NSTableView) is what recieves focus, while the arrow keys select the individual row / element. 

### Exceptions
If your window has a fairly static view heirarchy it is easier to set the nextKeyView properties for every applicable view. If you only have a few specific views whose `nextKeyView` property you want to modify, you can call `window.recalculateKeyViewLoop()` once to get an AppKit generated key view loop, and then set up your custom key views.


### Examples

Here is a rough overview of what your code may look like if you manually set up your own key view.
```swift
// In your AppDelegate or WindowController
window.autoRecalculatesKeyViewLoop = false

...

// In your ViewController, this must be done in viewDidAppear 
// to ensure the view is added to the window
override func viewDidAppear() {
    // Let AppKit generate a key view loop for you
    view.window?.recalculateKeyViewLoop()

    // Set up your own custom nextKeyViews
    fooView.nextKeyView = barView

    // Any subsequent call to `window.recalculateKeyViewLoop()`
    // will overwrite the nextKeyView of fooView
}
```

### References

https://cocoadev.github.io/KeyViewLoopGuidelines/

