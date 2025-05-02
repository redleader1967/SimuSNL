
import SwiftUI

struct TempsSimuleView: View {
    @Binding var jourSimule: Int
    @Binding var vitesseTemps: Int

    var body: some View {
        VStack {
            Text("Jour simulé : \(jourSimule)")
                .font(.headline)

            HStack {
                Button(vitesseTemps > 0 ? "Pause" : "Play") {
                    vitesseTemps = vitesseTemps > 0 ? 0 : 1
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)

                Picker("Vitesse", selection: $vitesseTemps) {
                    Text("1x").tag(1)
                    Text("5x").tag(5)
                    Text("10x").tag(10)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}
