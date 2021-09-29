//
//  pageDemoViewController.swift
//  ZorroSign
//
//  Created by Apple on 14/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SwiftyJSON

class pageDemoViewController: UIViewController {

    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    //var arrImage = [String]()
    var arrImage: [String] = ["http://www.clker.com/cliparts/K/R/y/3/Y/l/soccer-ball-th.png","http://www.clker.com/cliparts/b/3/b/d/11971252702040963370chris_sharkot_ball.svg.thumb.png","a.png", "a.png" ,"a.png", "a.png" ]
    var ks = [KingfisherSource]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Singletone.shareInstance.showActivityIndicatory(uiView: view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIWhatsNew = ["Authorization" : "Bearer \(strAuth)"]
        
        let apiURL = Singletone.shareInstance.apiNotification + "api/v1/Notification/Features?count=5"
        
        Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIWhatsNew)
            .responseJSON { response in
                
                let jsonObj: JSON = JSON(response.result.value!)
                print("***")
                print(jsonObj)
                print("***")
                if jsonObj["StatusCode"] == 1000
                {
                    self.slideshow.backgroundColor = UIColor.white
                    self.slideshow.circular = false
                    self.slideshow.pageControlPosition = PageControlPosition.underScrollView
                    self.slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
                    self.slideshow.pageControl.pageIndicatorTintColor = UIColor.black
                    self.slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit//scaleAspectFill
                    print(self.arrImage)
                    for i in 0...jsonObj["Data"].arrayValue.count - 1
                    {
                        
                        self.ks.append(KingfisherSource(urlString: "a.png")!)
                    }
                    
                    self.lblCount.text = jsonObj["Data"][0]["Description"].stringValue//String(page)
                    self.lblSubTitle.text = jsonObj["Data"][0]["Header"].stringValue
                    let url = URL(string: jsonObj["Data"][0]["ImageUrl"].stringValue)
                    self.imgView.kf.setImage(with: url)
                    
                    self.slideshow.activityIndicator = DefaultActivityIndicator()
                    self.slideshow.currentPageChanged = { page in
                        print("current page:", page)
                        self.lblCount.text = jsonObj["Data"][page]["Description"].stringValue//String(page)
                        self.lblSubTitle.text = jsonObj["Data"][page]["Header"].stringValue
                        let url = URL(string: jsonObj["Data"][page]["ImageUrl"].stringValue)
                        self.imgView.kf.setImage(with: url)
                    }
                    
                    self.slideshow.setImageInputs(self.ks)
                    Singletone.shareInstance.stopActivityIndicator()
                    
                }
                else
                {
                    Singletone.shareInstance.stopActivityIndicator()
                    self.alertSample(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                }
        }
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
