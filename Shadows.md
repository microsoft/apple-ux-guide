
# Comparison of the Shadow blur/radius property across platforms

The shadow blur-radius property on Web, shadowRadius property on Apple platforms (iOS/macOS), and elevation property on Android all affect how blurred out the edges of a shadow look. However, they each affect the resulting shadow differently, and setting the same value for each of these will not result in a shadow that looks the same across platforms.

## Convention

If you are working with shadowRadius on an Apple platform trying to align with designs made with a web tool (like Figma or Sketch), divide the blur by 2.  This applies to React Native as well.
This applies to these platforms on React Native as well (React Native, React Native macOS, and React Native Web)

## Rationale

We compared how shadows are rendered across different platforms, and found a discrepancy in how blur is handled. For whatever reason, dividing the blur by 2 is necessary to have the correct effect on Apple platforms. See the table below:

| Platform + Notes | Code | Screenshot |
| - | - | - |
| Web: CSS </br></br> [box-shadow documentation](https://www.w3schools.com/cssref/css3_pr_box-shadow.asp), also can try out shadows [here](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Backgrounds_and_Borders/Box-shadow_generator) | <img width="2000" alt="Screen Shot 2022-09-07 at 1 11 53 PM" src="https://user-images.githubusercontent.com/78454019/188968215-f5c612c3-970d-4ec5-8ec6-0bc5d563ca09.png"> | Shadow blur = 100 <img width="4000" alt="Screen Shot 2022-09-06 at 1 34 55 PM" src="https://user-images.githubusercontent.com/78454019/188753588-c2c6a808-c822-45a7-8220-2a99bfab8e27.png">|
| Web: Figma </br></br> Figma uses the same shadow blur property as web | <img width="500" alt="Screen Shot 2022-09-07 at 12 31 38 PM" src="https://user-images.githubusercontent.com/78454019/188961635-0411b0f6-03e2-42e4-8b27-10d4674470a6.png"> | <img width="1200" alt="Screen Shot 2022-09-06 at 1 48 25 PM" src="https://user-images.githubusercontent.com/78454019/188753714-0ddf59b5-515b-4d78-bba8-65a0cbd0bf15.png"> |
| Web: React Native Web </br></br> React Native shadowRadius documentation [here](https://reactnative.dev/docs/shadow-props), CSS shadow blur documentation [here](https://www.w3schools.com/cssref/css3_pr_box-shadow.asp), also can test shadows with this [snack](https://snack.expo.dev/@lyzhan/shadow-ios-web-android). Uses shadowRadius, which ends up being the same as the blur property (don't need to /2) | <img width="302" alt="Screen Shot 2022-09-07 at 1 43 41 PM" src="https://user-images.githubusercontent.com/78454019/188983108-913837f8-69a3-4e89-8f57-fec1967452c2.png">| <img width="200" alt="Screen Shot 2022-09-06 at 1 47 08 PM" src="https://user-images.githubusercontent.com/78454019/188753483-638f7c19-64a2-44cc-873b-98a539df8bf7.png"> |
| Apple: React Native iOS </br></br> React Native shadowRadius documentation [here](https://reactnative.dev/docs/shadow-props), native Apple shadowRadius documentation [here](https://developer.apple.com/documentation/quartzcore/calayer/1410819-shadowradius), also can test shadows with this [snack](https://snack.expo.dev/@lyzhan/shadow-ios-web-android). In order to get Apple shadows to look the same as Figma, shadowRadius should be blur/2. | <img width="302" alt="Screen Shot 2022-09-07 at 1 43 41 PM" src="https://user-images.githubusercontent.com/78454019/188974391-497ec98a-f7f0-462a-b40c-3f218d6fbe21.png"> <img width="310" alt="Screen Shot 2022-09-07 at 1 45 45 PM" src="https://user-images.githubusercontent.com/78454019/188974838-1ca1f7af-af69-42c8-8d0f-90786e44d57d.png">| <img width="200" alt="Screen Shot 2022-09-06 at 1 45 54 PM" src="https://user-images.githubusercontent.com/78454019/188753614-efd1d852-5cc3-4419-bbaf-62b802e1d513.png"> <img width="200" alt="Screen Shot 2022-09-06 at 2 02 50 PM" src="https://user-images.githubusercontent.com/78454019/188753450-cbcbfef2-ae5d-4ddd-8284-07ff5fd2c2d1.png">|
| Apple: Native macOS </br></br> [shadowBlurRadius](https://developer.apple.com/documentation/uikit/nsshadow/1429846-shadowblurradius) documentation | <img width="443" alt="NativeMacOS_100" src="https://user-images.githubusercontent.com/78454019/189423358-4223d549-e589-4aa3-abc7-7b1e9a6ef04e.png"> <img width="433" alt="NativeMacOS_50" src="https://user-images.githubusercontent.com/78454019/189423369-ad2926d0-a4b9-448b-afca-38dd6b00a0cb.png"> | <img width="472" alt="NativeMacOS_100_screenshot" src="https://user-images.githubusercontent.com/78454019/189423396-394970d4-6507-419f-bd97-d26929cb6139.png"> <img width="460" alt="NativeMacOS_50_screenshot" src="https://user-images.githubusercontent.com/78454019/189423409-dcb62f08-d139-4193-9f55-30c3f9e2b47d.png"> |
| Android: React Native Android </br></br> Can test shadows with this [snack](https://snack.expo.dev/@lyzhan/shadow-ios-web-android). Uses elevation, which is just different from both how web/iOS handle shadows| <img width="311" alt="Screen Shot 2022-09-07 at 1 42 18 PM" src="https://user-images.githubusercontent.com/78454019/188983536-e4a17f29-456f-411d-968d-43e32a93f1b6.png"> | <img width="200" alt="Screen Shot 2022-09-06 at 1 46 26 PM" src="https://user-images.githubusercontent.com/78454019/188753672-c8d3853f-7ea6-4b00-b2f6-b79884f30356.png"> |

## Examples

In Fluent UI React Native, here is a snippet of the code that takes a shadowToken object (basically an object that describes shadows the way web does, with blur) and converts it into a react native shadow.

```typescript
const appleShadowBlurAdjustment = 0.5;
const defaultShadowBlurAdjustment = 1;

function getShadowTokenStyleSet(shadowToken: ShadowToken) {
  const keyShadow = shadowToken.key;
  const ambientShadow = shadowToken.ambient;
  const shadowBlurAdjustment = Platform.OS === 'macos' || Platform.OS === 'ios' ? appleShadowBlurAdjustment : defaultShadowBlurAdjustment;

  return {
    key: {
      shadowColor: shadowColorFromRGBAColor(keyShadow.color),
      shadowOpacity: shadowOpacityFromRGBAColor(keyShadow.color),
      shadowRadius: keyShadow.blur * shadowBlurAdjustment,
      shadowOffset: {
        width: keyShadow.x,
        height: keyShadow.y,
      },
    },
    ambient: {
      shadowColor: shadowColorFromRGBAColor(ambientShadow.color),
      shadowOpacity: shadowOpacityFromRGBAColor(ambientShadow.color),
      shadowRadius: ambientShadow.blur * shadowBlurAdjustment,
      shadowOffset: {
        width: ambientShadow.x,
        height: ambientShadow.y,
      },
    },
  };
}
```

Additional work:
- todo: add FluentUI Apple helper function here
- todo: add Win32 code + screenshot as well
