import ComposableArchitecture
import SwiftUI

@main
struct FocusApp: App {
  let featureStore = StoreOf<Feature>(
    initialState: Feature.State(),
    reducer: Feature()
  )
  
  var body: some Scene {
    WindowGroup {
      FeatureView(store: featureStore)
        .frame(maxWidth: 300)
    }
  }
}
