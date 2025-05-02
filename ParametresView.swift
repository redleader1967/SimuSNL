
import SwiftUI

struct ParametresView: View {
    @Binding var modeSombre: Bool

    var body: some View {
        VStack {
            Toggle("Mode sombre", isOn: $modeSombre)
            Spacer()
        }
        .padding()
    }
}
