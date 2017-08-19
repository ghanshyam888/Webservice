//
//  Webservice.swift
//  iMedSuite
//
//  Created by Ghanshyam on 18/02/16.
//  Copyright © 2016 CREDENCYS. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices


@objc protocol WebserviceDelegate {
    /// This will return response from webservice if request successfully done to server
    func webserviceResponseSuccess(response: NSDictionary, apiIdentifier: String)
    
    /// This will return response from webservice if request fail to server
    func webserviceResponseFail(response: NSDictionary, apiIdentifier: String)
    
    /// This is for Fail request or server give any error
    func webserviceResponseError(error: Error?, apiIdentifier: String)
    
    /// This is for attached any user data.
    @objc optional func webserviceResponseSuccessWithUserData(webservice : Webservice, response: NSDictionary, apiIdentifier: String)
    
    /// This will return response from webservice if request fail to server
    @objc optional func webserviceResponseFailWithUserData(webservice : Webservice,response: NSDictionary, apiIdentifier: String)
    
    /// This will return response from webservice if request successfully done to server
    @objc optional func webserviceResponseInArraySuccess(response: NSArray, apiIdentifier: String)
    
}


class Webservice: NSObject {
    
    //propetry
    var parmeters : NSDictionary!
    var apiIdentifier : String = ""
    var delegate : WebserviceDelegate?
    
    var userData : AnyObject!
    var flagValue : Bool = false
    
    //MARK:- RequestForGet
    /**
     Request using get method.
     - parameter strUrl :- Request URL
     */
    
