//
//  SealTransVC.swift
//  ZorroSign
//
//  Created by Apple on 15/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

protocol SealTransProtocol {
    func onSelectImg(img:UIImage)
}

class SealTransVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate {

    var imgSeal: UIImage!
    let alphaArr:[CGFloat] = [1.0, 0.8, 0.6, 0.4, 0.2]
    var delegateSTVC: SealTransProtocol?
    var selImg: Int = 0
    var newImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath)
        
        let img = cell.viewWithTag(1) as! UIImageView
        if indexPath.row == 0 {
            img.image = imgSeal.removeWhitebg()
        }
        if indexPath.row == 1 {
            img.image = imgSeal.removeLightBrownbg()
        }
        if indexPath.row == 2 {
            img.image = imgSeal.removeDarkBrownbg()
        }
        if indexPath.row == 3 {
            img.image = imgSeal.removeExtremebg()
        }
        if indexPath.row == 4 {
            img.image = imgSeal.convertGray()
        }
        
        //img.alpha = alphaArr[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selImg = indexPath.row
        
        if delegateSTVC != nil {
            
            if selImg == 0 {
                newImg = imgSeal.removeWhitebg()
            }
            if selImg == 1 {
                newImg = imgSeal.removeLightBrownbg()
            }
            if selImg == 2 {
                newImg = imgSeal.removeDarkBrownbg()
            }
            if selImg == 3 {
                newImg = imgSeal.removeExtremebg()
            }
            if selImg == 4 {
                newImg = imgSeal.convertGray()
            }
            delegateSTVC?.onSelectImg(img: newImg!)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func submitAction() {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
