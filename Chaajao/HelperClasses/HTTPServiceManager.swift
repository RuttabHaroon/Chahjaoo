import UIKit
import Alamofire
open class HTTPServiceManager: NSObject {
    
    public static let sharedInstance = HTTPServiceManager();
    
    var _requests:[String:HTTPRequest] = [:];
    var _headers:HTTPHeaders = HTTPHeaders();
	var _hudRetainCount:Int = 0;
    var _showProgressBlock:(()->Void)?
    var _hideProgressBlock:(()->Void)?
    var _failureBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?
    var _invalidSessionBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?
	var _serverBaseURL:URL!;
	open class var serverBaseURL:URL {
		get {
			return self.sharedInstance._serverBaseURL;
		}
		set {
			self.sharedInstance._serverBaseURL = newValue;
		}
	} //P.E.
    override init() {}
    
    //MARK: - Initialize
    open class func initialize(serverBaseURL:String) {
        self.sharedInstance.initialize(serverBaseURL: serverBaseURL)
    } //F.E.
    
    func initialize(serverBaseURL:String) {
        //Base Server URL
        _serverBaseURL = URL(string: serverBaseURL)!;
        _headers["Content-Type"] = "application/json"
        _headers["accept"] = "text/plain"

    } //F.E.
    
    //MARK: - Progress Bar Handling
    open class func setupProgressHUD(showProgress:@escaping ()->Void, hideProgress :@escaping ()->Void) {
        HTTPServiceManager.sharedInstance.setupProgressHUD(showProgress: showProgress, hideProgress: hideProgress);
    } //F.E.
    
    open func setupProgressHUD(showProgress:@escaping ()->Void, hideProgress:@escaping ()->Void) {
        //Show Progress Block
        _showProgressBlock = showProgress;
        
        //Hide Progress Block
        _hideProgressBlock = hideProgress;
    } //F.E.
    
    open class func onShowProgress(showProgress:@escaping ()->Void) {
        HTTPServiceManager.sharedInstance.onShowProgress(showProgress: showProgress);
    } //F.E.
    
    func onShowProgress(showProgress:@escaping ()->Void) {
        _showProgressBlock = showProgress;
    } //F.E.
    
    open class func onHideProgress(hideProgress:@escaping ()->Void) {
        HTTPServiceManager.sharedInstance.onHideProgress(hideProgress: hideProgress);
    } //F.E.
    
    func onHideProgress(hideProgress:@escaping ()->Void) {
        _hideProgressBlock = hideProgress;
    } //F.E.
    
    func  showProgressHUD() {
        if (_hudRetainCount == 0) {
            _showProgressBlock?();
        }
        //--
        _hudRetainCount += 1;
    } //F.E.
    
    func hideProgressHUD() {
        if _hudRetainCount > 0 {
            _hudRetainCount -= 1;
        }
        
        //--
        if (_hudRetainCount == 0) {
            _hideProgressBlock?();
        }
    } //F.E.
    
    //MARK: - Failure Default Response Handling
    open class func onFailure(failureBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?) {
        HTTPServiceManager.sharedInstance.onFailure(failureBlock: failureBlock);
    } //F.E.
    
    func onFailure(failureBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?) {
        _failureBlock = failureBlock;
    } //F.E.
    
    open class func onInvalidSession(invalidSessionBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?) {
        HTTPServiceManager.sharedInstance.onInvalidSession(invalidSessionBlock: invalidSessionBlock);
    } //F.E.
    
    func onInvalidSession(invalidSessionBlock:((_ httpRequest:HTTPRequest, _ error:NSError)->Void)?) {
        _invalidSessionBlock = invalidSessionBlock;
    } //F.E.
    
    //MARK: - Requests Handling
    //MARK: - Requests Handling
    @discardableResult
    open class func request(requestName:String, parameters:[String:Any]?, delegate:HTTPRequestDelegate?, otherData:Any?, encoding: ParameterEncoding) -> HTTPRequest {
        return self.request(requestName: requestName, parameters: parameters, method: .post, showHud: true, delegate: delegate, otherData:otherData, encoding: encoding);
    }
    