    func RequestForGet(strUrl: String, apiIdentifier: String) -> Void {

        self.apiIdentifier = apiIdentifier
        let url = URL(string: strUrl)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let apiAuthToken = String(describing: Constant.defaults.object(forKey: "Token")!)
        request.setValue(apiAuthToken, forHTTPHeaderField: "tokenKey")
        request.setValue("31010", forHTTPHeaderField: "sourceSystemId")
        request.setValue(Constant.App_Version, forHTTPHeaderField: "appversion")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        httpResponse.addException(nil,strResponse: responseString! as String)
                    }
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if "\(responseDictionary.value(forKey: "status")!)" == "<null>"{
                        self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                        return
                    }
                    
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                    else {
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                        
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                            
                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            httpResponse.addException(nil,strResponse: responseString! as String)
                        }
                    }
                }
                if let responseArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                    self.delegate?.webserviceResponseInArraySuccess!(response: responseArray, apiIdentifier: self.apiIdentifier)
                }
            }
            catch {
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                //print("responseString = \(responseString!)")
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    httpResponse.addException(nil,strResponse: responseString!)
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
    
    func RequestForGetWithToken(strUrl: String, apiIdentifier: String) -> Void {
        self.apiIdentifier = apiIdentifier
        let apiAuthToken = String(describing: Constant.defaults.object(forKey: "Token")!)
        let url = URL(string: strUrl)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue(apiAuthToken, forHTTPHeaderField: "Token")
        request.setValue(apiAuthToken, forHTTPHeaderField: "tokenKey")
        request.setValue("31010",forHTTPHeaderField: "sourceSystemId")
        request.setValue(Constant.preferredBU,forHTTPHeaderField: "buId")
        request.setValue(Constant.MacUUID,forHTTPHeaderField: "macId")
        request.setValue(Constant.App_Version, forHTTPHeaderField: "appversion")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
		if httpResponse.statusCode != 200 {
                        
			let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
			httpResponse.addException(nil,strResponse: responseString! as String)
        }
	}
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    if self.apiIdentifier != "PortfolioSummary" {
                        
                        if "\(responseDictionary.value(forKey: "status")!)" == "<null>"{
                            self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                            return
                        }
                        
                        if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                            if self.delegate != nil {
                                self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                            }
                        }
                        else {
                            
                            if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                                
                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                httpResponse.addException(nil,strResponse: responseString! as String)
                            }
                            
                            
                            if self.delegate != nil {
                                self.delegate?.webserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                            }
                        }
                    }
                    else {
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                }
                if let responseArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                    self.delegate?.webserviceResponseInArraySuccess!(response: responseArray, apiIdentifier: self.apiIdentifier)
                }
            }
            catch {
                
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("responseString = \(responseString!)")
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    httpResponse.addException(nil,strResponse: responseString!)
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
    
    func RequestForGetWithHeader(strUrl: String, apiIdentifier: String) -> Void {
        self.apiIdentifier = apiIdentifier
        let apiAuthToken = String(describing: Constant.defaults.object(forKey: "Token")!)
        
        let url = URL(string: strUrl)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiAuthToken, forHTTPHeaderField: "Token")
        request.setValue("31010",forHTTPHeaderField: "sourceSystemId")
        request.setValue(Constant.preferredBU,forHTTPHeaderField: "buId")
        request.setValue(Constant.MacUUID,forHTTPHeaderField: "macId")
        request.setValue(Constant.App_Version, forHTTPHeaderField: "appversion")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                
        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
		if httpResponse.statusCode != 200 {
                        
			let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
			httpResponse.addException(nil,strResponse: responseString! as String)
        }
	}
                
        if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if "\(responseDictionary.value(forKey: "status")!)" == "<null>"{
                        self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                        return
                    }
                    
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                    else {
                        
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                                
                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                httpResponse.addException(nil,strResponse: responseString! as String)
                            }
                        
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                }
            }
            catch {
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    httpResponse.addException(nil,strResponse: responseString!)
                }
                
                print("responseString = \(responseString!)")
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
    
    //MARK:- RequestForPostAndFile
    /**
     Request using post method,with user reuired to pass parameter and file on server with multipart form.
     - parameter strUrl     :- Request URL
     - parameter postData   :- parameter for send to server.
     - parameter filePathKey :- name of parameter, which will be used for store file on server DB. (i.e Image)
     - parameter filePath   :- location of file, which will be stored on document directory.
     */
    func RequestForPostAndFile(strUrl:String, postData:NSDictionary, filePathKey:String, filePath:String, apiIdentifier: String) -> Void {
        self.apiIdentifier = apiIdentifier
        parmeters = postData
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: strUrl)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParametersAndFile(parameters: postData, filePathKey: filePathKey, paths: filePath,boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode != 200 {
                        
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        httpResponse.addException(nil,strResponse: responseString! as String)
                    }
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if "\(responseDictionary.value(forKey: "status")!)" == "<null>"{
                        self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                        return
                    }
                    
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                    else {
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                                
                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                httpResponse.addException(nil,strResponse: responseString! as String)
                            }
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                }
            }
            catch {
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("responseString = \(responseString!)")
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    httpResponse.addException(nil,strResponse: responseString!)
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
    
    //MARK:- RequestForPostWithMultipleFile
    /**
     Request using post method,with user reuired to pass parameter and file's on server with multipart form.
     - parameter strUrl     :- Request URL
     - parameter postData   :- parameter for send to server.
     - parameter filePathKey :- name of parameter, which will be used for store file on server DB. (i.e Image)
     - parameter aryFilesPath   :- location of file, which will be stored on document directory.
     */
    func RequestForPostWithMultipleFile(strUrl:String, postData:NSDictionary, aryFilesKey:NSArray, aryFilesPath:NSArray, apiIdentifier: String) -> Void {
        self.apiIdentifier = apiIdentifier
        parmeters = postData
        
        let boundary = generateBoundaryString()
        let url = URL(string: strUrl)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        if postData.count > 0 {
            for (key, value) in postData {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        if aryFilesPath.count > 0  && aryFilesPath.count == aryFilesKey.count{
            for i in 0 ..< aryFilesPath.count {
                let filePath = aryFilesPath[i] as! String
                let fileManager = FileManager.default
                let fileUrl = URL(fileURLWithPath:filePath)
                if (fileManager.fileExists(atPath: filePath)){
                    var data = Data()
                    do {
                        data = try Data(contentsOf: fileUrl)
                    }
                    catch {
                    }
                    let mimeType = self.mimeTypeForPath(path: aryFilesPath[i] as! String)
                    
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(aryFilesKey[i])\"; filename=\"\(filePath)\"\r\n")
                    body.appendString(string: "Content-Type: \(mimeType)\r\n\r\n")
                    body.append(data)
                    body.appendString(string: "\r\n")
                }
            }
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        request.httpBody = body as Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode != 200 {
                        
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        httpResponse.addException(nil,strResponse: responseString! as String)
                    }
                }
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if "\(responseDictionary.value(forKey: "status")!)" == "<null>"{
                        self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                        return
                    }
                    
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                    else {
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                                
                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                httpResponse.addException(nil,strResponse: responseString! as String)
                            }
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                }
            }
            catch {
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("responseString = \(responseString!)")
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    httpResponse.addException(nil,strResponse: responseString!)
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
    
    //MARK:- RequestForPost
    /**
     Request using post method,with user reuired to pass parameter on server.
     - parameter strUrl     :- Request URL
     - parameter postData   :- parameter for send to server.
     */
    func RequestForPost(url:String, postData:NSDictionary, apiIdentifier: String) -> Void {
        self.apiIdentifier = apiIdentifier
        parmeters = postData
        
        let request = createRequest(parameter: postData, strURL: url as NSString)
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 30.0
        session.configuration.timeoutIntervalForResource = 60.0
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode != 200 {
                        
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        httpResponse.addException(nil,strResponse: responseString! as String)
                    }
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if "\(responseDictionary.value(forKey: "status")!)" == "<null>"{
                        self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                        return
                    }
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                    else {
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                httpResponse.addException(nil,strResponse: responseString! as String)
                            }
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                }
            }
            catch {
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("responseString = \(responseString!)")
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    httpResponse.addException(nil,strResponse: responseString!)
                }
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
    
    func RequestForPostWithHeader(url:String, postData:NSDictionary,headerData: NSDictionary, apiIdentifier: String) -> Void {
        self.apiIdentifier = apiIdentifier
        parmeters = postData
        
        let request = createRequestWithHeader(parameter: postData, headerData: headerData, strURL: url as NSString)
            //createRequest(parameter: postData, strURL: url as NSString)
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 30.0
        session.configuration.timeoutIntervalForResource = 60.0
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode != 200 {
                        
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        httpResponse.addException(nil,strResponse: responseString! as String)
                    }
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if "\(responseDictionary.value(forKey: "status")!)" == "<null>"{
                        self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                        return
                    }
                    
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                    else {
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            httpResponse.addException(nil,strResponse: responseString! as String)
                        }
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                }
            }
            catch {
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("responseString = \(responseString!)")
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    httpResponse.addException(nil,strResponse: responseString!)
                }
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
    //MARK:- RequestForPost
    /**
     Request using post method,with user reuired to pass parameter on server.
     - parameter strUrl     :- Request URL
     - parameter postData   :- parameter for send to server.
     */
    func RequestPostWithUserData(url:String, postData:NSDictionary, apiIdentifier: String) -> Void {
        self.apiIdentifier = apiIdentifier
        parmeters = postData
        
        let request = createRequest(parameter: postData, strURL: url as NSString)
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 30.0
        session.configuration.timeoutIntervalForResource = 60.0
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode != 200 {
                        
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        httpResponse.addException(nil,strResponse: responseString! as String)
                    }
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if "\(responseDictionary.value(forKey: "status")!)" == "<null>"{
                        self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                        return
                    }
                    
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseSuccessWithUserData!(webservice: self, response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                    else {
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            httpResponse.addException(nil,strResponse: responseString! as String)
                        }
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseFailWithUserData!(webservice: self, response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                }
            }
            catch {
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("responseString = \(responseString!)")
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    httpResponse.addException(nil,strResponse: responseString!)
                }
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Post API With Block
    static func resquestSyncAPI(dictData : NSDictionary, url : URL,successHandler:@escaping (_ response:
        NSDictionary,_ isSuccess:Bool)-> Void) {
        
        //let url:URL = URL(string: "\(Constant.ServerPathV1)BulkDataSync")!
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.timeoutInterval = 30
        request.httpBody = ImageUploadS3.encodeNSObjectToDataFormat(object: dictData) as Data
        
        let strToken = Constant.defaults.string(forKey: "Token")
        
        request.setValue(strToken!, forHTTPHeaderField: "Token")
        request.setValue("31010",forHTTPHeaderField: "sourceSystemId")
        request.setValue(Constant.preferredBU,forHTTPHeaderField: "buId")
        request.setValue(Constant.MacUUID,forHTTPHeaderField: "macId")
        request.setValue(Constant.App_Version, forHTTPHeaderField: "appversion")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            let dic = [
                "Error": "Fail"
            ]
            
            if error != nil {
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode != 200 {
                        
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        httpResponse.addException(nil,strResponse: responseString! as String)
                    }
                }
                print(error!)
                successHandler(dic as NSDictionary, false)
                return
            }
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if "\(responseDictionary.value(forKey: "status")!)" == "<null>"{
                        successHandler(dic as NSDictionary, false)
                        return
                    }
                    
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        successHandler(responseDictionary, true)
                    } else {
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                            
                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            httpResponse.addException(nil,strResponse: responseString! as String)
                        }
                        successHandler(responseDictionary, false)
                    }
                }
            } catch {
                print(error)
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString!)")
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    httpResponse.addException(nil,strResponse: responseString! as String)
                }
                successHandler(dic as NSDictionary, false)
            }
        }
        task.resume()
    }
    
    func resquestgetClientIdsInMap(dictData : NSDictionary, url : String, successHandler:@escaping (_ response:
        NSArray,_ isSuccess:Bool)-> Void) {
        
        let request = createRequestForDashboard(parameter: dictData, strURL: url as NSString)
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 30.0
        session.configuration.timeoutIntervalForResource = 60.0
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            let arrResponse : NSArray = NSArray()
            
            if error != nil {
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode != 200 {
                        
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        httpResponse.addException(nil,strResponse: responseString! as String)
                    }
                }
                print(error!)
                successHandler(arrResponse as NSArray, false)
                return
            }
            do {
                if let responsearr = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                    successHandler(responsearr as NSArray, true)
                }
            } catch {
                print(error)
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString!)")
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    httpResponse.addException(nil,strResponse: responseString! as String)
                }
                successHandler(arrResponse as NSArray, false)
            }
        }
        task.resume()
    }

    //MARK:- RequestForPostWithImages
    /**
     Request using post method,with user reuired to pass parameter and file's on server with multipart form.
     - parameter strUrl     :- Request URL
     - parameter postData   :- parameter for send to server.
     - parameter aryImageKey :- name of parameter, which will be used for store images on server DB. (i.e Image)
     - parameter aryImages   :- array of images.
     */
    func RequestForPostWithImages(strUrl:String, postData:NSDictionary, aryImageKey:NSArray, aryImages:NSArray, apiIdentifier: String) -> Void {
        self.apiIdentifier = apiIdentifier
        parmeters = postData
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: strUrl)!
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithParametersAndImages(parameters: postData, filePathKey: aryImageKey, aryImage: aryImages, boundary: boundary) as Data
        
        // Create a custom configuration
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy // this is the default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
		if httpResponse.statusCode != 200 {
                        
			let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
			httpResponse.addException(nil,strResponse: responseString! as String)
        }
	}
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if "\(responseDictionary.value(forKey: "status")!)" == "<null>"{
                        self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                        return
                    }
                    
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                    else {
                        
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                                
                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                httpResponse.addException(nil,strResponse: responseString! as String)
                            }
                        
                        if self.delegate != nil {
                            self.delegate?.webserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                }
            }
            catch {
                
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("responseString = \(responseString!)")
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    httpResponse.addException(nil,strResponse: responseString!)
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
    
    func createRequest (parameter: NSDictionary,strURL:NSString) -> NSURLRequest {
        let apiAuthToken = String(describing: Constant.defaults.object(forKey: "Token")!)
        
        let url = URL(string: strURL as String)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiAuthToken, forHTTPHeaderField: "Token")
        request.setValue("31010",forHTTPHeaderField: "sourceSystemId")
        request.setValue(Constant.preferredBU,forHTTPHeaderField: "buId")
        request.setValue(Constant.MacUUID!,forHTTPHeaderField: "macId")
        request.setValue(Constant.App_Version, forHTTPHeaderField: "appversion")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = ConvertDictionaryToJsonString(object: parameter)
        return request
    }
    
    func createRequestWithHeader (parameter: NSDictionary,headerData : NSDictionary,strURL:NSString) -> NSURLRequest {
        let apiAuthToken = String(describing: Constant.defaults.object(forKey: "Token")!)
        print((headerData.object(forKey: "macId") as! String))
        let url = URL(string: strURL as String)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiAuthToken, forHTTPHeaderField: "Token")
        request.setValue((headerData.object(forKey: "sourceSystemId") as! String),forHTTPHeaderField: "sourceSystemId")
        request.setValue((headerData.object(forKey: "buId") as! String),forHTTPHeaderField: "buId")
        request.setValue((headerData.object(forKey: "macId") as! String),forHTTPHeaderField: "macId")
        request.setValue(Constant.App_Version, forHTTPHeaderField: "appversion")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = ConvertDictionaryToJsonString(object: parameter)
        return request
    }
    
    func ConvertDictionaryToJsonString(object : NSDictionary) -> Data {
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is an `AnyObject` decoded from JSON data
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                print(dictFromJSON)
                // use dictFromJSON
            }
        } catch let error as NSError {
            print(error)
        }
        return jsonData
    }
    
    func createBodyWithParameters(parameters: NSDictionary?, boundary: String) -> NSData {
        let body = NSMutableData()
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    
    func createBodyWithParametersAndFile(parameters: NSDictionary?, filePathKey: String?, paths: String?,boundary: String) -> NSData {
        
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        if paths != ""{
            
            let url = URL(fileURLWithPath: paths!)
            let filename = url.lastPathComponent
            
            var data = Data()
            do {
                data = try Data(contentsOf: url)
            }
            catch {
            }
            let mimeType = mimeTypeForPath(path: paths!)
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimeType)\r\n\r\n")
            body.append(data)
            body.appendString(string: "\r\n")
        }
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    
    func createBodyWithParametersAndImages(parameters: NSDictionary?,filePathKey:NSArray , aryImage:NSArray,boundary: String) -> NSData {
        
        let body = NSMutableData()
        
        if parameters != nil {
            
            for (key, value) in parameters! {
                
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        if aryImage.count > 0 && filePathKey.count == aryImage.count {
            
            for i in 0 ..< aryImage.count{
                
                let data = UIImageJPEGRepresentation(aryImage[i] as! UIImage,1)
                let mimeType = "png"
                
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey[i])\"; filename=\"image.jpg\"\r\n")
                body.appendString(string: "Content-Type: \(mimeType)\r\n\r\n")
                body.append(data!)
                body.appendString(string: "\r\n")
            }
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
    /**
     
     For Rm Dashboard Data
     */
    func createRequestForDashboard (parameter: NSDictionary,strURL:NSString) -> NSURLRequest {
        let apiAuthToken = String(describing: Constant.defaults.object(forKey: "Token")!)
        
        let url = URL(string: strURL as String)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiAuthToken, forHTTPHeaderField: "tokenKey")
        request.setValue("31010",forHTTPHeaderField: "sourceSystemId")
        request.setValue(Constant.App_Version, forHTTPHeaderField: "appversion")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = ConvertDictionaryToJsonString(object: parameter)
        return request
    }
    
    func RMDashboardRequestForPost(url:String, postData:NSDictionary, apiIdentifier: String) -> Void  {
        self.apiIdentifier = apiIdentifier
        parmeters = postData
        
        let request = createRequestForDashboard(parameter: postData, strURL: url as NSString)
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 30.0
        session.configuration.timeoutIntervalForResource = 60.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode != 200 {
                        
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        httpResponse.addException(nil,strResponse: responseString! as String)
                    }
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                
                /*
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    /* if (responseDictionary.object(forKey: "status"))! as! String == "success" {*/
                    if self.delegate != nil {
                        self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                    }
                    /* }
                     else {
                     if self.delegate != nil {
                     self.delegate?.webserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                     }
                     }*/
                }*/  
                
                 
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    if self.delegate != nil {
                        self.delegate?.webserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                    }
                }
                else if let responsearr = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                    if self.delegate != nil {
                        self.delegate?.webserviceResponseInArraySuccess!(response: responsearr , apiIdentifier: self.apiIdentifier)
                    }
                }
            }
            catch {
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("responseString = \(responseString!)")
                
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    
                    httpResponse.addException(nil,strResponse: responseString!)
                }
                
                if self.delegate != nil {
                    self.delegate?.webserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
