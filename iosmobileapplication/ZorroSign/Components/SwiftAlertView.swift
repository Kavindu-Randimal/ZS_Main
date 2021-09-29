//
//  SwiftAlertView.swift
//  SwiftAlertView
//
//  Created by Dinh Quan on 8/26/15.
//  Copyright (c) 2015 Dinh Quan. All rights reserved.
//
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

public class SwiftAlertView: UIView {


    // MARK: Public Properties

    weak var delegate: SwiftAlertViewDelegate? // delegate

    var titleLabel: UILabel! // access titleLabel to customize the title font, color
    var messageLabel: UILabel! // access messageLabel to customize the message font, color

    var cancelButtonIndex: Int! // default is 0, set this property if you want to change the position of cancel button

    var backgroundImage: UIImage?
    // var backgroundColor: UIColor? // inherits from UIView

    var buttonTitleColor: UIColor! // to change the title color of all buttons
    var buttonHeight: Double! // default is 44

    var separatorColor: UIColor! // to change the separator color
    var hideSeparator: Bool! // to hide the separater color
    var cornerRadius: Double! // default is 8 px

    var dismissOnOtherButtonClicked: Bool! // default is true, if you want the alert view will not be dismissed when clicking on other buttons, set this property to false
    var highlightOnButtonClicked: Bool! // default is true
    var dimBackgroundWhenShowing: Bool! // default is true
    var dimAlpha: Double! // default is 0.2
    var dismissOnOutsideClicked: Bool! // default is false

    var appearTime: Double! // default is 0.2 second
    var disappearTime: Double! // default is 0.1 second

    var appearType: SwiftAlertViewAppearType! // to change the appear type
    var disappearType: SwiftAlertViewDisappearType! // to change the disappear type

    // customize the margin & spacing of title & message
    var titleSideMargin: Double!  // default is 20 px
    var messageSideMargin: Double!  // default is 20 px
    var titleTopMargin: Double!  // default is 20 px
    var messageBottomMargin: Double! // default is 20 px
    var titleToMessageSpacing: Double! // default is 10 px

    // closure for handling button clicked action
    var clickedButtonAction:((_ buttonIndex: Int) -> (Void))? // all buttons
    var clickedCancelButtonAction:((Void) -> (Void))? // for cancel button
    var clickedOtherButtonAction:((_ buttonIndex: Int) -> (Void))? // sometimes you want to handle the other button click event but don't want to write if/else in clickedButtonAction closure, use this property

    /** Example of using these closures
     alertView.clickedButtonAction = {(buttonIndex) -> Void in
     println("Button Clicked At Index \(buttonIndex)")
     }
     alertView.clickedCancelButtonAction = {
     println("Cancel Button Clicked")
     }
     alertView.clickedOtherButtonAction = {(buttonIndex) -> Void in
     println("Other Button Clicked At Index \(buttonIndex)")
     }
     */

    // MARK: Constants

    private let kSeparatorWidth = 0.5
    private let kDefaultWidth = 375.0 //270.0
    public let kDefaultHeight = 144.0
    private let kDefaultTitleSizeMargin = 20.0
    private let kDefaultMessageSizeMargin = 20.0
    private let kDefaultButtonHeight = 44.0
    private let kDefaultCornerRadius = 8.0
    private let kDefaultTitleTopMargin = 20.0
    private let kDefaultTitleToMessageSpacing = 10.0
    private let kDefaultMessageBottomMargin = 20.0
    private let kDefaultDimAlpha = 0.4


    // MARK: Private Properties
    private var contentView: UIView?
    private var buttons = [UIButton]()
    private var backgroundImageView: UIImageView?
    private var dimView: UIView?
    private var title: String?
    private var message: String?
    private var cancelButtonTitle: String?
    private var otherButtonTitles = [String]()
    private var viewWidth: Double!
    private var viewHeight: Double!


    // MARK: Init

    // init with title and message, set title to nil to make alert be no title, same with message
    init(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title: title, message: message, contentView: nil, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }

