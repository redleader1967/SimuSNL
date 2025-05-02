
import SwiftUI

struct HistoriqueVariationView: View {
    var historiquePrix: [Double]
    @State private var seuilVariation: Double = 0.0

    var variations: [(jour: Int, variation: Double)] {
        var liste: [(Int, Double)] = []
        for i in 1..<historiquePrix.count {
            let variation = ((historiquePrix[i] - historiquePrix[i - 1]) / historiquePrix[i - 1]) * 100
            if abs(variation) >= seuilVariation {
                liste.append((i, variation))
            }
        }
        return liste
    }

    var body: some View {
        VStack {
            Text("Historique des variations")
                .font(.headline)
            Slider(value: $seuilVariation, in: 0...10, step: 0.5) {
                Text("Filtre variation (%)")
            }
            Text("Filtre : Variations >= \(seuilVariation, specifier: "%.1f")%")
            List(variations, id: \.(jour)) { item in
                Text("Jour \(item.jour) ➔ \(item.variation, specifier: "%.2f")%")
            }
        }
    }
}
