
import SwiftUI

struct ActionButtonsView: View {
    var acheter: () -> Void
    var vendre: () -> Void

    var body: some View {
        HStack {
            Button("Acheter") {
                acheter()
            }
            .padding()
            .background(Color.green.opacity(0.3))
            .cornerRadius(8)

            Button("Vendre") {
                vendre()
            }
            .padding()
            .background(Color.red.opacity(0.3))
            .cornerRadius(8)
        }
    }
}

