//
//  GlobalConfig.swift
//  American Whitewater
//
//  Created by David Nelson on 5/15/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import Foundation

class AWGC {
    
    //public static let AW_BASE_URL: String = "http://aw.local"
    //public static let AW_BASE_URL: String = "https://beta.americanwhitewater.org" // beta
    public static let AW_BASE_URL: String = "https://www.americanwhitewater.org" // live
        
    //static let AWConsumerKey = "2"
    //static let AWConsumerKey = "5" // beta
    static let AWConsumerKey = "3" // production
    
    //static let AWConsumerSecret = "chD3tMYNvDdS8w1KN3KoqLlDNXBAFG3ikzracB7k"
    //static let AWConsumerSecret = "ObKROVKDNl48tCCR0MbTrRo4gKRG0Ji0hoZHHJO4" // beta
    static let AWConsumerSecret = "KVCwK8G9uj65XgtNWEsAixWVBVt0hDjRJLU0RpGh" // production
    
    static let AWCallbackUrl = "aw://oauth-callback/aw"
    static let AuthKeychainToken = "ios-aw-auth-key"
}


