
import SwiftUI
import Charts

struct GraphiquePrixSNLView: View {
    var historiquePrix: [Double]
    @State private var periodeSelectionnee: String = "1 mois"

    let periodes = ["1h", "4h", "1 jour", "1 mois", "6 mois", "1 an"]

    var prixFiltres: [Double] {
        let totalJours = historiquePrix.count
        let indexDebut: Int

        switch periodeSelectionnee {
        case "1h":
            indexDebut = max(0, totalJours - 1) // 1 heure = 1/24 jour ~ dernier jour
        case "4h":
            indexDebut = max(0, totalJours - 1) // 4h aussi sur le dernier jour
        case "1 jour":
            indexDebut = max(0, totalJours - 1)
        case "1 mois":
            indexDebut = max(0, totalJours - 30)
        case "6 mois":
            indexDebut = max(0, totalJours - 180)
        case "1 an":
            indexDebut = max(0, totalJours - 365)
        default:
            indexDebut = 0
        }
        return Array(historiquePrix[indexDebut..<totalJours])
    }

    var body: some View {
        VStack {
            Text("Prix SNL")
                .font(.headline)
            Picker("Période", selection: $periodeSelectionnee) {
                ForEach(periodes, id: \.self) { periode in
                    Text(periode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Chart {
                ForEach(Array(prixFiltres.enumerated()), id: \.offset) { index, prix in
                    LineMark(
                        x: .value("Jour", index),
                        y: .value("Prix", prix)
                    )
                }
            }
            .frame(height: 300)

            Spacer()
        }
        .padding()
    }
}
