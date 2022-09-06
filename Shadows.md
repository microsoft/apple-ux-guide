
### Differences in Shadows across platforms
- Figma uses the same shadow properties as web: i.e. the blur property
- react-native-iOS uses shadowRadius. In order to get iOS shadows to look the same as Figma, shadowRadius should be blur/2. Native iOS should also use blur/2, as well as react-native-macOS
- react-native-web also uses shadowRadius, which ends up being the same as the blur property (don't need to /2)
- react-native-android uses elevation, which is just different from both how web and iOS handle shadows.

| Figma | Web shadowBlur = 100|
| - | - |
| <img width="721" alt="Screen Shot 2022-09-06 at 1 48 25 PM" src="https://user-images.githubusercontent.com/78454019/188753714-0ddf59b5-515b-4d78-bba8-65a0cbd0bf15.png"> | <img width="616" alt="Screen Shot 2022-09-06 at 1 34 55 PM" src="https://user-images.githubusercontent.com/78454019/188753588-c2c6a808-c822-45a7-8220-2a99bfab8e27.png"> |


| React Native iOS | React Native iOS with radius=blur/2 | React Native Web | React Native Android |
| - | - | - | - |
| <img width="331" alt="Screen Shot 2022-09-06 at 1 45 54 PM" src="https://user-images.githubusercontent.com/78454019/188753614-efd1d852-5cc3-4419-bbaf-62b802e1d513.png"> | <img width="334" alt="Screen Shot 2022-09-06 at 2 02 50 PM" src="https://user-images.githubusercontent.com/78454019/188753450-cbcbfef2-ae5d-4ddd-8284-07ff5fd2c2d1.png"> | <img width="333" alt="Screen Shot 2022-09-06 at 1 47 08 PM" src="https://user-images.githubusercontent.com/78454019/188753483-638f7c19-64a2-44cc-873b-98a539df8bf7.png"> | <img width="331" alt="Screen Shot 2022-09-06 at 1 46 26 PM" src="https://user-images.githubusercontent.com/78454019/188753672-c8d3853f-7ea6-4b00-b2f6-b79884f30356.png">

Resources
- can play around with web shadows [here](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Backgrounds_and_Borders/Box-shadow_generator)
- can play around with react native iOS/Android/Web shadows [here](https://snack.expo.dev/)
