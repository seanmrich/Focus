import SwiftUI

struct FocusPrinter<ModelFocus, ViewFocus>: View
where ModelFocus: FocusDisplayable, ViewFocus: FocusDisplayable {
    let modelFocus: ModelFocus?
    let viewFocus: ViewFocus?
    
    init(model: ModelFocus?, view: ViewFocus?) {
        self.modelFocus = model
        self.viewFocus = view
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("Model")
                    .font(.title3)
                Text(modelFocus?.displayName ?? "nil")
            }
            VStack {
                Text("View")
                    .font(.title3)
                Text(viewFocus?.displayName ?? "nil")
            }
        }
    }
}

protocol FocusDisplayable: Hashable {
    var displayName: String { get }
}
