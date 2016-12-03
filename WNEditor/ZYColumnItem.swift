//
//  ZYColumnItem.swift
//  掌上遂宁
//
//  Created by 张宇 on 2016/10/10.
//  Copyright © 2016年 张宇. All rights reserved.
//

import UIKit

typealias delClickClosure = ( item : ZYColumnItem) -> Void

class ZYColumnItem: UIView {
     var title : String!{
        didSet {
            doInit()
        }
    }
    // 标识是否是固定的，固定的item没有圆角，没有背景色效果的
     var isFixed = false {
        didSet {
            if isFixed {
                setupFixedItem()
            }
        }
    }
    
    var delClosure : delClickClosure?
    
    var delBtn = UIButton()
    
    // 拉大item大小
    func scaleItemToLarge() {
        for item in subviews {
            
            if item.isKindOfClass(UIButton.self) && item.frame.width == self.frame.width {
                item.bounds = CGRect(x: 0, y: 0, width: self.frame.width * 1.2, height: self.frame.height * 1.2)
            }
        }
    }
    // 还原item大小
    func scaleItemToOriginal() {
        for item in subviews {
            if item.isKindOfClass(UIButton.self) && item.frame.width > self.frame.width {
                item.bounds = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            }
        }
    }
    
    private func doInit(){
        // 添加按钮
        let item = UIButton()
        item.frame = CGRect(x:0 , y: 0, width:self.frame.width, height: self.frame.height)
        item.setTitle(title, forState: .Normal)
        item.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        item.setBackgroundImage(UIImage(named: "column_item_bg@2x.png"), forState:.Normal)
        item.userInteractionEnabled = false
        if ((title as NSString).length == 4)  {
            item.titleLabel?.font = UIFont.systemFontOfSize(13)
        } else if ((title as NSString).length == 3) {
            item.titleLabel?.font = UIFont.systemFontOfSize(15)

        } else {
            item.titleLabel?.font = UIFont.systemFontOfSize(16)

        }
        self.addSubview(item)
        // 添加删除图标
        let WH = ZYinch55() ? 20 : (ZYinch47() ? 16 : 14)
        delBtn = UIButton(frame: CGRect(x: -1, y: -4, width: WH, height: WH))
        delBtn.setImage(UIImage(named: "column_edit_delete@2x.png"), forState: .Normal)
        
        delBtn.addTarget(self, action: #selector(self.delBtnDidClick(_:)), forControlEvents: .TouchUpInside)
        
        delBtn.hidden = true
        addSubview(delBtn)
        
    }
    
    private func setupFixedItem() {
        for button in subviews {
            // 判断不是删除的按钮
            if button.frame.width == self.frame.width && button.isKindOfClass(UIButton.self) {
                let btn : UIButton = button as! UIButton
                btn.setBackgroundImage(nil, forState: .Normal)
            }
        }
    }
    
    @objc private func delBtnDidClick(delBtn : UIButton) {
        // 闭包传值
        if self.delClosure != nil {
            self.delClosure!(item: self)
        }
    }
}
