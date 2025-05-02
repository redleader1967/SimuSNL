
import SwiftUI
import Charts

struct GraphiqueView: View {
    var valeurs: [Double]
    var titre: String

    var body: some View {
        VStack {
            Text(titre)
                .font(.headline)
            Chart {
                ForEach(Array(valeurs.enumerated()), id: \.offset) { index, valeur in
                    LineMark(
                        x: .value("Jour", index),
                        y: .value("Valeur", valeur)
                    )
                }
            }
            .frame(height: 300)
        }
        .padding()
    }
}
