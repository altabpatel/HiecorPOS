//
//  NetworkInterface.swift
//  HieCOR
//
//  Created by Deftsoft on 17/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Call Backs
typealias JSONDictionary = [String:Any]
typealias JSONArray = [JSONDictionary]
typealias APIServiceSuccessCallback = ((Any?) -> ())
typealias APIServiceFailureCallback = ((NetworkErrorReason?, NSError?) -> ())
typealias JSONArrayResponseCallback = ((JSONArray?) -> ())
typealias JSONDictionaryResponseCallback = ((JSONDictionary?) -> ())
typealias responseCallBack = ((Int, String?, NSError?) -> ())


//MARK: Constant
var myRequest: Alamofire.Request?

public enum NetworkErrorReason: Error {
    case FailureErrorCode(code: Int, message: String)
    case InternetNotReachable
    case UnAuthorizedAccess
    case Other
}

public enum MimeType: String {
    case image = "image/png"
    case video = "video/mp4"
}

struct Resource {
    let method: HTTPMethod
    let parameters: [String : Any]?
    let headers: [String:String]?
}

struct MultiOrder {
    let method: HTTPMethod
    let parameters: [[String : Any]]?
    let headers: [String:String]?
}

protocol APIService {
    var path: String { get }
    var resource: Resource { get }
    var multiOrder: MultiOrder {get}
}

extension APIService {
    
    /**
     Method which needs to be called from the respective model class.
     - parameter successCallback:   successCallback with the JSON response.
     - parameter failureCallback:   failureCallback with ErrorReason, Error description and Error.
     */
    
