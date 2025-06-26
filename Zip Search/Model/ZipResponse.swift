import Foundation

public struct PostalCodeResponse: Codable {
    let message: String?
    let results: [PostalCodeResult]?
    let status: Int
}

public struct PostalCodeResult: Codable {
    let address1: String
    let address2: String
    let address3: String
    let kana1: String
    let kana2: String
    let kana3: String
    let prefcode: String
    let zipcode: String
}