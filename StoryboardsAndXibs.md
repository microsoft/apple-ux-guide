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

## How to convert xib to programmatic initialization
- Change the UIViewController caller
    - Instead of passing in [nibName](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621359-init) in particular bundle, pass in nil
    - Make sure no other storyboard is initializing with [iniWithCoder:](https://developer.apple.com/documentation/foundation/nscoding/1416145-initwithcoder?language=objc)
- Initialize the UIViewController's view appropriately
    - Override [loadView](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621454-loadview?language=objc). If UIViewController needs to have a customer view, make sure you set the view in loadView. If there were anything that was declared in [awakeFromNib](https://developer.apple.com/documentation/objectivec/nsobject/1402907-awakefromnib?language=objc) make sure it has been moved over to loadView appropriately. For more info, please refer to [apple documentation](https://developer.apple.com/documentation/uikit/view_controllers/displaying_and_managing_views_with_a_view_controller?language=objc)
    - Any properties that were declared with [IBOutlet](https://developer.apple.com/library/archive/documentation/General/Conceptual/CocoaEncyclopedia/Outlets/Outlets.html) now needs to be programmatically allocated it memory
    - add any UIView to its self view's [hierarchy](https://developer.apple.com/documentation/uikit/uiview/1622616-addsubview?language=objc_). 
    - set up all the subviews [constraints](https://developer.apple.com/documentation/uikit/nslayoutconstraint/1526955-activateconstraints/)