    //MARK: Request Method to Send Request except in Multipart with ContentType application/json
    func requestNew(requestTime: TimeInterval = 180, isURLEncoded: Bool = false, isMultiOrder: Bool = false, success: @escaping APIServiceSuccessCallback, failure: @escaping APIServiceFailureCallback) {
        do {
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            debugPrint("********************************* API Request **************************************")
            debugPrint("Request URL:\(path)")
            if isMultiOrder {
                debugPrint("Request resource: \(multiOrder)")
                debugPrint("Request parameter:\(String(describing: multiOrder.parameters)))")
            }else {
                debugPrint("Request resource: \(resource)")
                debugPrint("Request parameter:\(String(describing: resource.parameters)))")
            }
            debugPrint("************************************************************************************")
            
            var encoding: URLEncoding = .default
            if isURLEncoded{
                encoding = .httpBody
            }
            
            if isMultiOrder {
                debugPrint("Request method: \(multiOrder.method)")
                debugPrint("Request parameter:\(String(describing: multiOrder.parameters)))")
                debugPrint("Request encoding: \(encoding)")
                debugPrint("Request headers: \(String(describing: multiOrder.headers)))")
            }else {
                debugPrint("Request method: \(resource.method)")
                debugPrint("Request parameter:\(String(describing: resource.parameters)))")
                debugPrint("Request encoding: \(encoding)")
                debugPrint("Request headers: \(String(describing: resource.headers)))")
            }
            
            var request = URLRequest(url: URL(string: path)!)
            request.httpMethod = resource.method.rawValue
            request.timeoutInterval = requestTime
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if resource.headers != nil {
                for (key, value) in resource.headers! {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            if isMultiOrder {
                if multiOrder.parameters != nil {
                    request.httpBody = try! JSONSerialization.data(withJSONObject: multiOrder.parameters ?? "")
                }
            }
            else {
                if resource.parameters != nil {
                    request.httpBody = try! JSONSerialization.data(withJSONObject: resource.parameters ?? "")
                }
            }
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = requestTime
            myRequest = manager.request(request)
                .responseJSON { response in
                    // do whatever you want here
                    Indicator.sharedInstance.hideIndicator()
                    debugPrint("************************** Response Start *********************************************************")
                    debugPrint("Result \(response))")
                    debugPrint("************************** Response End *********************************************************")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    myRequest = nil
                    
                    switch response.result {
                    case .success(let value):
                        success(value as AnyObject?)
                    case .failure(let error):
                        self.handleError(response: response, error: error as NSError, callback: failure)
                    }
            }
        }
    }
    
    //MARK: Request Method to Send Request except in Multipart
    func request(isURLEncoded: Bool = false, cancelAllRequests: Bool = false, success: @escaping APIServiceSuccessCallback, failure: @escaping APIServiceFailureCallback) {
        do {
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            debugPrint("********************************* API Request **************************************")
            debugPrint("Request URL:\(path)")
            debugPrint("Request resource: \(resource)")
            debugPrint("************************************************************************************")
            
            var encoding: JSONEncoding = .default
            if isURLEncoded{
                encoding = .prettyPrinted
            }
            
            debugPrint("Request method: \(resource.method)")
            debugPrint("Request parameter:\(String(describing: resource.parameters))")
            debugPrint("Request encoding: \(encoding)")
            debugPrint("Request headers: \(String(describing: resource.headers))")
            if cancelAllRequests {
                Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                    tasks.forEach{ $0.cancel() }
                }
                if myRequest != nil {
                    myRequest!.cancel()
                }
                
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }

            }
//            var AFManager = SessionManager()
//            let configuration = URLSessionConfiguration.default
//            configuration.timeoutIntervalForRequest = 180 // seconds
////            configuration.timeoutIntervalForResource = 180 //seconds
//            AFManager = Alamofire.SessionManager(configuration: configuration)
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 180
            myRequest = manager.request(path, method: resource.method, parameters: resource.parameters, encoding: encoding, headers: resource.headers).validate().responseJSON(completionHandler: { (response) in
                debugPrint("********************************* API Response *************************************")
                debugPrint("\(response.debugDescription)")
                debugPrint("************************************************************************************")
                if Indicator.isEnabledIndicator {                       //ssk
                   // if AppDelegate.isLoaderNotHide{
                     //   AppDelegate.isLoaderNotHide = false
                   // } else {
                        Indicator.sharedInstance.hideIndicator()          //1f
                   // }
                }
                myRequest = nil
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch response.result {
                case .success(let value):
                    success(value as AnyObject?)
                    
                case .failure(let error):
                    self.handleError(response: response, error: error as NSError, callback: failure)
                }
            })
        }
    }
    
    //MARK: Request Method to Upload Multipart
    func uploadMultiple(imageDict:[String: Data]?, success:  @escaping APIServiceSuccessCallback, failure: @escaping APIServiceFailureCallback) {
        do {
            debugPrint("********************************* API Request **************************************")
            debugPrint("Request URL:\(path)")
            debugPrint("Request resource: \(resource)")
            debugPrint("image dictionary: \(String(describing: imageDict))")
            
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let urlRequest = createRequestWithMultipleImages(urlString: path, parameters: resource.parameters, imageDict: imageDict)
            
            
            Alamofire.upload((urlRequest?.1)!, with: (urlRequest?.0)!).uploadProgress(closure: { (progress) in
                print(progress.localizedDescription)
            }).responseJSON(completionHandler: { (response) in
                debugPrint("********************************* API Response *************************************")
                debugPrint("\(response.debugDescription)")
                debugPrint("************************************************************************************")
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch response.result {
                case .success(let value):
                    success(value as AnyObject?)
                case .failure(let error):
                    self.handleError(response: response, error: error as NSError, callback: failure)
                }
            })
        }
    }
    
