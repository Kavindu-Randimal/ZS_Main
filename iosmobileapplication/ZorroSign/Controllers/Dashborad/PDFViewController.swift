//
//  PDFViewController.swift
//  ZorroSign
//
//  Created by Apple on 18/02/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import PDFKit


@available(iOS 11.0, *)
class PDFViewController: BaseVC {

    var pdfView = PDFView()
    var pdfURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(pdfView)
        
        //let path = Bundle.main.path(forResource: "test", ofType: "pdf")
        //pdfURL = URL(fileURLWithPath: path!)
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            //self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        pdfView.frame = view.frame
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
