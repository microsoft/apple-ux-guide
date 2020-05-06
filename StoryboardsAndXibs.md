# Storyboards

## Convention
In most cases on both macOS and iOS, it is recommended to avoid storyboards (and XIBs) in favor of programmatically creating views and view controllers

## Rationale
- Runtime performance analysis has shown us that disk operations degrade poorly for users with slower devices. Since creating UI programmatically allows us to avoid reading the storyboard/nib from disk at runtime, we should do so.
- Storyboard XML is becoming simpler over time, but still falls short of human readability. This makes code reviews difficult and merge conflicts likely. The generated XML is easily bloated and it's difficult to be sure everything we're adding is necessary and intentional.
- Keeping view hierarchy construction in storyboards can leave code simpler, but there are some best practices that can keep code simple while avoiding the pitfalls above:
    - [Compose view hierarchies With NSStackViews/UIStackViews](Layout.md#Compose-Hierarchies-with-NSStackViews/UIStackViews).
    - [Use layout anchor constraints](Layout.md#Use-Layout-Anchor-Constraints)
    - [Create the view hierarchy in loadView](ViewControllers.md#Construct-View-Hierarchies-in-loadView)

## Exceptions
- Launch Screens on iOS are required to be specified as storyboards.
- The main menu bar for a macOS app is required to be specified in a XIB.