    func uploadMultipleArray(imageArray:[Data]?, imageName: String?, thumbNailArray:[Data]?, thumbNailName: String?, mediaType: MimeType = .image, success:  @escaping APIServiceSuccessCallback, failure: @escaping APIServiceFailureCallback) {
        do {
            debugPrint("********************************* API Request **************************************")
            debugPrint("Request URL:\(path)")
            debugPrint("Request resource: \(resource)")
            debugPrint("image Name: \(imageName ?? "")")
            debugPrint("image dictionary: \(String(describing: imageArray))")
            
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let urlRequest = createArrayRequestWithMultipleImages(urlString: path, parameters: resource.parameters, imageArray: imageArray, imageName: imageName, mediaType: mediaType, thumbNailArray:thumbNailArray, thumbNailName: thumbNailName)
            Alamofire.upload((urlRequest?.1)!, with: (urlRequest?.0)!).uploadProgress(closure: { (progress) in
                print(progress.localizedDescription)
            }).responseJSON(completionHandler: { (response) in
                debugPrint("********************************* API Response *************************************")
                debugPrint("\(response.debugDescription)")
                debugPrint("************************************************************************************")
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch response.result {
                case .success(let value):
                    success(value as AnyObject?)
                case .failure(let error):
                    self.handleError(response: response, error: error as NSError, callback: failure)
                }
            })
        }
    }
    
