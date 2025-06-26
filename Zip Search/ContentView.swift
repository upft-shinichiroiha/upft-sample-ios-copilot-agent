import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<ZipSearchFeature>
    
    init(store: StoreOf<ZipSearchFeature> = Store(initialState: ZipSearchFeature.State()) {
        ZipSearchFeature()
    }) {
        self.store = store
    }
    
    private func isValidPostalCode(_ postalCode: String) -> Bool {
        postalCode.count == 7 && postalCode.allSatisfy { $0.isNumber }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Text("Zip Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("郵便番号（7桁）")
                        .font(.headline)
                    
                    TextField("例: 7830060", text: viewStore.binding(
                        get: \.postalCode,
                        send: { .postalCodeChanged($0) }
                    ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                Button(action: { 
                    viewStore.send(.zipCode(viewStore.postalCode))
                }) {
                    if viewStore.isLoading {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("検索中...")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    } else {
                        Text("送信")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                }
                .background(isValidPostalCode(viewStore.postalCode) && !viewStore.isLoading ? Color.blue : Color.gray)
                .cornerRadius(8)
                .disabled(!isValidPostalCode(viewStore.postalCode) || viewStore.isLoading)
                .buttonStyle(.plain)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("結果")
                        .font(.headline)
                    
                    ScrollView {
                        Text(viewStore.resultText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .frame(minHeight: 200)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}