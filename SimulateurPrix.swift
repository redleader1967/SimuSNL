
import Foundation

struct SimulateurPrix {
    static func prixPourJour(_ jour: Int) -> Double {
        // Simule un prix qui augmente légèrement avec de la volatilité
        let base = 1000.0 * pow(1.0002, Double(jour))
        let volatilite = 50.0 * sin(Double(jour) * 0.1)
        let bullBear = (jour % 180 > 90) ? 1.1 : 0.9
        return max(100, base + volatilite) * bullBear
    }
}