    // init with title and message, use this constructor in case of only one button
    init(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title: title, message: message, contentView: nil, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: nil)
    }

    init(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))
        setUp(title: title, message: message, contentView: nil, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }

    // init with custom content view
    init(contentView: UIView!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))

        setUp(title: nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }

    init(contentView: UIView!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))

        setUp(title: title, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: nil)
    }

    init(contentView: UIView!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))

        setUp(title: nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }

    // init with custom nib file from main bundle, make sure this file exists
    init(nibName: String!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: String...) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))

        let contentView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView
        setUp(title: nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }

    init(nibName: String!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))

        let contentView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView

        setUp(title: "", message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: nil)
    }

    init(nibName: String!, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        super.init(frame: CGRect(x: 0, y: 0, width: kDefaultWidth, height: kDefaultHeight))

        let contentView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView
        setUp(title: nil, message: nil, contentView: contentView, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }


    // MARK: Public Functions

    // access the buttons to customize their font & color
    func buttonAtIndex(index: Int) -> UIButton? {
        if index >= 0 && index < buttons.count {
            return buttons[index]
        }

        return nil
    }

    // show the alert view at center of screen
    func show() {
        if let window: UIWindow = UIApplication.shared.keyWindow {
            show(view: window)
        }
    }

    // show the alert view at center of a view
    func show(view: UIView) {
        layoutElementBeforeShowing()

        self.frame = CGRect(x: (Double(view.frame.size.width) - viewWidth)/2, y: (Double(view.frame.size.height) - viewHeight)/2, width: viewWidth, height: viewHeight)

        let window = UIApplication.shared.windows.last as! UIView
        if dimBackgroundWhenShowing == true {
            dimView = UIView(frame: window.bounds)
            dimView!.backgroundColor = UIColor(white: 0, alpha: CGFloat(dimAlpha))
            view.addSubview(dimView!)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(outsideClicked))
            dimView!.addGestureRecognizer(recognizer)
        }

        if delegate?.responds(to: Selector("willPresentAlertView:")) == true {
            delegate?.willPresentAlertView!(alertView: self)
        }

        view.addSubview(self)
        view.bringSubviewToFront(self)

        if appearType == SwiftAlertViewAppearType.Default {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.alpha = 0.6
            UIView.animate(withDuration: appearTime, animations: { () -> Void in
                self.transform = CGAffineTransform.identity
                self.alpha = 1
            }) { (finished) -> Void in
                if self.delegate?.responds(to: Selector("didPresentAlertView:")) == true {
                    self.delegate?.didPresentAlertView!(alertView: self)
                }
            };
        } else if appearType == SwiftAlertViewAppearType.FadeIn {
            self.alpha = 0
            UIView.animate(withDuration: appearTime, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.alpha = 1
            }, completion: { (finished) -> Void in
                if self.delegate?.responds(to: Selector("didPresentAlertView:")) == true {
                    self.delegate?.didPresentAlertView!(alertView: self)
                }
            })
        } else if appearType == SwiftAlertViewAppearType.FlyFromTop {
            let tempFrame = self.frame
            self.frame =
                CGRect(x:self.frame.origin.x, y:0 - self.frame.size.height - 10, width:self.frame.size.width, height:self.frame.size.height)
            UIView.animate(withDuration: appearTime, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.frame = tempFrame
            }, completion: { (finished) -> Void in
                if self.delegate?.responds(to: Selector("didPresentAlertView:")) == true {
                    self.delegate?.didPresentAlertView!(alertView: self)
                }
            })
        } else if appearType == SwiftAlertViewAppearType.FlyFromLeft {
            let tempFrame = self.frame
            self.frame = CGRect(x:0 - self.frame.size.width - 10, y:self.frame.origin.y, width:self.frame.size.width, height:self.frame.size.height)
            UIView.animate(withDuration: appearTime, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.frame = tempFrame
            }, completion: { (finished) -> Void in
                if self.delegate?.responds(to: Selector("didPresentAlertView:")) == true {
                    self.delegate?.didPresentAlertView!(alertView: self)
                }
            })
        }
    }

    // programmatically dismiss the alert view
    func dismiss() {
        if self.delegate?.responds(to: Selector(("willDismissAlertView:"))) == true {
            self.delegate?.willDismissAlertView!(alertView: self)
        }

        if dimView != nil {
            UIView.animate(withDuration: disappearTime, animations: { () -> Void in
                self.dimView?.alpha = 0
            }, completion: { (finished) -> Void in
                self.dimView?.removeFromSuperview()
            })
        }

        if disappearType == SwiftAlertViewDisappearType.Default {
            self.transform = CGAffineTransform.identity
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.alpha = 0
            }) { (finished) -> Void in
                self.removeFromSuperview()
                //if self.delegate?.responds(to: Selector("didDismissAlertView:")) == true {
                self.delegate?.didDismissAlertView!(alertView: self)
                //}
            }
        } else if disappearType == SwiftAlertViewDisappearType.FadeOut {
            self.alpha = 1
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.alpha = 0
            }) { (finished) -> Void in
                self.removeFromSuperview()
                if self.delegate?.responds(to: Selector("didDismissAlertView:")) == true {
                    self.delegate?.didDismissAlertView!(alertView: self)
                }
            }
        } else if disappearType == SwiftAlertViewDisappearType.FlyToBottom {
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.frame = CGRect(x:self.frame.origin.x, y:self.superview!.frame.size.height + 10, width:self.frame.size.width, height:self.frame.size.height)
            }) { (finished) -> Void in
                self.removeFromSuperview()
                if self.delegate?.responds(to: Selector("didDismissAlertView:")) == true {
                    self.delegate?.didDismissAlertView!(alertView: self)
                }
            }
        } else if disappearType == SwiftAlertViewDisappearType.FlyToRight {
            UIView.animate(withDuration: disappearTime, delay: 0.02, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.frame = CGRect(x:self.superview!.frame.size.width + 10, y:self.frame.origin.y, width:self.frame.size.width, height:self.frame.size.height)
            }) { (finished) -> Void in
                self.removeFromSuperview()
                if self.delegate?.responds(to: Selector("didDismissAlertView:")) == true {
                    self.delegate?.didDismissAlertView!(alertView: self)
                }
            }
        }



    }

    // declare the closure to handle clicked button event
    func handleClickedButtonAction(action: @escaping (_ buttonIndex: Int) -> (Void)) {
        clickedButtonAction = action
    }


    // MARK: Private Functions

    private func setUp(title: String?, message: String?, contentView: UIView?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        self.delegate = delegate
        self.title = title
        self.message = message
        self.cancelButtonTitle = cancelButtonTitle
        if otherButtonTitles != nil {
            self.otherButtonTitles = otherButtonTitles!
        }
        if contentView != nil {
            self.contentView = contentView
        }
        setUpDefaultValue()
        setUpElements()
        setUpDefaultAppearance()
        if contentView != nil {
            viewWidth = Double(self.contentView!.frame.size.width)
        }

        if title == nil || message == nil {
            titleToMessageSpacing = 0
        }
    }

    private func setUpDefaultValue() {
        clipsToBounds = true
        viewWidth = kDefaultWidth
        viewHeight = kDefaultHeight
        titleSideMargin = kDefaultTitleSizeMargin
        messageSideMargin = kDefaultMessageSizeMargin
        buttonHeight = kDefaultButtonHeight
        titleTopMargin = kDefaultTitleTopMargin
        titleToMessageSpacing = kDefaultTitleToMessageSpacing
        messageBottomMargin = kDefaultMessageBottomMargin
        dimAlpha = kDefaultDimAlpha
        dimBackgroundWhenShowing = true
        dismissOnOtherButtonClicked = true
        highlightOnButtonClicked = false
        dismissOnOutsideClicked = false
        hideSeparator = false
        cornerRadius = kDefaultCornerRadius
        cancelButtonIndex = 0
        appearTime = 0.2
        disappearTime = 0.1
        appearType = SwiftAlertViewAppearType.Default
        disappearType = SwiftAlertViewDisappearType.Default
        separatorColor = UIColor(red: 196.0/255, green: 196.0/255, blue: 201.0/255, alpha: 1.0)
        buttonTitleColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        layer.cornerRadius = CGFloat(cornerRadius)
    }

    private func setUpElements() {
        titleLabel = UILabel(frame: CGRect.zero)
        messageLabel = UILabel(frame: CGRect.zero)

        if title != nil {
            titleLabel.text = title
            addSubview(titleLabel)
        }
        if message != nil {
            messageLabel.text = message
            addSubview(messageLabel)
        }

        if let contentView = contentView {
            contentView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)

            addSubview(contentView)
        }

        if let cancelTitle = cancelButtonTitle {
            var cancelButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
            cancelButton.setTitle(cancelTitle, for: UIControl.State.normal)
            buttons.append(cancelButton)
            addSubview(cancelButton)
        }

        for otherTitle in otherButtonTitles {
            //if !otherTitle.isEmpty {
            var otherButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton

            otherButton.setTitle(otherTitle, for: UIControl.State.normal)
            buttons.append(otherButton)
            addSubview(otherButton)
            //}
        }
    }

    private func setUpDefaultAppearance() {
        self.backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1)
        if let backgroundImage = backgroundImage {
            backgroundImageView = UIImageView(frame: self.bounds)
            backgroundImageView?.image = backgroundImage
            addSubview(backgroundImageView!)
            sendSubviewToBack(backgroundImageView!)
        }

        if title != nil {
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.backgroundColor = UIColor.clear
        }

        if message != nil {
            messageLabel.numberOfLines = 0
            messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            messageLabel.textColor = UIColor.black
            messageLabel.font = UIFont.systemFont(ofSize: 13)
            messageLabel.textAlignment = NSTextAlignment.center
            messageLabel.backgroundColor = UIColor.clear
        }

        var i = 0
        for button in buttons {
            button.tag = i
            i = i+1
            button.backgroundColor = UIColor.clear
            button.setTitleColor(buttonTitleColor, for: UIControl.State.normal)
            if button.tag == cancelButtonIndex {
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            } else {
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            }
        }
    }

    private func layoutElementBeforeShowing() {
        // Reorder buttons
        if cancelButtonTitle != nil {
            if cancelButtonIndex > 0 && cancelButtonIndex < buttons.count {
                let cancelButton = buttons.remove(at: 0)
                buttons.insert(cancelButton, at: cancelButtonIndex)
            }
        }

        var i = 0
        for button in buttons {
            button.tag = i
            i = i+1

            if !buttonTitleColor.isEqual(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)) {
                button.setTitleColor(buttonTitleColor, for: UIControl.State.normal)
            }

            button.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        }

        if title != nil {
            titleLabel.frame = CGRect(x: 0, y: 0, width: viewWidth - titleSideMargin*2, height: 0)
            labelHeightToFit(label: titleLabel)
        }
        if message != nil {
            messageLabel.frame = CGRect(x: 0, y: 0, width: viewWidth - messageSideMargin*2, height: 0)
            labelHeightToFit(label: messageLabel)
        }
        if title != nil {
            titleLabel.center = CGPoint(x: viewWidth/2, y: titleTopMargin + Double(titleLabel.frame.size.height)/2)
        }
        if message != nil {
            let xvalue = viewWidth/2
            var yvalue = titleTopMargin
            //            yvalue += Double(titleLabel.frame.size.height)
            //            yvalue += titleToMessageSpacing
            //            yvalue += Double(messageLabel.frame.size.height)/2

            //            messageLabel.center = CGPoint(x: viewWidth/2, y: titleTopMargin + Double(titleLabel.frame.size.height) + titleToMessageSpacing + Double(messageLabel.frame.size.height)/2)
        }

        var topPartHeight:Double = 0  //= (contentView == nil) ? (titleTopMargin + Double(titleLabel.frame.size.height) + titleToMessageSpacing + Double(messageLabel.frame.size.height) + messageBottomMargin) : Double(contentView!.frame.size.height)
        if (contentView == nil) {
            topPartHeight += titleTopMargin
            topPartHeight += Double(titleLabel.frame.size.height)
            topPartHeight += titleToMessageSpacing
            topPartHeight += Double(messageLabel.frame.size.height)
            topPartHeight += messageBottomMargin

        } else {
            topPartHeight = Double(contentView!.frame.size.height)
        }

        if buttons.count == 2 {

            let leftButton = buttons[0]
            let rightButton = buttons[1]

            if (leftButton.title(for: UIControl.State.normal)?.isEmpty)! && (rightButton.title(for: UIControl.State.normal)?.isEmpty)! {

                buttonHeight = 0

            } else {
                buttonHeight = 44
            }

            viewHeight = topPartHeight + buttonHeight

            leftButton.frame = CGRect(x: 0, y: viewHeight-buttonHeight, width: viewWidth/2, height: buttonHeight)

            //if !(rightButton.title(for: UIControlState.normal)?.isEmpty)! {

            rightButton.frame = CGRect(x: viewWidth/2, y: viewHeight-buttonHeight, width: viewWidth/2, height: buttonHeight)
            //}

            if hideSeparator == false {
                let horLine = UIView(frame: CGRect(x: 0, y: Double(leftButton.frame.origin.y), width: viewWidth, height: kSeparatorWidth))
                horLine.backgroundColor = separatorColor
                addSubview(horLine)

                let verLine = UIView(frame: CGRect(x: viewWidth/2, y: Double(leftButton.frame.origin.y), width: kSeparatorWidth, height: Double(leftButton.frame.size.height)))
                verLine.backgroundColor = separatorColor
                addSubview(verLine)
            }

        } else {
            viewHeight = topPartHeight + buttonHeight * Double(buttons.count)
            var j = 1
            //for var i = buttons.count - 1; i >= 0; i = i - 1 {
            if buttons.count > 0 {
                for i in (buttons.count - 1)...0 {

                    let button = buttons[i]
                    button.frame = CGRect(x: 0, y: viewHeight-buttonHeight*Double(j), width: viewWidth, height: buttonHeight)
                    j = j+1
                    if hideSeparator == false {
                        let lineView = UIView(frame: CGRect(x: 0, y: Double(button.frame.origin.y), width: viewWidth, height: kSeparatorWidth))
                        lineView.backgroundColor = separatorColor
                        addSubview(lineView)
                    }
                }
            }
        }
    }

    func refreshElementBeforeShowing(view: UIView, tag: Int, flag: Int) {

        var topPartHeight:Double
        //let topPartHeight = (contentView == nil) ? (titleTopMargin + Double(titleLabel.frame.size.height) + titleToMessageSpacing + Double(messageLabel.frame.size.height) + messageBottomMargin) : Double(contentView!.frame.size.height)

        if contentView == nil {
            topPartHeight = titleTopMargin
            topPartHeight += Double(titleLabel.frame.size.height)
            topPartHeight += titleToMessageSpacing
            topPartHeight += Double(messageLabel.frame.size.height)
            topPartHeight += messageBottomMargin
        } else {
            topPartHeight = Double(contentView!.frame.size.height)
        }


        if buttons.count == 2 {

            let leftButton = buttons[0]
            let rightButton = buttons[1]

            if (leftButton.title(for: UIControl.State.normal)?.isEmpty)! && (rightButton.title(for: UIControl.State.normal)?.isEmpty)! {


                viewHeight = viewHeight - buttonHeight

            } else {
                buttonHeight = 44
                viewHeight = viewHeight + buttonHeight
            }

            if tag == 1 {
                if tag != flag {
                    viewHeight = viewHeight + 40
                } else {
                    viewHeight = viewHeight - 40
                }
            }
            else if tag == 2 {
                if tag != flag {
                    viewHeight = viewHeight + 100
                } else {
                    viewHeight = viewHeight - 100
                }
            }
            else {
                //viewHeight = viewHeight + 80
            }

            leftButton.frame = CGRect(x: 0, y: viewHeight-buttonHeight, width: viewWidth/2, height: buttonHeight)

            rightButton.frame = CGRect(x: viewWidth/2, y: viewHeight-buttonHeight, width: viewWidth/2, height: buttonHeight)

        } else {

            viewHeight = topPartHeight + buttonHeight * Double(buttons.count)

        }


        self.frame = CGRect(x: (Double(view.frame.size.width) - viewWidth)/2, y: (Double(view.frame.size.height) - viewHeight)/2, width: viewWidth, height: viewHeight)
    }

    // MARK: Actions

    @objc func buttonClicked(button: UIButton) {
        if (highlightOnButtonClicked == true) {
            let originColor = button.backgroundColor?.withAlphaComponent(0)
            button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.1)
            let delayTime =  0.1
            //dispatch_time(DispatchTime.now() + 1.0,Int64(0.2 * Double(NSEC_PER_SEC)))
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { () -> Void in
                button.backgroundColor = originColor
            })
        }

        let buttonIndex = button.tag

        //if delegate?.responds(to: Selector("alertView:clickedButtonAtIndex:")) == true {
        delegate?.alertView!(alertView: self, clickedButtonAtIndex: buttonIndex)
        //}

        if clickedButtonAction != nil {
            clickedButtonAction!(buttonIndex)
        }

        if buttonIndex == cancelButtonIndex {
            if clickedCancelButtonAction != nil {
                //clickedCancelButtonAction!(<#Void#>)
            }
        } else {
            if clickedOtherButtonAction != nil {
                clickedOtherButtonAction!(buttonIndex)
            }
        }

        if dismissOnOtherButtonClicked == true {
            dismiss()
        } else if buttonIndex == cancelButtonIndex {
            dismiss()
        }
    }

    @objc func outsideClicked(recognizer: UITapGestureRecognizer) {
        if let v = dismissOnOutsideClicked {
            if v == true {
                dismiss()
            }
        }

    }

    
    // MARK: Utils
    
    private func labelHeightToFit(label: UILabel) {
        let maxWidth = label.frame.size.width
        let maxHeight : CGFloat = 10000
        let rect = label.attributedText?.boundingRect(with: CGSize(width:maxWidth, height:maxHeight),
                                                      options: .usesLineFragmentOrigin, context: nil)

        var frame = label.frame
        frame.size.height = rect!.size.height
        label.frame = frame
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SwiftAlertView {
    static func show(title: String?, message: String?, delegate: SwiftAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles: [String]?, configureAppearance:(_ alertView: SwiftAlertView)->(Void), clickedButtonAction:@escaping (_ buttonIndex: Int)->(Void)){
        let alertView = SwiftAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
        alertView.handleClickedButtonAction(action: clickedButtonAction)
        configureAppearance(alertView)
        alertView.show()
    }
}


enum SwiftAlertViewAppearType : Int {

    case Default
    case FadeIn
    case FlyFromTop
    case FlyFromLeft
}


enum SwiftAlertViewDisappearType : Int {

    case Default
    case FadeOut
    case FlyToBottom
    case FlyToRight
}


@objc protocol SwiftAlertViewDelegate : NSObjectProtocol{

    // Called when a button is clicked.
    @objc optional func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int)

    @objc optional func willPresentAlertView(alertView: SwiftAlertView) // before animation and showing view
    @objc optional func didPresentAlertView(alertView: SwiftAlertView) // after animation

    @objc optional func willDismissAlertView(alertView: SwiftAlertView) // before animation and showing view
    @objc optional func didDismissAlertView(alertView: SwiftAlertView) // after animation

}
