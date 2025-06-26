import Foundation
// Note: This requires ComposableArchitecture to be properly configured in Xcode project
// For now, providing the structure that would work with TCA 1.17.1

/*
import ComposableArchitecture

@Reducer
struct ZipSearchFeature {
    @ObservableState
    struct State: Equatable {
        var isLoading: Bool = false
        var resultText: String = "結果がここに表示されます"
        var postalCode: String = ""
    }
    
    enum Action {
        case zipCode(String)
        case searchResponse(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .zipCode(zipCode):
                state.isLoading = true
                state.resultText = "検索中..."
                state.postalCode = zipCode
                
                return .run { send in
                    let result = await ZipApi.searchAddress(zipCode: zipCode)
                    await send(.searchResponse(result))
                }
                
            case let .searchResponse(result):
                state.isLoading = false
                state.resultText = result
                return .none
            }
        }
    }
}
*/

// Simplified version for demonstration without TCA dependency
public struct ZipSearchFeature {
    public struct State: Equatable {
        public var isLoading: Bool = false
        public var resultText: String = "結果がここに表示されます"
        public var postalCode: String = ""
        
        public init() {}
    }
    
    public enum Action {
        case zipCode(String)
        case searchResponse(String)
    }
}