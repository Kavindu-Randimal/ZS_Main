//
//  WhatsNewVC.swift
//  ZorroSign
//
//  Created by Apple on 14/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ImageSlideshow

class WhatsNewVC: BaseVC, UITableViewDataSource {

    @IBOutlet weak var viewWhatsNew: ImageSlideshow!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var viewWhatsNewSub: UIView!
    @IBOutlet weak var btnX: UIButton!
    @IBOutlet weak var chkDontShow: UIButton!
    
    var ks = [KingfisherSource]()
    
    
    @IBOutlet weak var viewCont: UIView!
    
    @IBOutlet weak var tblvw: UITableView!
    
    var arrImg = ["","","",""]
    var arrTitle = ["1. CREATE","2. PROCESS","3. EXECUTE","4. AUTHENTICATE"]
    var arrContent = ["Documents in word, excel, pdf, dwf, jpeg & more", "Adhere to compliance & business rules without deviation", "Drag & drop workflow, tracks progress & eliminates bottlenecks","Assign permissions & ensure documents have not been tampered, revised, revoked or cancelled"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewCont.isHidden = true
        //tblvw.reloadData()
        whatsNewAPI()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
//        let img = arrImg[indexPath.row]
//        let imgvw = cell?.viewWithTag(1) as! UIImageView
//        imgvw.image = UIImage(named: img)
//
//        let title = arrTitle[indexPath.row]
//        let lbltitle = cell?.viewWithTag(2) as! UILabel
//        lbltitle.text = title
//
//        let content = arrContent[indexPath.row]
//        let lblcontent = cell?.viewWithTag(3) as! UILabel
//        lblcontent.text = title
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func whatsNewAPI() {
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        //        DispatchQueue.main.async {
        //            Singletone.shareInstance.showActivityIndicatory(uiView: view)
        //        }
        
        /////START WHATS NEW 99
        
        //9930529686
        viewWhatsNew.isHidden = true
        //btnX.isHidden = true
        viewWhatsNewSub.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewWhatsNew.layer.cornerRadius = 3
        viewWhatsNew.clipsToBounds = true
        
        if Connectivity.isConnectedToInternet() == false
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        else
        {
            //Singletone.shareInstance.showActivityIndicatory(uiView: view)
            self.showActivityIndicatory(uiView: self.view)
            
            let api = "api/v1/Notification/Features?count=7"
            let apiURL = Singletone.shareInstance.apiNotification + api
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    if response.result.isFailure {
                        return
                    }
                    guard let response = response as? DataResponse<Any> else {
                        return
                    }
                     let jsonObj: JSON = JSON(response.result.value!) 
                        print("response whats new ",jsonObj["Data"])
                        if jsonObj["StatusCode"] == 1000
                        {
                            self.viewWhatsNew.backgroundColor = UIColor.white
                            self.viewWhatsNew.circular = false
                            //self.viewWhatsNew.pageControlPosition = PageControlPosition.insideScrollView
                            self.viewWhatsNew.pageIndicatorPosition = PageIndicatorPosition(horizontal: PageIndicatorPosition.Horizontal.center, vertical: PageIndicatorPosition.Vertical.customBottom(padding: 50))
                            self.viewWhatsNew.pageControl.currentPageIndicatorTintColor = Singletone.shareInstance.footerviewBackgroundGreen
                            self.viewWhatsNew.pageControl.pageIndicatorTintColor = UIColor.lightGray
                            self.viewWhatsNew.contentScaleMode = UIView.ContentMode.scaleAspectFit//scaleAspectFill
                            
                            
                            for _ in 0...jsonObj["Data"].arrayValue.count - 1
                            {
                                self.ks.append(KingfisherSource(urlString: "a.png")!)
                            }
                            
                            self.lblTitle.text = jsonObj["Data"][0]["Description"].stringValue//String(page)
                            self.lblSubTitle.text = jsonObj["Data"][0]["Header"].stringValue
                            let url = URL(string: jsonObj["Data"][0]["ImageUrl"].stringValue)
                            self.imgView.kf.setImage(with: url)
                            
                            self.viewWhatsNew.slideshowInterval = 5.0
                            self.viewWhatsNew.setImageInputs(self.ks)
                            
                            self.viewWhatsNew.activityIndicator = DefaultActivityIndicator()
                            self.viewWhatsNew.currentPageChanged = { page in
                                print("current page:", page)
                                
                                
                                self.lblTitle.text = jsonObj["Data"][page]["Header"].stringValue//String(page)
                                self.lblSubTitle.text = jsonObj["Data"][page]["Description"].stringValue
                                let url = URL(string: jsonObj["Data"][page]["ImageUrl"].stringValue)
                                if page != 6 {
                                    print("url: \(url)")
                                    self.lblSubTitle.isHidden = false
                                    self.imgView.kf.setImage(with: url)
                                } else {
                                    self.lblTitle.text = "Get Work Done with Four Easy Steps"
                                    self.lblSubTitle.isHidden = true
                                    self.imgView.image = UIImage(named: "whtnw.png")
                                }
                            }
                            
                            self.viewWhatsNew.isHidden = false
                            self.btnX.isHidden = false
                            
                            let dontshowagain = UserDefaults.standard.bool(forKey: "dontshowagain")
                            self.chkDontShow.isSelected = dontshowagain
                        }
                        else
                        {
                            //Singletone.shareInstance.stopActivityIndicator()
                            //self.alertSample(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                        }
                    
//                    else
//                    {
                        //Singletone.shareInstance.stopActivityIndicator()
                        //self.alertSample(strTitle: "", strMsg: "Error from server")
//                    }
                    
            }
        }
    }

    @IBAction func btnXAction(_ sender: Any) {
       
        viewWhatsNew.isHidden = true
        self.viewWhatsNew.slideshowInterval = 0.0
        btnX.isHidden = true
 
        self.dismiss(animated: false, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