    @discardableResult
    open class func request(requestName:String, parameters:[String:Any]?, showHud:Bool,method:HTTPMethod, delegate:HTTPRequestDelegate?, otherData:Any?, encoding: ParameterEncoding) -> HTTPRequest {
        return self.request(requestName: requestName, parameters: parameters, method:method, showHud: showHud, delegate: delegate, otherData:otherData, encoding: encoding);
    } //F.E.
    
    //updated
    @discardableResult
    open class func request(requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?, otherData:Any?, encoding: ParameterEncoding, headers:HTTPHeaders) -> HTTPRequest {
        return HTTPServiceManager.sharedInstance.request(requestName: requestName, parameters: parameters, method: method, showHud:showHud, delegate:delegate, otherData:otherData, encoding: encoding, headers: headers);
    } //F.E.
    
    
    @discardableResult
    open class func request(requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?, otherData:Any?, encoding: ParameterEncoding) -> HTTPRequest {
        return HTTPServiceManager.sharedInstance.request(requestName: requestName, parameters: parameters, method: method, showHud:showHud, delegate:delegate, otherData:otherData, encoding: encoding);
    } //F.E.
    func request(requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?, otherData:Any?, encoding: ParameterEncoding) -> HTTPRequest {
        var httpRequest : HTTPRequest!
		httpRequest = HTTPRequest(requestName: requestName, parameters: parameters, method: method, headers: nil, otherData:otherData, encoding: encoding);

        
        httpRequest.delegate = delegate;
        httpRequest.hasProgressHUD = showHud;
        
        self.request(httpRequest: httpRequest);
        
        return httpRequest;
    } //F.E.
    
    //updated
    func request(requestName:String, parameters:[String:Any]?, method:HTTPMethod, showHud:Bool, delegate:HTTPRequestDelegate?, otherData:Any?, encoding: ParameterEncoding, headers:HTTPHeaders) -> HTTPRequest {
        var httpRequest : HTTPRequest!
        httpRequest = HTTPRequest(requestName: requestName, parameters: parameters, method: method, headers: headers, otherData:otherData, encoding: encoding);

        
        httpRequest.delegate = delegate;
        httpRequest.hasProgressHUD = showHud;
        
        self.request(httpRequest: httpRequest);
        
        return httpRequest;
    } //F.E.
    
    public func request(httpRequest:HTTPRequest) {
        
        //Validation for internet connection
		delay(0.1, closure: {
			let returnedTupple = httpRequest.sendRequest()
			if let request = returnedTupple[1] as? DataRequest {
				request.responseString(queue: nil) {
					(response:DataResponse<String>) -> Void in
					self.responseResult(httpRequest: httpRequest, response: response);
				}
			}

			let evaluationResult = (returnedTupple[0] as! Bool)
			//Request Did Start
			if evaluationResult {
				self.requestDidStart(httpRequest: httpRequest);
			}
		})
    } //F.E.
    
