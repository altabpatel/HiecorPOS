//
//  PDFViewController.swift
//  HieCOR
//
//  Created by Sudama dewda on 03/09/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit
import PDFKit

@available(iOS 11.0, *)
class PDFViewController: BaseViewController{
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var pdfTitleLable: UILabel!
    
    var pdfURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        Indicator.isEnabledIndicator = true
        Indicator.sharedInstance.hideIndicator()
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.showAlert(message: "Something went wrong")
                //appDelegate.showToast(message: "Something went wrong")
            }
        }
        
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareBtnAction(_ sender: Any) {
        sharePdf(path: pdfURL)
        
    }
    
    func sharePdf(path:URL) {
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path.path){
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView=self.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            activityViewController.popoverPresentationController?.permittedArrowDirections = []
            present(activityViewController, animated: true, completion: nil)
            
        }
        else {
            print("document was not found")
        }

    }

}
