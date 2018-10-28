//
//  YjiSlideButton.swift
//  YjiSlideButton
//
//  Created by Ericji on 2018/10/25.
//  Copyright © 2018 Eric. All rights reserved.
//

import Foundation
import UIKit

public protocol YjiSlideButtonDelegate {
    func buttonStatus(status:String, sender: YjiSlideButton)
}

@IBDesignable open class YjiSlideButton: UIView {
    
    open var delegate: YjiSlideButtonDelegate?
    
    // property
    @IBInspectable var dragPointWidth: CGFloat = 70
    @IBInspectable var buttonText: String = "UNLOCK"
    @IBInspectable var imageName: UIImage = UIImage()
    @IBInspectable var buttonColor: UIColor = UIColor.gray              // button‘s color
    @IBInspectable var buttonTextColor: UIColor = UIColor.white         // button text color
    @IBInspectable var dragPointTextColor: UIColor = UIColor.white      // drag text color
    @IBInspectable var buttonUnlockedTextColor: UIColor = UIColor.white // complete text color
    @IBInspectable var gradientColor1: UIColor = UIColor.yellow
    @IBInspectable var gradientColor2: UIColor = UIColor.red
    @IBInspectable var buttonFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
    @IBInspectable var buttonCornerRadius: CGFloat = 30
    @IBInspectable var buttonUnlockedText: String  = "UNLOCKED"
    
    private let dragPoint = UIView()
    private let buttonLabel = UILabel()
    private let dragPointButtonLabel = UILabel()
    private let imageView = UIImageView()
    private var unlocked = false
    
    var contentWidth: CGFloat {
        return self.frame.size.width
    }
    
    var contentHeight: CGFloat {
        return self.frame.size.height
    }
    
    public override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.setUpButton()
    }
    
    func setUpButton() {
        self.backgroundColor = buttonColor
        self.layer.masksToBounds = true
        
        self.dragPoint.frame = CGRect(x: dragPointWidth - contentWidth, y: 0, width: contentWidth, height: contentHeight)
        let fradColorView = GradientView(startColor: self.gradientColor1, endColor: self.gradientColor2, frame: self.dragPoint.bounds)
        self.dragPoint.addSubview(fradColorView)
        self.dragPoint.layer.cornerRadius = buttonCornerRadius
        self.dragPoint.layer.masksToBounds = true
        self.addSubview(self.dragPoint)
        
        if !self.buttonText.isEmpty{
            
            self.buttonLabel.frame = CGRect(x: 0, y: 0, width: contentWidth, height: contentHeight)
            self.buttonLabel.textAlignment = .center
            self.buttonLabel.text = buttonText
            self.buttonLabel.textColor = UIColor.white
            self.buttonLabel.font = self.buttonFont
            self.buttonLabel.textColor = self.buttonTextColor
            self.addSubview(self.buttonLabel)
            
            self.dragPointButtonLabel.frame = CGRect(x: 0, y: 0, width: contentWidth, height: contentHeight)
            self.dragPointButtonLabel.textAlignment = .center
            self.dragPointButtonLabel.text = buttonText
            self.dragPointButtonLabel.textColor = UIColor.white
            self.dragPointButtonLabel.font = self.buttonFont
            self.dragPointButtonLabel.textColor = self.dragPointTextColor
            self.dragPoint.addSubview(self.dragPointButtonLabel)
        }
        self.bringSubviewToFront(self.dragPoint)
        
        if self.imageName != UIImage() {
            self.imageView.frame = CGRect(x: contentWidth - dragPointWidth, y: 0, width: self.dragPointWidth, height: contentHeight)
            self.imageView.contentMode = .center
            self.imageView.image = self.imageName
            self.dragPoint.addSubview(self.imageView)
        }
        
        // start detecting pan gesture
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panDetected(sender:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        self.dragPoint.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func panDetected(sender: UIPanGestureRecognizer) {
        guard self.unlocked == false else {
            return
        }
        var translatedPoint = sender.translation(in: self)
        translatedPoint = CGPoint(x: translatedPoint.x, y: contentHeight / 2)
        sender.view?.frame.origin.x = (dragPointWidth - contentWidth) + translatedPoint.x
        if sender.state == .ended {
            let velocityX = sender.velocity(in: self).x * 0.2
            var finalX    = translatedPoint.x + velocityX
            if finalX < 0{
                finalX = 0
            }else if finalX + self.dragPointWidth >  (contentWidth*0.8) {
                if finalX + self.dragPointWidth < contentWidth {
                    unlocked = true
                    self.unlock(with: true)
                } else {
                    unlocked = true
                    self.unlock(with: false)
                }
            }
            
            let animationDuration:Double = abs(Double(velocityX) * 0.0002) + 0.2
            UIView.transition(with: self, duration: animationDuration, options: UIView.AnimationOptions.curveEaseOut, animations: {
                }, completion: { (Status) in
                    if Status{
                        self.animationFinished()
                    }
            })
        } else if sender.state == .changed {
            if dragPoint.frame.origin.x > 0 {
                dragPoint.frame.origin.x = 0
            }
        }
    }
    
    func animationFinished() {
        if !unlocked{
            self.reset()
        }
    }
    
    //lock button animation (SUCCESS)
    func unlock(with animated: Bool) {
        if animated {
            UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
                self.dragPoint.frame = CGRect(x: self.contentWidth - self.dragPoint.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
            }) { (Status) in
                if Status{
                    self.imageView.isHidden = true
                    self.dragPointButtonLabel.text = self.buttonUnlockedText
                    self.dragPointButtonLabel.textColor = self.buttonUnlockedTextColor
                    self.delegate?.buttonStatus(status: "Unlocked", sender: self)
                }
            }
        } else {
            self.dragPoint.frame = CGRect(x: contentWidth - self.dragPoint.frame.size.width, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
            self.imageView.isHidden = true
            self.dragPointButtonLabel.text = self.buttonUnlockedText
            self.dragPointButtonLabel.textColor = self.buttonUnlockedTextColor
            self.delegate?.buttonStatus(status: "Unlocked", sender: self)
        }
    }
    
    //reset button animation (RESET)
    func reset() {
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.dragPointWidth - self.contentWidth, y: 0, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (Status) in
            if Status{
                self.dragPointButtonLabel.text = self.buttonText
                self.imageView.isHidden = false
                self.dragPointButtonLabel.textColor = self.dragPointTextColor
                self.unlocked = false
                //self.delegate?.buttonStatus("Locked")
            }
        }
    }
}


private class GradientView: UIView {
    
    private let gradient = CAGradientLayer()
    private let startColor: UIColor
    private let endColor: UIColor
    
    init(startColor: UIColor, endColor: UIColor, frame: CGRect) {
        self.startColor = startColor
        self.endColor = endColor
        super.init(frame: frame)
    }
    
    convenience override init(frame: CGRect) {
        self.init(startColor: UIColor.red, endColor: UIColor.yellow, frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        if let sublayers = self.layer.sublayers, sublayers.contains(gradient) {
            return
        }
        // Drawing code
        let path = UIBezierPath(rect: rect)
        gradient.frame = path.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask
        self.layer.addSublayer(gradient)
    }
    
}
