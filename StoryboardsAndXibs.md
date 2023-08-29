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
- Not supported in VisionOS

## Exceptions
- The main menu bar for a macOS app is required to be specified in a XIB.

## How to convert xib/storyboards to programmatic initialization on iOS
- Remove any reference to loading UIStoryboard pointer [storyboardWithName:bundle:](https://developer.apple.com/documentation/uikit/uistoryboard/1616216-storyboardwithname)
- Change the UIViewController caller
    - If the UIViewController was initialized by storyboard, instead of [instantiateViewController(withIdentifier:)](https://developer.apple.com/documentation/uikit/uistoryboard/1616214-instantiateviewcontroller), use [init(nibName:bundle:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621359-init) with parameter nil for nibName and bundle.
    - If the UIViewController was initialized by xibs, instead of passing in [init(nibName:bundle:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621359-init) in particular bundle, pass in nil for nibName and bundle.
    - Make sure no content of storyboard is initializing with [initWithCoder:](https://developer.apple.com/documentation/foundation/nscoding/1416145-initwithcoder?language=objc)
- For storyboards, make sure segues related functions do NOT get called. 
    - Do NOT Use
        - [shouldPerformSegue(withIdentifier:sender:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621502-shouldperformsegue)
        - [prepare(for:sender:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621490-prepare)
        - [allowedChildrenForUnwinding(from:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621371-allowedchildrenforunwinding)
        - [childContaining(_:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621384-childcontaining)
        - [canPerformUnwindSegueAction(_:from:sender:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/3089101-canperformunwindsegueaction)
        - [unwind(for:towards:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621473-unwind)
    - Can use
        - [viewWillAppear(_:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621510-viewwillappear/)
        - [viewDidAppear(_:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621423-viewdidappear)
        - [viewWillDisappear(_:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621485-viewwilldisappear)
        - [viewDidDisappear(_:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621477-viewdiddisappear)
        - [addChild(_:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621394-addchild)
        - [removeFromParent](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621394-addchild)
        - [dismissViewController](https://developer.apple.com/documentation/appkit/nsviewcontroller/1434413-dismissviewcontroller?language=objc)
    - Instead of using [performSegue(withIdentifier:sender:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621413-performsegue), use [presentViewController:animated:completion:](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621380-presentviewcontroller) or [pushViewController(_:animated:)](https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621887-pushviewcontroller) to UINavigationController stack.
- Initialize the UIViewController's view appropriately
    - Override [loadView](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621454-loadview?language=objc). If UIViewController needs to have a custom view, make sure you set the view in loadView. If there was anything declared in [awakeFromNib](https://developer.apple.com/documentation/objectivec/nsobject/1402907-awakefromnib?language=objc) make sure it has been moved over to loadView appropriately. For more info, please refer to [Apple documentation](https://developer.apple.com/documentation/uikit/view_controllers/displaying_and_managing_views_with_a_view_controller?language=objc)
    - Any properties that were declared with [IBOutlet](https://developer.apple.com/library/archive/documentation/General/Conceptual/CocoaEncyclopedia/Outlets/Outlets.html) now need to be programmatically allocated it memory
    - add any UIView to its self view's hierarchy using [addSubview(_:)](https://developer.apple.com/documentation/uikit/uiview/1622616-addsubview?language=objc_). 
    - set up all the subviews' [constraints](https://developer.apple.com/documentation/uikit/nslayoutconstraint/1526955-activateconstraints/)
        -  You might need to set subviews' [translatesAutoresizingMaskIntoConstraints](https://developer.apple.com/documentation/uikit/uiview/1622572-translatesautoresizingmaskintoco) to false
        - If you use [UIStackView](https://developer.apple.com/documentation/uikit/uistackview) with [addArrangedSubview(_:)](https://developer.apple.com/documentation/uikit/uistackview/1616227-addarrangedsubview), it may minizie the number of manual constraints needed. 
- Launch Screens on iOS in application's info.plist
    - remove any reference to storyboard or xib files
    - Use key [UILaunchScreen](https://developer.apple.com/documentation/bundleresources/information_property_list/uilaunchscreen)
- delete your xibs and storyboard files in your resource bundle.
