import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public class ZipApi {
    public static func searchAddress(zipCode: String) async -> String {
        return await withCheckedContinuation { (continuation: CheckedContinuation<String, Never>) in
            let urlString = "https://zipcloud.ibsnet.co.jp/api/search?zipcode=\(zipCode)"
            guard let url = URL(string: urlString) else {
                continuation.resume(returning: "無効なURLです")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(returning: "エラーが発生しました: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    continuation.resume(returning: "データを取得できませんでした")
                    return
                }
                
                do {
                    let postalCodeResponse = try JSONDecoder().decode(PostalCodeResponse.self, from: data)
                    
                    if postalCodeResponse.status == 200,
                       let results = postalCodeResponse.results,
                       !results.isEmpty {
                        let resultTexts = results.map { result in
                            """
                            郵便番号: \(result.zipcode)
                            住所: \(result.address1) \(result.address2) \(result.address3)
                            フリガナ: \(result.kana1) \(result.kana2) \(result.kana3)
                            """
                        }
                        let resultText = resultTexts.joined(separator: "\n")
                        continuation.resume(returning: resultText)
                    } else {
                        continuation.resume(returning: "該当する住所が見つかりませんでした")
                    }
                } catch {
                    continuation.resume(returning: "データの解析に失敗しました: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
}