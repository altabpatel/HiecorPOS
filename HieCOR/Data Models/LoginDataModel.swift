//
//  LoginDataModel.swift
//  HieCOR
//
//  Created by Deftsoft on 17/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

class AccessPINModel
{
    var str_firstName = String()
    var str_last_name = String()
    var str_email = String()
    var str_account_type = String()
    var str_phone = String()
}

extension LoginVM {
    
    func parsezreportData(responseDict: JSONDictionary) {
        if let userData = responseDict["data"] as? [String:AnyObject]
        {
            print(userData)
        }
    }
    
    func parseUserloginData(responseDict: JSONDictionary) {
        if let userData = responseDict["data"] as? [String:AnyObject]
        {
            let acountinfo = userData["account_info"]
            let auth_key = acountinfo?.object(forKey: "auth_key") as? String
            let user_name = acountinfo?.object(forKey: "user_name") as? String
            let username = userData["username"] as? String
            let user_id = userData["userID"] as? String ?? ""
            let appVersion = userData["version"] as? String ?? ""
            let account_type = userData["account_type"] as? String ?? ""
//            "account_type": "Administrator",
            DataManager.appVersion = appVersion
            print("appVersion",appVersion)
            DataManager.appUserID = user_id
            
            if let username = username {
                DataManager.appUserName = username
            }

            let defaults = UserDefaults.standard
            defaults.set(user_id, forKey: "userID")
            defaults.set(auth_key, forKey: "auth_key")
            defaults.set(user_name, forKey: "user_name")
            defaults.set(appVersion, forKey: "version")
            defaults.set(account_type, forKey: "account_type")
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: userData), forKey: "userdata")
            defaults.synchronize()
            
            if let user_tax = userData["user_tax_lock"] as? String {
                appDelegate.isPinlogin = true
            }
            
            if let setting = userData["settings"] as? JSONDictionary {
                DataManager.logoImageUrl = setting["pos_logo"] as? String 
            }else {
                DataManager.logoImageUrl = nil
            }
            
            
            
            /*let city = userData["city"]
            let region = userData["region"]
            let postal_code = userData["postal_code"]
            let country = userData["country"]
            
            let customerObj: JSONDictionary = ["country": country ?? "", "billingCountry":country ?? "","shippingCountry":country ?? "","coupan": "", "str_first_name":"", "str_last_name":"", "str_company": "" ,"str_address": "", "str_bpid":"", "str_city":city ?? "", "str_order_id": "", "str_email": "", "str_userID": "", "str_phone": "","str_region":region ?? "", "str_address2": "", "str_Billingcity":city ?? "", "str_postal_code":postal_code ?? "", "str_Billingphone": "", "str_Billingaddress": "", "str_Billingaddress2": "", "str_Billingregion":region ?? "", "str_Billingpostal_code":postal_code ?? "","shippingPhone": "","shippingAddress" : "", "shippingAddress2": "", "shippingCity": city ?? "", "shippingRegion" : region ?? "", "shippingPostalCode": postal_code ?? "", "billing_first_name": "", "billing_last_name": "","user_custom_tax": "","shipping_first_name": "", "shipping_last_name": "","shippingEmail":  "", "str_Billingemail": "",  "str_BillingCustom1TextField": "", "str_BillingCustom2TextField": ""]
            DataManager.customerObj = customerObj*/
        }
        
        UserDefaults.standard.set(BaseURL, forKey: "BaseUrl")
        UserDefaults.standard.synchronize()
    }
    
    func parseUserPinData(responseDict: JSONDictionary) {
        if let userData = responseDict["data"] as? [String:AnyObject]
        {
            //let acountinfo = userData["account_info"]
            //let auth_key = acountinfo?.object(forKey: "auth_key") as? String
            //let user_name = acountinfo?.object(forKey: "user_name") as? String
            let username = userData["username"] as? String
            let user_id = userData["userID"] as? String ?? ""
            //let appVersion = userData["version"] as? String ?? ""
            let account_type = userData["account_type"] as? String ?? ""
            //            "account_type": "Administrator",
            //DataManager.appVersion = appVersion
            DataManager.appUserID = user_id
            
            if let username = username {
                DataManager.appUserName = username
            }
            
            let defaults = UserDefaults.standard
            defaults.set(user_id, forKey: "userID")
            //defaults.set(auth_key, forKey: "auth_key")
            //defaults.set(user_name, forKey: "user_name")
            //defaults.set(appVersion, forKey: "version")
            defaults.set(account_type, forKey: "account_type")
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: userData), forKey: "userdata")
            defaults.synchronize()
            
            if let user_tax = userData["user_tax_lock"] as? String {
                appDelegate.isPinlogin = true
                if user_tax != "" {
                    appDelegate.UserTaxData = true
                }
            }
            
            if let setting = userData["settings"] as? JSONDictionary {
                DataManager.logoImageUrl = setting["pos_logo"] as? String
            }else {
                DataManager.logoImageUrl = nil
            }
            
            /*let city = userData["city"]
            let region = userData["region"]
            let postal_code = userData["postal_code"]
            let country = userData["country"]
            
            let customerObj: JSONDictionary = ["country": country ?? "", "billingCountry":country ?? "","shippingCountry":country ?? "","coupan": "", "str_first_name":"", "str_last_name":"", "str_company": "" ,"str_address": "", "str_bpid":"", "str_city":city ?? "", "str_order_id": "", "str_email": "", "str_userID": "", "str_phone": "","str_region":region ?? "", "str_address2": "", "str_Billingcity":city ?? "", "str_postal_code":postal_code ?? "", "str_Billingphone": "", "str_Billingaddress": "", "str_Billingaddress2": "", "str_Billingregion":region ?? "", "str_Billingpostal_code":postal_code ?? "","shippingPhone": "","shippingAddress" : "", "shippingAddress2": "", "shippingCity": city ?? "", "shippingRegion" : region ?? "", "shippingPostalCode": postal_code ?? "", "billing_first_name": "", "billing_last_name": "","user_custom_tax": "","shipping_first_name": "", "shipping_last_name": "","shippingEmail":  "", "str_Billingemail": "",  "str_BillingCustom1TextField": "", "str_BillingCustom2TextField": ""]
            DataManager.customerObj = customerObj*/
            
        }
        
        UserDefaults.standard.set(BaseURL, forKey: "BaseUrl")
        UserDefaults.standard.synchronize()
    }
}

