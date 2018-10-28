//
//  ViewController.swift
//  SwichButtonTrain
//
//  Created by Ericji on 2018/10/25.
//  Copyright © 2018 Eric. All rights reserved.
//

import UIKit
import SnapKit
import YjiSlideButton

class ViewController: UIViewController {
    
    private let yjiSwitch1 = YjiSlideButton(frame: .zero)
    private let yjiSwitch2 = YjiSlideButton(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        yjiSlideButton1LayoutSetting()
        yjiSlideButton2LayoutSetting()
    }
    
    private func yjiSlideButton1LayoutSetting() {
        yjiSwitch1.delegate = self
        self.view.addSubview(yjiSwitch1)
        yjiSwitch1.setValue(NSNumber(value: 62), forKeyPath: "dragPointWidth")
        yjiSwitch1.setValue(NSNumber(value: 31), forKeyPath: "layer.cornerRadius")
        yjiSwitch1.setValue(UIImage(named: "arrow"), forKeyPath: "imageName")
        yjiSwitch1.setValue(UIFont.boldSystemFont(ofSize: 17), forKeyPath: "buttonFont")
        yjiSwitch1.setValue(UIColor.purple, forKeyPath: "buttonColor")
        yjiSwitch1.setValue(UIColor.black, forKeyPath: "buttonTextColor")
        yjiSwitch1.setValue(UIColor.white, forKeyPath: "dragPointTextColor")
        yjiSwitch1.snp.makeConstraints { (make) in
            make.height.equalTo(62)//Height+margin+margin
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(40)
        }
        
        let borderView = UIView()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.cornerRadius = (62+6)/2
        self.view.addSubview(borderView)
        self.view.sendSubviewToBack(borderView)
        borderView.snp.makeConstraints { (make) in
            make.edges.equalTo(yjiSwitch1).inset(-3)
        }
    }
    
    private func yjiSlideButton2LayoutSetting() {
        yjiSwitch2.delegate = self
        self.view.addSubview(yjiSwitch2)
        yjiSwitch2.setValue(NSNumber(value: 62), forKeyPath: "dragPointWidth")
        yjiSwitch2.setValue(NSNumber(value: 31), forKeyPath: "layer.cornerRadius")
        yjiSwitch2.setValue(UIImage(named: "arrow"), forKeyPath: "imageName")
        yjiSwitch2.setValue("滑动", forKeyPath: "buttonText")
        yjiSwitch2.setValue("解锁", forKeyPath: "buttonUnlockedText")
        yjiSwitch2.setValue(UIFont.boldSystemFont(ofSize: 17), forKeyPath: "buttonFont")
        yjiSwitch2.setValue(UIColor.white, forKeyPath: "buttonColor")
        yjiSwitch2.setValue(UIColor.red, forKeyPath: "buttonTextColor")
        yjiSwitch2.setValue(UIColor.black, forKeyPath: "dragPointTextColor")
        yjiSwitch2.setValue(UIColor(red: 104.0/255.0, green: 181.0/255.0, blue: 59.0/255.0, alpha: 1.0), forKeyPath: "gradientColor1")
        yjiSwitch2.setValue(UIColor(red: 6.0/255.0, green: 153.0/255.0, blue: 7.0/255.0, alpha: 1.0), forKeyPath: "gradientColor2")

        yjiSwitch2.snp.makeConstraints { (make) in
            make.height.equalTo(62)//Height+margin+margin
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalTo(-40)
        }
        
        let borderView = UIView()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.cornerRadius = (62+6)/2
        self.view.addSubview(borderView)
        self.view.sendSubviewToBack(borderView)
        borderView.snp.makeConstraints { (make) in
            make.edges.equalTo(yjiSwitch2).inset(-3)
        }
    }

}

extension ViewController: YjiSlideButtonDelegate {
    func buttonStatus(status:String, sender: YjiSlideButton) {
        print(status)
    }
}
