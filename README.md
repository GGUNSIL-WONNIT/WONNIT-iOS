# 워닛

유휴시간을 공간 공유로 채우는 지역 상권 활성화 서비스

![TestFlight](https://img.shields.io/badge/TestFlight-v1-0470b9?logo=app-store&logoColor=white)

### Key Experience

- **3D Scanning**: LiDAR + camera powered by RoomPlan and ARKit.
- **Change Detection**: CoreML mask predictor highlights post-use modifications, ensuring **trust and reliability** in space rentals.
- **Object Detection & Classification**: Ensures accurate categorization of spaces.


### Code Highlights

- **FormKit**
  - Custom-built, **highly reusable and abstracted** multi-step form framework.
  - Supports dynamic and declarative form generation from a single `FormStep` protocol.

- **FocusManager**
  - Custom SwiftUI focus manager designed for **multi-step forms** where `@FocusState` falls short.
  - Provides predictive navigation, and auto-focus on the next input.
 
- **Custom Draggable Sheet**
  - Built with SwiftUI gestures and animation for a **fluid transition** between bottom-sheet and full-screen-like states.
  - Provides a **seamless experience**, feeling like a native page expansion rather than a modal.
 
- **Networking**
  - Type-safe API client generation with [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator)
  - Added a custom decoder pipeline and documented error handling.
 
- **Unified design system**
  - Shared color and typography tokens via Swift extensions, e.g., `.body_05(.grey900)`.
