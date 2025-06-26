import Foundation
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