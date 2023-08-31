//
//  iPadIntroductionViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 29/01/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import EAIntroView

class iPad_IntroductionViewController: BaseViewController {
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    }
    
    //MARK: Private Functions
    private func loadData() {
        //Page1
        
        let page1 = EAIntroPage()
        let amountText = NSMutableAttributedString.init(string: "THE FUTURE OF \n\n POINT OF SALE")
        amountText.setAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.backgroundColor: UIColor.red], range: NSMakeRange(0, 4))
        page1.title = amountText.string
        page1.titleColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        page1.titlePositionY = 240
        page1.desc = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        page1.descColor = UIColor.gray
        page1.descPositionY = 220
        page1.titleIconView = UIImageView(image: #imageLiteral(resourceName: "splash-icon-1"))
        page1.titleIconPositionY = 100
        page1.showTitleView = false
        
        //Page2
        let page2 = EAIntroPage()
        page2.title = "GET YOUR \n\n STORE ONLINE"
        page2.titleColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        page2.titlePositionY = 240
        page2.desc = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        page2.descColor = UIColor.gray
        page2.descPositionY = 220
        page2.titleIconView = UIImageView(image: #imageLiteral(resourceName: "splash-icon-2"))
        page2.titleIconPositionY = 100
        page2.showTitleView = false
        
        //Page3
        let page3 = EAIntroPage()
        page3.title = "HAPPY CUSTOMER \n\n MORE SALE"
        page3.titleColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        page3.titlePositionY = 240
        page3.desc = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        page3.descColor = UIColor.gray
        page3.descPositionY = 220
        page3.titleIconView = UIImageView(image: #imageLiteral(resourceName: "splash-icon-3"))
        page3.titleIconPositionY = 100
        page3.showTitleView = false
        
        //Load Intro view
        let intro = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3])!
        intro.tapToNext = true
        intro.delegate = self
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.init(red: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        pageControl.pageIndicatorTintColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        pageControl.sizeToFit()
        
        intro.pageControl = pageControl
        intro.pageControlY = 145.0
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 0, y: 0, width: 230, height: 40)
        button.setTitle("SKIP NOW", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        
        intro.skipButton = button
        intro.skipButtonY = 60.0
        intro.skipButtonAlignment = .center
        
        intro.delegate = self
        intro.show(in: self.view, animateDuration: 0.3)
    }
}

//MARK: EAIntroDelegate
extension iPad_IntroductionViewController: EAIntroDelegate {
    func introDidFinish(_ introView: EAIntroView, wasSkipped: Bool) {
        if wasSkipped {
            print("Intro skipped")
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "iPad_LoginViewController") as! iPad_LoginViewController
            self.navigationController?.pushViewController(controller, animated: false)
        }
        else {
            print("Intro finished")
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "iPad_LoginViewController") as! iPad_LoginViewController
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
}
