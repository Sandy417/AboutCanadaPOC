//
//  ContentTableViewCell.swift
//  AboutCanada
//
//  Created by Sandeep on 19/05/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    
    var content : Content? {
        didSet {
            titleLabel.text = content?.title
            let trimmedString = content?.description.trimmingCharacters(in: .whitespaces)
            descriptionLabel.text = trimmedString
        }
    }
    
    private let titleLabel : TopAlignedUILabel = {
        let titleLbl = TopAlignedUILabel()
        titleLbl.textColor = UIColor.purple
        titleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        titleLbl.textAlignment = .left
        titleLbl.sizeToFit()
        titleLbl.contentMode = UIView.ContentMode.top
        return titleLbl
    }()
    
    private let descriptionLabel : TopAlignedUILabel = {
        let descriptionLbl = TopAlignedUILabel()
        descriptionLbl.textColor = .black
        descriptionLbl.font = UIFont.systemFont(ofSize: 16)
        descriptionLbl.textAlignment = .left
        descriptionLbl.numberOfLines = 0
        descriptionLbl.sizeToFit()
        descriptionLbl.contentMode = UIView.ContentMode.top
        return descriptionLbl
    }()
    
    private let contentImage : UIImageView = {
        let contentImgView = UIImageView(image: UIImage(named:Constants.kdefaultImage1))
        contentImgView.contentMode = .scaleAspectFit
        contentImgView.clipsToBounds = true
        return contentImgView
    }()
    
    func setContentImage(image:UIImage) {
        DispatchQueue.main.async {
            self.contentImage.image = image
        }
    }
    
    private let contentImageActivityIndicator : UIActivityIndicatorView = {
        let contentImageActivityView = UIActivityIndicatorView(style: .medium)
        return contentImageActivityView
    }()
    
    func startAnimating() {
        DispatchQueue.main.async {
            self.contentImageActivityIndicator.startAnimating()
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.contentImageActivityIndicator.stopAnimating()
        }
    }
    func addSubviews() {
        addSubview(contentImage)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(contentImageActivityIndicator)
    }
    func setupConstraints() {
        //contentImage Constraints
        
        contentImage.setupLayoutAnchors(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 45)
//        contentImage.heightAnchor.constraint(equalTo: contentImage.widthAnchor, multiplier: 1.0/1.0).isActive = true
        
        //titleLabel Constraints
        
        titleLabel.setupLayoutAnchors(top: topAnchor, left: contentImage.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        //descriptionLabel Constraints
        
        descriptionLabel.setupLayoutAnchors(top: titleLabel.bottomAnchor, left: contentImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 5, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        
        //ContentImageActivityIndicator Constraints
        
        contentImageActivityIndicator.setupLayoutAnchors(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 45, heightConstant: 45)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIView {
    
    func setupLayoutAnchors (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  topConstant: CGFloat, leftConstant: CGFloat, bottomConstant: CGFloat, rightConstant: CGFloat, widthConstant: CGFloat, heightConstant: CGFloat) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *) {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: top, constant: topConstant+topInset)
            ])
        }
        if let left = left {
            NSLayoutConstraint.activate([
                leftAnchor.constraint(equalTo: left, constant: leftConstant)
            ])
        }
        if let right = right {
            NSLayoutConstraint.activate([
                rightAnchor.constraint(equalTo: right, constant: -rightConstant)
            ])
        }
        if let bottom = bottom {
            NSLayoutConstraint.activate([
                bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant-bottomInset)
            ])
        }
        if heightConstant != 0 {
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalToConstant: heightConstant)
            ])
        }
        if widthConstant != 0 {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: widthConstant)
            ])
        }
    }
}

class TopAlignedUILabel: UILabel {

    override func drawText(in rect: CGRect) {

        var updatedRect = CGRect(x: rect.origin.x,y: rect.origin.y,width: rect.width, height: rect.height)
        let fittingSize = sizeThatFits(rect.size)

        if contentMode == UIView.ContentMode.top {
            updatedRect.size.height = min(updatedRect.size.height, fittingSize.height)
        }

        super.drawText(in: updatedRect)
    }

}
