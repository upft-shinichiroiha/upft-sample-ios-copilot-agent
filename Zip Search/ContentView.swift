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
            @State var postalCode: String = ""
            
            VStack(spacing: 20) {
                Text("Zip Search")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("郵便番号（7桁）")
                        .font(.headline)
                    
                    TextField("例: 7830060", text: $postalCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .onChange(of: postalCode) { _, newValue in
                            // 数字のみ許可し、7桁まで制限
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered.count <= 7 {
                                postalCode = filtered
                            } else {
                                postalCode = String(filtered.prefix(7))
                            }
                        }
                }
                
                Button(action: { 
                    viewStore.send(.zipCode(postalCode))
                }) {
                    if viewStore.isLoading {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("検索中...")
                                .foregroundColor(.white)
                        }
                    } else {
                        Text("送信")
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isValidPostalCode(postalCode) && !viewStore.isLoading ? Color.blue : Color.gray)
                .cornerRadius(8)
                .disabled(!isValidPostalCode(postalCode) || viewStore.isLoading)
                
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