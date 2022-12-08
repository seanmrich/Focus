import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

struct Child: ReducerProtocol {
  enum Focus: Hashable {
    case field1
    case field2
  }
  
  struct State: Equatable {
    var text1: String = ""
    var text2: String = ""
    var focus: Focus? = nil
  }
  
  enum Action {
    case text1Changed(String)
    case text2Changed(String)
    case focusChanged(Focus?)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .text1Changed(new):
      state.text1 = new
      return .none
      
    case let .text2Changed(new):
      state.text2 = new
      return .none
      
    case let .focusChanged(new):
      state.focus = new
      return .none
    }
  }
}


struct ChildView: View {
  let store: StoreOf<Child>
  @FocusState private var focus: Child.Focus?
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack {
        TextField(
          "Text1",
          text: viewStore.binding(
            get: \.text1,
            send: { .text1Changed($0) }
          )
        )
        .focused($focus, equals: .field1)

        TextField(
          "Text2",
          text: viewStore.binding(
            get: \.text2,
            send: { .text2Changed($0) }
          )
        )
        .focused($focus, equals: .field2)
      }
      .bind(
        viewStore.binding(
          get: \.focus,
          send: { .focusChanged($0) }
        ),
        to: $focus)
    }
  }
}


extension Child.Focus: FocusDisplayable {
  var displayName: String {
    switch self {
    case .field1: return "Child field 1"
    case .field2: return "Child field 2"
    }
  }
}