    func retryRequest (httpRequest: HTTPRequest ) {
		delay(0.1, closure: {
			let returnedTupple = httpRequest.sendRequest()

			if let request = returnedTupple[1] as? DataRequest {
				request.responseString(queue: nil) {
					(response:DataResponse<String>) -> Void in
					self.responseResult(httpRequest: httpRequest, response: response);
				}
			}

			let evaluationResult = (returnedTupple[0] as! Bool)
			//Request Did Start
			if evaluationResult {
				self.requestDidStart(httpRequest: httpRequest);
			}
		})
    }
    //MARK: - Response Handling
    func responseResult(httpRequest:HTTPRequest, response:DataResponse<String>) {
        print("---------------------------------------------------------------------------")
        switch response.result {
            case .success:
				//#if DEBUG
                print("\nResponse Result: Success\nStatus Code: \(String(response.response?.statusCode ?? -1))\n\nURL: \(httpRequest.urlString)\n")
				if !httpRequest.cancelled {
					do {
						if let json = response.result.value!.data(using: String.Encoding.utf8) {
							if let dictData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject] {
								self.requestDidSucceedWithData(httpRequest: httpRequest, data: dictData)
							}
						}
					} catch {
						//#if DEBUG
						print("error.localizedDescription \(error.localizedDescription)")
						self.requestDidFailWithError(httpRequest: httpRequest, error: error as NSError)
						//#endif
					}
				}
				//#endif
            case .failure (let err):
                if httpRequest.cancelled {
                    APP_DELEGATE.initializeNetworkManager()
                }
				let errorCode:Int = (err as? AFError)?.responseCode ?? -1;
				let userInfo = [NSLocalizedDescriptionKey: err.localizedDescription]
				let error = NSError(domain: "domain", code: errorCode, userInfo: userInfo);

				if _requests.count == 1 {
//					_ = ExertUtility.messagePopup(message: "The Internet connection appears to be offline.")
				}
				self.requestDidFailWithError(httpRequest: httpRequest, error: error);
                if _requests.count == 0 {
                    hideProgressHUD()
                    _hudRetainCount = 0
                }
        }
        print("---------------------------------------------------------------------------")
    } //F.E.
    
    func requestDidSucceedWithData(httpRequest: HTTPRequest, data:Any?) {
        httpRequest.didSucceedWithData(data: data);
        
        //Did Finish
        self.requestDidFinish(httpRequest: httpRequest);
    } //F.E.
    
    func requestDidFailWithError(httpRequest:HTTPRequest, error:NSError) {
        if (httpRequest.didFailWithError(error: error) == false) {
            _failureBlock?(httpRequest, error);
        }
        
        //Did Finish
        self.requestDidFinish(httpRequest: httpRequest);
    } //F.E.
    
    func requestDidFailWithInvalidSession(httpRequest:HTTPRequest, error:NSError) {
        if (httpRequest.didFailWithInvalidSession(error: error) == false) {
            _invalidSessionBlock?(httpRequest, error);
        }
        
        //Did Finish
        self.requestDidFinish(httpRequest: httpRequest);
    } //F.E.
    
    func requestDidStart(httpRequest:HTTPRequest) {
        if (httpRequest.hasProgressHUD) {
            //--
            self.showProgressHUD();
        }
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        
        
        //Holding reference
        _requests[httpRequest.requestName] = httpRequest;
    } //F.E.
    
    func requestDidFinish(httpRequest:HTTPRequest) {
        if (httpRequest.hasProgressHUD) {
            //--
            self.hideProgressHUD();
        }
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false;
        
        _requests.removeValue(forKey: httpRequest.requestName);
    } //F.E.
    
    //MARK: - Cancel Request Handling
    open class func cancelRequest(requestName:String) {
        self.sharedInstance.cancelRequest(requestName: requestName);
    } //F.E.
    
    func isRunningRequest(requestName:String)->Bool {
        if  _requests.keys.contains(requestName) {
            return true
        }else {
            return false
        }
    } //F.E.
    
    
    func cancelRequest(requestName:String) {
        if let httpRequest:HTTPRequest = _requests[requestName] {
            httpRequest.cancel();
            //--
            self.requestDidFinish(httpRequest: httpRequest);
        }
    } //F.E.
    
    
    open class func cancelAllRequests() {
        self.sharedInstance.cancelAllRequests();
    } //F.E.
    
    func cancelAllRequests() {
        if _requests.count > 0 {
            for (_, httpRequest) in _requests {
                httpRequest.cancel();
                //--
                self.requestDidFinish(httpRequest: httpRequest);
            }
            DispatchQueue.main.async {
                self._hudRetainCount = 0
            }
        }
    }
    //F.E.
    
} //CLS END

@objc public protocol HTTPRequestDelegate {
    @objc optional func requestDidSucceedWithData(httpRequest:HTTPRequest, data:Any?);
    @objc optional func requestDidFailWithError(httpRequest:HTTPRequest, error:NSError);
    @objc optional func requestDidFailWithInvalidSession(httpRequest:HTTPRequest, error:NSError);
    
    @objc optional func imageUploadRequestDidSucceedWithData(data:[String: String]?);
    @objc optional func imageUploadRequestDidFailWithError(error:NSError);
} //P.E.

open class HTTPRequest:NSObject {
    
    open var requestName:String!
    open var encoding: ParameterEncoding!
    open var otherData:Any?
    open var parameters:Parameters?
    open var method:HTTPMethod = .post
    
    var _urlString:String?
    open var urlString:String {
        get {
            if (_urlString == nil && requestName.contains("http://66.135.44.131:91/api/")) {
                _urlString = requestName
            }
            else if (_urlString == nil && !requestName.contains("ipify") && !requestName.contains("youtube")) {
                _urlString = HTTPServiceManager.serverBaseURL.appendingPathComponent(requestName).absoluteString;
            } else if(requestName.contains("ipify") || requestName.contains("youtube")) {
                _urlString = requestName
            }
            //--
            return _urlString!;
        }
        
        set {
            _urlString = newValue;
        }
    } //P.E.
    
