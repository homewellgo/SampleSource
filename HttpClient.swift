
import UIKit

import Alamofire
import SwiftyJSON

class HttpClient: NSObject {

    static func jsonRequest(url: String, method: HTTPMethod, parameters: [String: AnyObject]?, completionHandler: @escaping ( ( _ isSuccess: Bool, _ json: JSON?  ) -> Void )    ) {

        Alamofire.request(url, method: method, parameters: parameters).responseJSON(completionHandler: { response in
            handleResponse(response: response, completionHandler: completionHandler)
        })

    }

    static func jsonRequestWithBuiltInAuthHeader(url: String, method: HTTPMethod, parameters: [String: AnyObject]?, completionHandler: @escaping ( ( _ isSuccess: Bool, _ json: JSON?  ) -> Void )    ) {
        
        let encoding: ParameterEncoding = parameterEncoding(forHttpMethod: method)
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding/*JSONEncoding.default*/, headers: Constants().authHeader() ).responseJSON(completionHandler: { response in
            handleResponse(response: response, completionHandler: completionHandler)
        })
        
    }

    static func handleResponse(response: DataResponse<Any>, completionHandler: @escaping ( ( _ isSuccess: Bool, _ json: JSON?  ) -> Void ) ) {

        let result = response.result
        let isSuccess = result.isSuccess

        guard isSuccess else {
            completionHandler(isSuccess, nil)
            return
        }

        guard let data = response.data else {
            completionHandler(isSuccess, nil)
            return
        }

        let responseJSON = JSON(data: data)
        completionHandler(isSuccess, responseJSON)
    }
    
    
    
    
    static func parameterEncoding(forHttpMethod httpMethod: HTTPMethod) -> ParameterEncoding {
        
        if httpMethod == .get {
            return URLEncoding(destination: .queryString)
        }
        return JSONEncoding.default
    }
}
