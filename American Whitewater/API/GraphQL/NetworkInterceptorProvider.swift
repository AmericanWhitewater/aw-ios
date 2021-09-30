import Foundation
import Apollo
import KeychainSwift

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(TokenAddingInterceptor(), at: 0)
        return interceptors
    }
}

class TokenAddingInterceptor: ApolloInterceptor {
    func interceptAsync<Operation>(chain: RequestChain, request: HTTPRequest<Operation>, response: HTTPResponse<Operation>?, completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : GraphQLOperation {
        if let token = KeychainSwift().get(AWGC.AuthKeychainToken) {
            request.addHeader(name: "Authorization", value: "Bearer \(token)")
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}