    open var headers:HTTPHeaders?
    
    weak var request:DataRequest?;
    
    open override var description: String {
        get {
            return "[HTTPRequest] [\(method)] \(requestName as String): \((_urlString ?? "") as String)";
        }
    } //P.E.
    
    open var hasProgressHUD:Bool = true;
    
    var _successBlock:((_ httpRequest: HTTPRequest, _ data:Any?) -> Void)?
    var _failureBlock:((_ httpRequest: HTTPRequest, _ error:NSError) -> Void)?
    var _invalidSessionBlock:((_ error:NSError) -> Void)?
    
    var _progressBlock:Request.ProgressHandler?
    
    open weak var delegate:HTTPRequestDelegate?;
    
    var _cancelled:Bool = false;
    var cancelled:Bool {
        get {
            return _cancelled;
        }
    } //P.E.
    
    private override init() {
        super.init();

    } //C.E.
    
    public init(requestName:String, parameters:Parameters?, method:HTTPMethod, headers: HTTPHeaders? = nil, otherData:Any?, encoding: ParameterEncoding) {
        super.init();
        //--
        self.requestName = requestName;
        self.parameters = parameters;
        self.method = method;
        self.headers = headers
        self.otherData = otherData
        self.encoding = encoding
		//MARK:- SSL Pinning configuration

		if APP_DELEGATE.manager == nil {
			if isPinningEnabled {
				//MARK: For Certificate Pinning
//				configureAlamoFireSSLPinning()
			} else {
				//MARK: For default AF config
				APP_DELEGATE.manager = Alamofire.SessionManager()
			}
			//MARK: For no evaluation
			//configureForNoEvaluation()
		}
    } //C.E.

	
//	func configureAlamoFireSSLPinning() {
//		let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
//			certificates: [Certificates.certificate],
//			validateCertificateChain: true,
//			validateHost: true
//		)
//
//		let serverTrustPolicies: [String: ServerTrustPolicy] = [
//			URL(string: baseURL)!.host!: serverTrustPolicy
//		]
//
//		APP_DELEGATE.serverTrustPoliciesManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
//
//		let configuration = URLSessionConfiguration.default
//		configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//		APP_DELEGATE.manager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: APP_DELEGATE.serverTrustPoliciesManager)
//	}


	func configureForNoEvaluation() {
		let serverTrustPolicies: [String: ServerTrustPolicy] = [
			URL(string: baseURL)!.host!: .disableEvaluation
		]
		APP_DELEGATE.serverTrustPoliciesManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
		let configuration = URLSessionConfiguration.default
		configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
		APP_DELEGATE.manager = Alamofire.SessionManager(
			configuration: configuration,
			serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
		)
	}

