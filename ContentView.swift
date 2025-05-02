
import SwiftUI

struct ContentView: View {
    @State private var cashUSD: Double = 1000
    @State private var bitcoin: Double = 0.0
    @State private var jourSimule: Int = 0
    @State private var vitesseTemps: Int = 1
    @State private var prixSNL: Double = 1000.0
    @State private var prixHistorique: [Double] = [1000.0]
    @State private var montantTrade: String = ""
    @State private var valeurPortefeuilleJour: [Double] = []
    @State private var valeurBTCJour: [Double] = []
    @State private var unite: String = "USD"
    @State private var messageErreur: String = ""
    @State private var timer: Timer? = nil

    let unites = ["USD", "BTC"]
    let vitesses = [0, 1, 5, 10] // 0 = pause

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TempsSimuleView(jourSimule: $jourSimule, vitesseTemps: $vitesseTemps)
                    HeaderView(prixBTC: prixSNL,
                               variationBTC: variationPour(24),
                               variationCourtTerme: variationPour(4),
                               rafraichirAction: mettreAJourPrix)
                    PortefeuilleView(prixBTC: prixSNL, bitcoin: bitcoin, cashUSD: cashUSD,
                                     valeurPortefeuilleJour: valeurPortefeuilleJour,
                                     periodeVariation: .constant("1 jour"))
                    TradeInputView(montantTrade: $montantTrade, unite: $unite, unites: unites)
                    if !messageErreur.isEmpty {
                        Text(messageErreur).foregroundColor(.red).font(.caption)
                    }
                    ActionButtonsView(acheter: acheter, vendre: vendre)

                    Picker("Vitesse", selection: $vitesseTemps) {
                        Text("Pause").tag(0)
                        Text("1x").tag(1)
                        Text("5x").tag(5)
                        Text("10x").tag(10)
                    }.pickerStyle(SegmentedPickerStyle()).padding()

                    NavigationLink(destination: GraphiqueView(valeurs: valeurPortefeuilleJour, titre: "Portefeuille USD")) {
                        Text("Graphique portefeuille USD")
                    }

                    NavigationLink(destination: GraphiqueView(valeurs: valeurBTCJour, titre: "Portefeuille Crypto (SNL)")) {
                        Text("Graphique portefeuille SNL")
                    }

                    NavigationLink(destination: GraphiquePrixSNLView(historiquePrix: prixHistorique)) {
                        Text("Graphique prix SNL")
                    }

                    Text("Développé par redleader1967")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
                .navigationTitle("Simulateur SNL")
                .onAppear {
                    mettreAJourPrix()
                    demarrerTimer()
                }
                .onDisappear {
                    arreterTimer()
                }
            }
        }
    }

    func mettreAJourPrix() {
        prixSNL = SimulateurPrix.prixPourJour(jourSimule)
        if prixHistorique.count <= jourSimule {
            prixHistorique.append(prixSNL)
        } else {
            prixHistorique[jourSimule] = prixSNL
        }
        enregistrerValeurs()
    }

    func variationPour(_ heures: Int) -> Double {
        let joursDecales = Double(heures) / 24.0
        let indexAncien = max(0, jourSimule - Int(joursDecales))
        let ancienPrix = indexAncien < prixHistorique.count ? prixHistorique[indexAncien] : prixHistorique.first ?? prixSNL
        if ancienPrix == 0 { return 0 }
        return ((prixSNL - ancienPrix) / ancienPrix) * 100
    }

    func montantConverti() -> Double? {
        let texte = montantTrade.replacingOccurrences(of: ",", with: ".")
        return Double(texte)
    }

    func acheter() {
        guard let montant = montantConverti(), montant > 0 else {
            messageErreur = "Montant invalide"
            return
        }
        messageErreur = ""
        if unite == "USD" {
            if montant <= cashUSD {
                let btcAchat = montant / prixSNL
                bitcoin += btcAchat
                cashUSD -= montant
            } else {
                messageErreur = "Fonds insuffisants"
            }
        } else {
            let valeurUSD = montant * prixSNL
            if valeurUSD <= cashUSD {
                bitcoin += montant
                cashUSD -= valeurUSD
            } else {
                messageErreur = "Fonds insuffisants"
            }
        }
        enregistrerValeurs()
    }

    func vendre() {
        guard let montant = montantConverti(), montant > 0 else {
            messageErreur = "Montant invalide"
            return
        }
        messageErreur = ""
        if unite == "USD" {
            let btcVente = montant / prixSNL
            if btcVente <= bitcoin {
                bitcoin -= btcVente
                cashUSD += montant
            } else {
                messageErreur = "Pas assez de SNL"
            }
        } else {
            if montant <= bitcoin {
                bitcoin -= montant
                cashUSD += montant * prixSNL
            } else {
                messageErreur = "Pas assez de SNL"
            }
        }
        enregistrerValeurs()
    }

    func enregistrerValeurs() {
        let valeurPortefeuille = cashUSD + (bitcoin * prixSNL)
        if valeurPortefeuilleJour.count <= jourSimule {
            valeurPortefeuilleJour.append(valeurPortefeuille)
            valeurBTCJour.append(bitcoin)
        } else {
            valeurPortefeuilleJour[jourSimule] = valeurPortefeuille
            valeurBTCJour[jourSimule] = bitcoin
        }
    }

    func demarrerTimer() {
        arreterTimer() // évite de créer plusieurs timers
        timer = Timer.scheduledTimer(withTimeInterval: intervallePourVitesse(), repeats: true) { _ in
            if vitesseTemps > 0 {
                jourSimule += vitesseTemps
                mettreAJourPrix()
            }
        }
    }

    func intervallePourVitesse() -> Double {
        if vitesseTemps == 0 { return 9999 } // pause
        return 60.0 / Double(vitesseTemps) // 1 jour = 60 secondes à vitesse 1
    }

    func arreterTimer() {
        timer?.invalidate()
        timer = nil
    }
}
