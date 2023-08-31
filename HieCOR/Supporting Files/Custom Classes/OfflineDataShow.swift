//
//  OfflineDataShow.swift
//  HieCOR
//
//  Created by Sudama dewda on 08/01/20.
//  Copyright © 2020 HyperMacMini. All rights reserved.
//

import Foundation
import UIKit

class OfflineDataShow: BaseViewController { 
    
    @IBOutlet weak var offlineDataViewShow: UITextView!
    
    var jsonDataForView = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewdata()
       
         offlineDataViewShow.text = jsonDataForView
        
        if  offlineDataViewShow.text == "" {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.showAlert(message: "No queue for offline orders.")
                appDelegate.showToast(message: "No queue for offline orders.")
                
            }
        }
        // DataManager.offlineOrderdata?.removeAll()
    }
    
//    
//    func viewdata() {
//        do {
//            
//            //Convert to Data
//            let jsonData = try JSONSerialization.data(withJSONObject:  DataManager.offlineOrderdata ?? [] , options: JSONSerialization.WritingOptions.prettyPrinted)
//            
//            //Convert back to string. Usually only do this for debugging
//            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//                jsonDataForView = JSONString
//                if jsonDataForView == "[\n\n]" {
//                    jsonDataForView = ""
//                }
//                print(JSONString)
//            }
//            
//            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
//           // var jsonTest = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
//            
//            
//        } catch {
//            //print(error.description)
//        }
//    
//    }
//    
    @IBAction func closeBtnAction(_ sender: Any) {
          
           self.dismiss(animated: true, completion: nil)
      }
      
      @IBAction func shareBtnAction(_ sender: Any) {
          sharePdf(path: jsonDataForView)
          
      }
    func sharePdf(path: String) {
        
        if  offlineDataViewShow.text == "" {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.showAlert(message: "No queue for offline orders.")
                appDelegate.showToast(message: "No queue for offline orders.")
            }
        }else{
            // text to share
            let text = path
            
            // set up activity view controller
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView=self.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            activityViewController.popoverPresentationController?.permittedArrowDirections = []
            present(activityViewController, animated: true, completion: nil)
        
            
        }
    }
}