    open func sendRequest() -> [Any] {
        
        //#if DEBUG
        print("---------------------------------------------------------------------------")
        print("URL: \(self.urlString)")
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self.self.headers ?? [String:Any](),
            options: [.prettyPrinted]) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("\nHeaders:\n\(theJSONText!)")
        }
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self.parameters ?? [String:Any](),
            options: [.prettyPrinted]) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("\nParameters:\n\(theJSONText!)\n")
        }
        print("---------------------------------------------------------------------------")
        //#endif
		var evaluationResult = false
		if isPinningEnabled {
			evaluationResult = evaluateHost(urlString: urlString)
		} else {
			evaluationResult = true
		}

		if evaluationResult {
			self.request = APP_DELEGATE.manager.request(self.urlString, method:self.method, parameters: self.parameters, encoding: encoding, headers: self.headers ?? nil).validate()
		} else {
			HTTPServiceManager.cancelAllRequests()
		}
		return [evaluationResult, request]
    } //F.E.
    
    //MARK: - Response Handling
    @discardableResult
    open func onSuccess(response:@escaping (_ httpRequest: HTTPRequest, _ data:Any?) -> Void) -> Self {
        _successBlock = response;
        return self;
    } //F.E.
    
    @discardableResult
    open func onFailure(response:@escaping (_ httpRequest: HTTPRequest, _ error:NSError) -> Void) -> Self {
        _failureBlock = response;
        return self;
    } //F.E.
    
    @discardableResult
    open func onInvalidSession(response:@escaping (_ error:NSError) -> Void) -> Self {
        _invalidSessionBlock = response;
        return self;
    } //F.E.
    
    @discardableResult
    open func uploadProgress(closure: @escaping Request.ProgressHandler) -> Self {
        _progressBlock = closure;
        
        (self.request as? UploadRequest)?.uploadProgress(closure: closure);
        return self
    }
    
    @discardableResult
    func didSucceedWithData(data:Any?) -> Bool {
        guard (_cancelled == false) else {
            return true;
        }
        
        _successBlock?(self, data);
        //--
        self.delegate?.requestDidSucceedWithData?(httpRequest: self, data: data);
        
        return ((_successBlock != nil) || (self.delegate?.requestDidSucceedWithData != nil));
    } //F.E.
    
    @discardableResult
    func didFailWithError(error:NSError) -> Bool {
        guard (_cancelled == false) else {
            return true;
        }
        
        _failureBlock?(self, error);
        //--
        if error.code != 1 {
            delegate?.requestDidFailWithError?(httpRequest: self, error: error);
        }
        
        return ((_failureBlock != nil) || (self.delegate?.requestDidFailWithError != nil));
    } //F.E.
    
    @discardableResult
    func didFailWithInvalidSession(error:NSError) -> Bool {
        guard (_cancelled == false) else {
            return true;
        }
        
        _invalidSessionBlock?(error);
        //--
        delegate?.requestDidFailWithInvalidSession?(httpRequest: self, error: error);
        
        return ((_invalidSessionBlock != nil) || (self.delegate?.requestDidFailWithInvalidSession != nil));
    } //F.E.
    
    //MARK: - Cancel
    open func cancel() {
        //Flaging On
        _cancelled = true;
        
        //Cancelling the request
        request?.cancel();
    } //F.E.
    
    
    deinit {
    }
    
} //CLS END

public extension Data {
    var mimeType:String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
                case 0xFF:
                    return "image/jpeg";
                case 0x89:
                    return "image/png";
                case 0x47:
                    return "image/gif";
                case 0x49, 0x4D:
                    return "image/tiff";
                case 0x25:
                    return "application/pdf";
                case 0xD0:
                    return "application/vnd";
                case 0x46:
                    return "text/plain";
                default:
                    //print("mimeType for \(c[0]) in available");
                    return "application/octet-stream";
            }
        }
    } //F.E.
    
    var stringExtension:String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
                case 0xFF:
                    return "jpeg";
                case 0x89:
                    return "png";
                case 0x47:
                    return "gif";
                case 0x49, 0x4D:
                    return "tiff";
                case 0x25:
                    return "pdf";
                case 0xD0:
                    return "vnd";
                case 0x46:
                    return "txt";
                default:
                    //print("mimeType for \(c[0]) in available");
                    return "octet-stream";
            }
        }
    } //F.E.
} //E.E.


extension HTTPServiceManager {
    class func imageUpload(imageoUpload: UIImage, requestURl : String, delegate: HTTPRequestDelegate) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageoUpload.jpegData(compressionQuality: 0.1)!, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
        }, usingThreshold: UInt64(), to: URL(string: NetworkClient.getAPIUrl(route: .updateProfilePicture))!, method: .post, headers: NetworkClient.APP_HEADERS_IMAGE_UPLOAD) { resultt in
            switch resultt {
            case .success(request: let upload, _, _):
                upload.responseJSON { rep in
                    if rep.result.value != nil
                   {
                       let dict :NSDictionary = rep.result.value! as! NSDictionary
                        let message = dict["message"] as? String ?? ""
                        if let r = dict["result"] as? [String: String] {
                            if let newUserPhoto = r["photo"] as? String {
                                delegate.imageUploadRequestDidSucceedWithData?(data: ["message": message, "photo": newUserPhoto])
                            }
                        }
                        print(dict)
                   }
                    else {
                        print("adsas")
                    }
                }
                break
            case .failure(let e):
                delegate.imageUploadRequestDidFailWithError?(error: e as NSError)
                break
            }
        }
    }
}
