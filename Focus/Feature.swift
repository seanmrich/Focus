import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

struct Feature: ReducerProtocol {
  enum Focus: Hashable {
    case featureField
    case child(Child.Focus)
  }
  
  struct State: Equatable {
    var featureText: String = ""
    var childText1: String = ""
    var childText2: String = ""
    var focus: Focus? = .featureField
  }
  
  enum Action {
    case textChanged(String)
    case focusChanged(Focus?)
    case child(Child.Action)
  }
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.childState, action: /Action.child) {
      Child()
    }
    
    Reduce { state, action in
      switch action {
      case let .textChanged(new):
        state.featureText = new
        return .none
        
      case let .focusChanged(new):
        state.focus = new
        return .none
        
      case .child:
        return .none
      }
    }
  }
}

extension Feature.State {
  var childState: Child.State {
    get {
      .init(
        text1: childText1,
        text2: childText2,
        focus: (/Feature.Focus.child).extract(from: focus)
      )
    }
    set {
      childText1 = newValue.text1
      childText2 = newValue.text2
      if let childFocus = newValue.focus {
        focus = .child(childFocus)
      }
    }
  }
}


struct FeatureView: View {
  let store: StoreOf<Feature>
  @FocusState private var focus: Feature.Focus?
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        TextField(
          "Feature Text",
          text: viewStore.binding(
            get: \.featureText,
            send: { .textChanged($0) }
          )
        )
        .focused($focus, equals: .featureField)
        
        ChildView(
          store: store.scope(
            state: \.childState,
            action: Feature.Action.child
          )
        )
        
        FocusPrinter(model: viewStore.focus, view: focus)
      }
      .bind(
        viewStore.binding(
          get: \.focus,
          send: { .focusChanged($0) }
        ),
        to: $focus
      )
    }
  }
}


extension Feature.Focus: FocusDisplayable {
  var displayName: String {
    switch self {
    case .featureField: return "Feature Field"
    case .child(let childFocus): return childFocus.displayName
    }
  }
}
