//
//  ZYColumnUpPromptView.swift
//  掌上遂宁
//
//  Created by 张宇 on 2016/10/10.
//  Copyright © 2016年 张宇. All rights reserved.
//

import UIKit

typealias editBtnClickClosure = ( Selected : Bool) -> Void

class ZYColumnUpPromptView: UIView {
    
    var editBtn : UIButton?
    // 编辑按钮回调闭包
    var clickClosure : editBtnClickClosure?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        // 初始化子控件
        let label = UILabel(frame: CGRect(x: kColumnMarginW, y: 0, width: 100, height: kColumnViewH))
        label.text = "栏目切换"
        label.textColor = UIColor.darkGrayColor()
        addSubview(label)
        
        // 切换状态按钮
        let editBtn = UIButton(frame: CGRect(x: kColumnViewW - kColumnViewH - kColumnEditBtnW - 10, y: (kColumnViewH - kColumnEditBtnH)*0.5, width: kColumnEditBtnW, height: kColumnEditBtnH))
        self.editBtn = editBtn
        editBtn.setTitle(kColumnEditBtnNorTitle, forState: .Normal)
        editBtn.setTitle(kColumnEditBtnSelTitle, forState: .Selected)
        editBtn.setBackgroundImage(UIImage(named:"columneditbutton"), forState: .Normal)
        editBtn.setBackgroundImage(UIImage(named:"columneditbutton"), forState: .Highlighted)
        editBtn.titleLabel?.font = UIFont.systemFontOfSize(kColumnEditBtnFont)
        editBtn.setTitleColor(kColumnItemColor, forState: .Normal)
//        editBtn.layer.borderWidth = 1.0
//        editBtn.layer.borderColor = kColumnItemBorderColor
//        editBtn.layer.cornerRadius = kColumnEditBtnH * 0.5
//        editBtn.addTarget(self, action: #selector(self.editButtonClick(editBtn:)), forControlEvents: .touchUpInside)
        editBtn.addTarget(self, action: #selector(self.editButtonClick(_:)), forControlEvents: .TouchUpInside)
        
        addSubview(editBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 点击事件监听
    @objc  func editButtonClick(editBtn: UIButton) {
        editBtn.selected = !editBtn.selected
        if self.clickClosure != nil {
            self.clickClosure!(Selected: editBtn.selected)
        }
    }
}