    func createArrayRequestWithMultipleImages(urlString:String, parameters:[String : Any]?, imageArray: [Data]?, imageName: String?, mediaType: MimeType, thumbNailArray:[Data]?, thumbNailName: String?) -> (URLRequestConvertible, Data)? {
        
        // create url request to send
        var mutableURLRequest = URLRequest(url: NSURL(string: urlString)! as URL)
        mutableURLRequest.httpMethod = resource.method.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        var uploadData = Data()
        if parameters != nil {
            for (key, value) in parameters! {
                uploadData.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        if imageArray != nil {
            
            var type = "png"
            if mediaType == .video {
                type = "mov"
            }
            
            for image in imageArray! {
                uploadData.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(imageName!)[]\"; filename=\"\(imageName!).\(type)\"\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Type: \(mediaType.rawValue)\r\n\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append(image)
                uploadData.append("\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        if thumbNailArray != nil {
            for image in thumbNailArray! {
                uploadData.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(thumbNailName!)[]\"; filename=\"\(thumbNailName!).png\"\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append(image)
                uploadData.append("\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        uploadData.append("--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        do {
            let result = try Alamofire.URLEncoding.default.encode(mutableURLRequest, with: nil)
            return (result, uploadData)
        }
        catch _ {
        }
        
        return nil
    }
    
    
    func createRequestWithMultipleImages(urlString:String, parameters:[String : Any]?, imageDict: [String: Data]?) -> (URLRequestConvertible, Data)? {
        
        // create url request to send
        var mutableURLRequest = URLRequest(url: NSURL(string: urlString)! as URL)
        mutableURLRequest.httpMethod = resource.method.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if resource.headers != nil {
            for (key, value) in resource.headers! {
                mutableURLRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        
        // create upload data to send
        var uploadData = Data()
        if parameters != nil {
            for (key, value) in parameters! {
                uploadData.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        if imageDict != nil {
            for (key, value) in imageDict! {
                uploadData.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).png\"\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append(value)
                uploadData.append("\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        uploadData.append("--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        do {
            let result = try Alamofire.URLEncoding.default.encode(mutableURLRequest, with: nil)
            return (result, uploadData)
        }
        catch _ {
        }
        
        return nil
    }
    
    //MARK: Data Handling
    // Convert from NSData to json object
    private func JSONFromData(data: NSData) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
        } catch let myJSONError {
            debugPrint(myJSONError)
        }
        return nil
    }
    
    // Convert from JSON to nsdata
    private func nsdataFromJSON(json: AnyObject) -> NSData?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
        } catch let myJSONError {
            debugPrint(myJSONError)
        }
        return nil;
    }
    
    //MARK: Error Handling
    private func handleError(response: DataResponse<Any>?, error: NSError, callback:APIServiceFailureCallback) {
        print(response?.response?.statusCode ?? "")
        if let errorCode = response?.response?.statusCode {
            guard let responseJSON = self.JSONFromData(data: (response?.data)! as NSData) else {
                callback(NetworkErrorReason.FailureErrorCode(code: errorCode, message:""), error)
                debugPrint("Couldn't read the data")
                return
            }
            let message = (responseJSON as? NSDictionary)?["message"] as? String ?? "Something went wrong. Please try again!."
            callback(NetworkErrorReason.FailureErrorCode(code: errorCode, message: message), error)
        }
        else {
            let customError = NSError(domain: "Network Error", code: error.code, userInfo: error.userInfo)
            print((response?.result.error?.localizedDescription)! as String)
            
            if let message = response?.result.error?.localizedDescription , message == "A server with the specified hostname could not be found." {
                callback(NetworkErrorReason.FailureErrorCode(code: 101, message: message), error)   //New
                return
            }
            
            if let errorCode = response?.result.error?.localizedDescription , errorCode == "The Internet connection appears to be offline." {
                callback(NetworkErrorReason.InternetNotReachable, customError)
                if !Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
            }
            else {
                callback(NetworkErrorReason.FailureErrorCode(code: error.code, message: error.localizedDescription), error)
            }
        }
    }
}

//MARK: API Manager Class
class APIManager {
    class func errorForNetworkErrorReason(errorReason: NetworkErrorReason) -> NSError {
        var error: NSError!
        
        switch errorReason {
        case .InternetNotReachable:
            error = NSError(domain: "No Internet", code: -1, userInfo: ["message" : "The Internet connection appears to be offline."])
        case .UnAuthorizedAccess:
            error = NSError(domain: "Authorization Failed", code: 0, userInfo: ["message" : "Please Re-login to the app."])
        case let .FailureErrorCode(code, message):
            switch code {
            case 500:
                error = NSError(domain: "Server Error", code: code, userInfo: ["message" : message])
            case 400:
                error = NSError(domain: "Error", code: code, userInfo: ["message" : message])
            case 101:
                error = NSError(domain: "Error", code: code, userInfo: ["message" : message])
            case 404:
                error = NSError(domain: "Error", code: code, userInfo: ["message" : "Please Enter Valid Site Name"])
            default:
                error = NSError(domain: "Please try again!", code: code, userInfo: ["message" : message])
            }
            
        case .Other:
            error = NSError(domain: "Error", code: 0, userInfo: ["message" : "Please check your internet connection!!"])
        }
        return error
    }
}

//MARK: Indicator Class
public class Indicator {
    
    public static let sharedInstance = Indicator()
    var blurImg = UIImageView()
    var GifImg = UIImageView()
    var GifMobyImg = UIImageView()
    var indicator = UIActivityIndicatorView()
    static var isEnabledIndicator = true
    var cancelBtn = UIButton()
    var lblIngenico = UILabel()
    weak var delegate: CancelPAXDelegate?
    static var isLoaderScreenSaver = false
    var EMVGifImg = UIImageView()
    var blurImgGif = UIImageView()
    private init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        let jeremyGif = UIImage.gifImageWithName("PAX-loader-pos-fontNew")
        GifImg = UIImageView(image: jeremyGif)
        GifImg.frame = CGRect(x: 200, y: 200, width: 210, height: 170)
        GifImg.center = blurImg.center
        createCancelButton()
        createLableIngenicoMsg()
        blurImgGif.frame = UIScreen.main.bounds
        blurImgGif.backgroundColor = UIColor.black
        blurImgGif.isUserInteractionEnabled = true
        blurImgGif.alpha = 0.5
        let jeremyGif1 = UIImage.gifImageWithName("PAX-loader-pos-fontNew")
        EMVGifImg = UIImageView(image: jeremyGif1)
        EMVGifImg.frame = CGRect(x: 200, y: 200, width: 210, height: 170)
        EMVGifImg.center = blurImg.center
        
        let jeremyGif2 = UIImage.gifImageWithName("loader7")
        GifMobyImg = UIImageView(image: jeremyGif2)
        GifMobyImg.frame = CGRect(x: 200, y: 200, width: 210, height: 210)
        GifMobyImg.center = blurImg.center
    }
    
    func showIndicator(){
        DispatchQueue.main.async( execute: {
            Indicator.isLoaderScreenSaver = true
            self.blurImg.frame = UIScreen.main.bounds
            self.indicator.center = self.blurImg.center
            UIApplication.shared.keyWindow?.addSubview(self.blurImg)
            UIApplication.shared.keyWindow?.addSubview(self.indicator)
        })
    }
    
   func showIndicatorGif(_ cancelButtonShow: Bool = false){
        DispatchQueue.main.async( execute: {
            Indicator.isLoaderScreenSaver = true
            self.blurImg.alpha = 0.7
            self.blurImg.frame = UIScreen.main.bounds
            self.GifImg.center = self.blurImg.center
            
            UIApplication.shared.keyWindow?.addSubview(self.blurImg)
            UIApplication.shared.keyWindow?.addSubview(self.GifImg)
            if cancelButtonShow {
                self.cancelBtn.frame = CGRect(x: self.GifImg.frame.origin.x + 55, y: self.GifImg.frame.origin.y + 160, width: 100, height: 50)
                UIApplication.shared.keyWindow?.addSubview(self.cancelBtn)
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    self.lblIngenico.frame = CGRect(x: self.GifImg.frame.origin.x - 125, y: self.blurImg.frame.size.height - 150, width: 250, height: 50)
                    self.lblIngenico.center = CGPoint(x: self.blurImg.frame.size.width/2, y:self.blurImg.frame.size.height - 200 )
                }else {
                    self.lblIngenico.frame = CGRect(x: self.GifImg.frame.origin.x - 125, y: self.blurImg.frame.size.height - 150, width: 250, height: 50)
                    self.lblIngenico.center = CGPoint(x: self.blurImg.frame.size.width/2, y:self.blurImg.frame.size.height - 150 )
                }
                UIApplication.shared.keyWindow?.addSubview(self.lblIngenico)
            } else {
                self.cancelBtn.removeFromSuperview()
                self.lblIngenico.removeFromSuperview()
            }
        })
    }
    
    func showIndicatorforMoby(){
         DispatchQueue.main.async( execute: {
             Indicator.isLoaderScreenSaver = true
             self.blurImg.alpha = 0.7
             self.blurImg.frame = UIScreen.main.bounds
             self.GifMobyImg.center = self.blurImg.center
             
             UIApplication.shared.keyWindow?.addSubview(self.blurImg)
             UIApplication.shared.keyWindow?.addSubview(self.GifMobyImg)
         })
     }
    
    func showIndicatorGifEMV(_ cancelButtonShow: Bool = false){
        DispatchQueue.main.async( execute: {
            Indicator.isLoaderScreenSaver = true
           
            self.EMVGifImg.center = self.blurImg.center
            self.blurImgGif.alpha = 0.7
            self.blurImgGif.frame = UIScreen.main.bounds
            UIApplication.shared.keyWindow?.addSubview(self.blurImgGif)
            
            UIApplication.shared.keyWindow?.addSubview(self.EMVGifImg)
            if cancelButtonShow {
                self.cancelBtn.frame = CGRect(x: self.EMVGifImg.frame.origin.x + 55, y: self.EMVGifImg.frame.origin.y + 160, width: 100, height: 50)
                UIApplication.shared.keyWindow?.addSubview(self.cancelBtn)
            } else {
                self.cancelBtn.removeFromSuperview()
            }
        })
    }
    func hideIndicator(){
        DispatchQueue.main.async( execute: {
            Indicator.isLoaderScreenSaver = false
            self.blurImg.removeFromSuperview()
            self.indicator.removeFromSuperview()
            self.GifImg.removeFromSuperview()
            self.cancelBtn.removeFromSuperview()
            self.lblIngenico.removeFromSuperview()
            self.GifMobyImg.removeFromSuperview()
        })
    }
    func hideGif(){
        self.blurImgGif.removeFromSuperview()
       // self.indicator.removeFromSuperview()
        self.EMVGifImg.removeFromSuperview()
        self.cancelBtn.removeFromSuperview()
        self.GifMobyImg.removeFromSuperview()
    }
    func createCancelButton(){
        cancelBtn = UIButton(frame: CGRect(x: GifImg.frame.origin.x , y: GifImg.frame.origin.y + 210 , width: 100, height: 50))
        //CGRect(x: self.GifImg.frame.origin.x + 210, y: self.GifImg.frame.origin.y , width: 100, height: 50)
        cancelBtn.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
        cancelBtn.cornerRadius = 4.0
        // self.button.center = self.blurImg.center
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        
    }
    
    func createLableIngenicoMsg(){
        lblIngenico = UILabel(frame: CGRect(x: GifImg.frame.origin.x , y: GifImg.frame.origin.y + 100 , width: 300, height: 50))
        //CGRect(x: self.GifImg.frame.origin.x + 210, y: self.GifImg.frame.origin.y , width: 100, height: 50)
        lblIngenico.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lblIngenico.textColor = .white
        lblIngenico.cornerRadius = 25.0
        lblIngenico.textAlignment = .center
        // self.button.center = self.blurImg.center
        lblIngenico.text = ""
    }

    @objc func buttonClicked() {
        print("Button Clicked")
        delegate?.didCancelPAX()
    }
}


//MARK: ScreenSaver Class
public class ScreenSaver {
    
    public static let sharedInstance = ScreenSaver()
    var blurImg = UIImageView()
    var GifImg = UIImageView()
    static var isEnabledIndicator = true
   
    var label = UILabel()
    
    private init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        
        let jeremyGif = UIImage.gifImageWithName("capital-pos-gif")
        GifImg = UIImageView(image: jeremyGif)
        GifImg.frame = CGRect(x: 0, y: 0, width: 210, height: 210)
        GifImg.center = blurImg.center
        createLable()
    }
    
    func showScreenSaver() {
        DispatchQueue.main.async( execute: {
            self.blurImg.alpha = 0.9
            self.blurImg.frame = UIScreen.main.bounds
            
            //  self.label.frame =  CGRect(x: 0 , y: 0 , width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            //  self.label.textAlignment = .center
            self.label.center = self.blurImg.center
            UIApplication.shared.keyWindow?.addSubview(self.blurImg)
            UIApplication.shared.keyWindow?.addSubview(self.label)
        })
    }
    
    func hideIndicator(){
        DispatchQueue.main.async( execute: {
            self.blurImg.removeFromSuperview()
            self.GifImg.removeFromSuperview()
        })
    }
    
    func hideScreenSaver(){
        DispatchQueue.main.async( execute: {
            self.blurImg.removeFromSuperview()
            self.label.removeFromSuperview()
            self.GifImg.removeFromSuperview()
        })
    }
    
    func createLable(){
        label.frame = CGRect(x: blurImg.frame.size.width / 2 - 100, y: blurImg.frame.size.height / 2, width: 210, height: 170)
        label.text = "HieCOR"
        label.textColor = UIColor.white
        self.label.textAlignment = .center
        label.font = UIFont.init(name: "OpenSans", size: 35)
        label.center = blurImg.center
    }
    func showIndicatorGif(){
           DispatchQueue.main.async( execute: {
             //  Indicator.isLoaderScreenSaver = true
               //Indicator.isGifLoaderScreenSaver = true
              // self.GifImg.alpha = 0.4
               self.blurImg.alpha = 0.9
               self.blurImg.frame = UIScreen.main.bounds
               self.blurImg.frame = UIScreen.main.bounds
               self.GifImg.center = self.GifImg.center
               UIApplication.shared.keyWindow?.addSubview(self.blurImg)
               UIApplication.shared.keyWindow?.addSubview(self.GifImg)
           })
       }


}
