//
//  FallbackQuestionCell.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 7/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FallbackQuestionCell: UITableViewCell {
    
    private let greenColor: UIColor = ColorTheme.btnBG
    private let deviceWidth: CGFloat = UIScreen.main.bounds.width
    
    private var questioncontainerView: UIView!
    private var questionLabel: UILabel!
    private var radioButton: UIButton!
    private var imageview: UIImageView!
    
    var callBackQuestionCell: ((inout FallbackQuestionsWithSelect) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style:UITableViewCell.CellStyle ,reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        createCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageViewImage: Bool! {
        didSet {
            radioButton.isUserInteractionEnabled = !imageViewImage
            imageview.image = (imageViewImage) ? UIImage.fontAwesomeIcon(name: .dotCircle, style: .solid, textColor: greenColor, size: CGSize(width: 30, height: 30)) : nil
        }
    }
    
    var questionModel: FallbackQuestionsWithSelect? {
        didSet {
            questionLabel.text = questionModel?.questionPart?.Question
        }
    }
}

//MARK: - Fallback Question Cell implementation
extension FallbackQuestionCell {
    private func createCellUI() {
        
        questioncontainerView = UIView()
        questioncontainerView.translatesAutoresizingMaskIntoConstraints  = false
        questioncontainerView.backgroundColor = .white
        addSubview(questioncontainerView)
        
        let textcontainerviewConstraints = [questioncontainerView.leftAnchor.constraint(equalTo: leftAnchor),
                                            questioncontainerView.topAnchor.constraint(equalTo: topAnchor),
                                            questioncontainerView.rightAnchor.constraint(equalTo: rightAnchor),
                                            questioncontainerView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(textcontainerviewConstraints)
        
        let _imageviewWidthHeight: CGFloat = 25
        
        imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        questioncontainerView.addSubview(imageview)
        
        let imageviewConstraints = [imageview.rightAnchor.constraint(equalTo: questioncontainerView.rightAnchor, constant: -10),
                                    imageview.centerYAnchor.constraint(equalTo: questioncontainerView.centerYAnchor),
                                    imageview.heightAnchor.constraint(equalToConstant: _imageviewWidthHeight),
                                    imageview.widthAnchor.constraint(equalToConstant: _imageviewWidthHeight)]
        NSLayoutConstraint.activate(imageviewConstraints)
        
        imageview.backgroundColor = .white
        imageview.image = nil
        imageview.layer.masksToBounds = true
        imageview.layer.cornerRadius = _imageviewWidthHeight/CGFloat(2)
        imageview.layer.borderColor = UIColor.darkGray.cgColor
        imageview.layer.borderWidth = 1
        
        radioButton = UIButton()
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        questioncontainerView.addSubview(radioButton)
        
        let radiobuttonConstraints = [
            radioButton.leftAnchor.constraint(equalTo: questioncontainerView.leftAnchor),
            radioButton.topAnchor.constraint(equalTo: questioncontainerView.topAnchor),
            radioButton.rightAnchor.constraint(equalTo: questioncontainerView.rightAnchor),
            radioButton.bottomAnchor.constraint(equalTo: questioncontainerView.bottomAnchor)]
        
        NSLayoutConstraint.activate(radiobuttonConstraints)
        radioButton.addTarget(self, action: #selector(selectOptoin(_:)), for: .touchUpInside)
        
        questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = UIFont(name: "Helvetica", size: 16)
        questionLabel.textColor = .darkGray
        questionLabel.minimumScaleFactor = 0.2
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.textAlignment = .left
        questionLabel.numberOfLines = 2
        questionLabel.text = questionModel?.questionPart?.Question
        questioncontainerView.addSubview(questionLabel)
        
        let questionlableConstraints = [questionLabel.leftAnchor.constraint(equalTo: questioncontainerView.leftAnchor,constant: 10),
                                        questionLabel.rightAnchor.constraint(equalTo: imageview.leftAnchor,constant: -5),
                                        questionLabel.centerYAnchor.constraint(equalTo: questioncontainerView.centerYAnchor)]
        NSLayoutConstraint.activate(questionlableConstraints)
        
    }
}

extension FallbackQuestionCell {
    @objc fileprivate func selectOptoin(_ sender: UIButton) {
        print("Chathura fallback question selected")
        if questionModel != nil {
            callBackQuestionCell!(&(questionModel)!)
        }
        questionLabel.isHidden = true
    }
}



