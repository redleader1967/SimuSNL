
import SwiftUI

struct TradeInputView: View {
    @Binding var montantTrade: String
    @Binding var unite: String
    var unites: [String]

    var body: some View {
        VStack {
            TextField("Montant", text: $montantTrade)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Picker("Unité", selection: $unite) {
                ForEach(unites, id: \.self) { unite in
                    Text(unite)
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}
