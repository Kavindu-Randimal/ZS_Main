//
//  DocumentSignControllerExtension.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

extension DocumentSignController {
    
    func registerUpprUser() {
        if isregisterd {
            getdocumentProcess()
            return
        }
    
        let upprregistercontroller = DocumentSignUPPRRegisterController()
        upprregistercontroller.modalPresentationStyle = .overCurrentContext
        self.present(upprregistercontroller, animated: true, completion: nil)
        
        upprregistercontroller.registrationCompletion = {[weak self] success in
            if success {
                self!.getdocumentProcess()
            }
            return
        }
        return
    }
}
