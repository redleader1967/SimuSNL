
import SwiftUI

struct PortefeuilleView: View {
    var prixBTC: Double
    var bitcoin: Double
    var cashUSD: Double
    var valeurPortefeuilleJour: [Double]
    @Binding var periodeVariation: String

    var body: some View {
        let valeurPortefeuille = cashUSD + (bitcoin * prixBTC)

        VStack {
            Text("Valeur du portefeuille")
                .font(.headline)
            Text(String(format: "%.2f USD", valeurPortefeuille))
                .font(.title2).bold()
            Text(String(format: "Crypto détenue : %.6f BTC", bitcoin))
                .font(.subheadline)
        }
    }
}
