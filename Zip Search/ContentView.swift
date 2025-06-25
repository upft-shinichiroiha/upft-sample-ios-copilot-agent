import SwiftUI

struct PostalCodeResponse: Codable {
    let message: String?
    let results: [PostalCodeResult]?
    let status: Int
}

struct PostalCodeResult: Codable {
    let address1: String
    let address2: String
    let address3: String
    let kana1: String
    let kana2: String
    let kana3: String
    let prefcode: String
    let zipcode: String
}

struct ContentView: View {
    @State private var postalCode: String = ""
    @State private var resultText: String = "結果がここに表示されます"
    @State private var isLoading: Bool = false
    
    private var isValidPostalCode: Bool {
        postalCode.count == 7 && postalCode.allSatisfy { $0.isNumber }
    }
    
    var body: some View {
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
            
            Button(action: searchAddress) {
                if isLoading {
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
            .background(isValidPostalCode && !isLoading ? Color.blue : Color.gray)
            .cornerRadius(8)
            .disabled(!isValidPostalCode || isLoading)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("結果")
                    .font(.headline)
                
                ScrollView {
                    Text(resultText)
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
    
    private func searchAddress() {
        guard isValidPostalCode else { return }
        
        isLoading = true
        resultText = "検索中..."
        
        let urlString = "https://zipcloud.ibsnet.co.jp/api/search?zipcode=\(postalCode)"
        guard let url = URL(string: urlString) else {
            resultText = "無効なURLです"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    resultText = "エラーが発生しました: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    resultText = "データを取得できませんでした"
                    return
                }
                
                do {
                    let postalCodeResponse = try JSONDecoder().decode(PostalCodeResponse.self, from: data)
                    
                    if postalCodeResponse.status == 200,
                       let results = postalCodeResponse.results,
                       !results.isEmpty {
                        let result = results[0]
                        resultText = """
                        郵便番号: \(result.zipcode)
                        住所: \(result.address1) \(result.address2) \(result.address3)
                        フリガナ: \(result.kana1) \(result.kana2) \(result.kana3)
                        """
                    } else {
                        resultText = "該当する住所が見つかりませんでした"
                    }
                } catch {
                    resultText = "データの解析に失敗しました: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}