import Foundation

class GQLError {
    
    public static func handleGQLError(error: Error?, altMessage: String?) -> String {
        print("A GraphQL Error Response Occured:")
        var errorMessage = ""
        
        if let error = error {
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
        
        if let message = altMessage {
            print(message)
            errorMessage = message
        }
        
        return errorMessage
    }
    
}
