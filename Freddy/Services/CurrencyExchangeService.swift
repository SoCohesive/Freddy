//
//  CurrencyExchangeService.swift
//  Freddy
//
//  Created by Sonam Dhingra on 12/7/15.
//  Copyright © 2015 Sonam Dhingra. All rights reserved.
//

import UIKit
import Alamofire


/*
The response struct is used to return data from API services and data fetchers
*/

public struct Response : CustomStringConvertible {
    var data:AnyObject?
    var error:NSError?
    
    public var description: String {
        return  "Data: \(self.data), Error:  \(self.error)"
    }
}


class CurrencyExchangeService: NSObject {
    
    let baseURL = "https://currency-api.appspot.com/api/USD/"
    let callBackResponseFormat = "json"
    
    static let sharedService = CurrencyExchangeService()
    typealias CompletionClosure = (response: Response) ->()

    enum CurrencySymbols: String {
        case GBP, EUR, JPY, BRL
    }
    
    
    func convertUSDAmount(amount:Int, toCurrencySymbol symbol:CurrencySymbols, completionClosure: CompletionClosure?) {
        
        GET(constructedUrl(symbol.rawValue), params: nil) { (response) -> () in
            if completionClosure != nil {
                completionClosure!(response: response)
            }
        }
    }
    
    func constructedUrl(symbol:String) -> String {
        return "\(baseURL)\(symbol).\(callBackResponseFormat)?amount=1.00"
    }
    
    
    //MARK: AlamoFire Wrapper function
    
    func GET(url:String, params:[String:AnyObject]?, requestResponseClosure: CompletionClosure?) {
        
        
        Alamofire.request(.GET, "\(url)", parameters: params, encoding:.URL, headers: nil).responseJSON {(request, response, result) -> Void in
            var response = Response()
            response.data = result.value
            response.error = result.error as? NSError
            
            if (requestResponseClosure != nil) {
                requestResponseClosure!(response: response)
            }
        }
    }

}
