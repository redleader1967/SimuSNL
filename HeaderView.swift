
import SwiftUI

struct HeaderView: View {
    var prixBTC: Double
    var variationBTC: Double
    var variationCourtTerme: Double
    var rafraichirAction: () -> Void

    var body: some View {
        VStack {
            Text("Prix SNL actuel").font(.headline)
            Text(String(format: "%.2f", prixBTC) + " USD")
                .font(.largeTitle).bold()

            HStack {
                Text(String(format: "Variation 4h : %.2f%%", variationCourtTerme))
                    .foregroundColor(.green)
                Spacer()
                Text(String(format: "Variation 24h : %.2f%%", variationBTC))
                    .foregroundColor(.green)
            }
            .font(.subheadline)
            .padding(.horizontal)

            Button("🔄 Rafraîchir le prix") {
                rafraichirAction()
            }
            .foregroundColor(.blue)
        }
    }
}
