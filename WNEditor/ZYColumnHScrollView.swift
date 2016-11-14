//
//  ZYColumnHScrollView.swift
//  掌上遂宁
//
//  Created by 张宇 on 2016/10/10.
//  Copyright © 2016年 张宇. All rights reserved.
//  水平滚动的scrollView

import UIKit

typealias titleClickClosure = ( tag: Int,  title: String) -> Void

class ZYColumnHScrollView: UIScrollView {
    // 闭包
    var backClosure : titleClickClosure?    // 分类 标题数组
    var arrayTitles = [String]() {
        didSet {
            // 创建标题按钮item
            creatScrollItems()
            // 初始化自身属性  为了匹配indicator的宽度，这个方法后调用
            doInit()
        }
    }
    // 标识是否已经初始化过了
    private var hasInit = false

    // 记录选中的title button
    private var selButton = UIButton()
    // 指示器
    private var indicator = UIView()
    // 存放按钮的数组
    private var arrayItems = [UIButton]()
}

// MARK: - 初始化方法
extension ZYColumnHScrollView {
    // 初始化一些属性
    private func doInit(){
        if hasInit {
            return
        }
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        guard kColumnHasIndicator else {return}
        let indicator = UIView(frame: CGRect(x:0, y: kColumnViewH - kColumnIndictorH, width: arrayItems[0].frame.width, height: kColumnIndictorH))      // 默认取第一个按钮的宽度
        self.indicator = indicator
        indicator.backgroundColor = kColumnIndicatorColor
        insertSubview(indicator, atIndex: 0)
        addSubview(indicator)
        hasInit = true
    }
}

// MARK: - 点击事件处理
extension  ZYColumnHScrollView {
    @objc private func itemDidClick(button : UIButton) {
        // 切换选中item
        changeItemStatus(button)
        
        // 回调
        if self.backClosure != nil {
            self.backClosure!(tag: button.tag, title: (button.titleLabel?.text)!)
        }
    }
}

// MARK: - 公共控制方法
extension ZYColumnHScrollView {
    
    // 将对应的title的item设置为选中状态
     func changeItemToSelected(title : String) {
        for item in arrayItems {
            if item.titleLabel?.text == title {
                changeItemStatus(item)
                return
            }
        }
    }
}

// MARK: - 私有控制方法
extension ZYColumnHScrollView {
    // 添加横向滚动的item
    private func creatScrollItems(){
        // 先移除已经创建了的
        for item in arrayItems {
            item.removeFromSuperview()
        }
        arrayItems.removeAll()
        
        var sumItemW:CGFloat = 0.0
        for i in 0 ..< self.arrayTitles.count{
            let title = arrayTitles[i]
            let item = UIButton()
            item.setTitle(title, forState: UIControlState.Normal)
            item.sizeToFit()
            item.setTitleColor(kColumnTitleNorColor, forState: UIControlState.Normal)
            item.setTitleColor(kColumnTitleSelColor, forState: UIControlState.Selected)
            item.titleLabel?.font = UIFont.systemFontOfSize(kColumnTitleNorFont)
            item.frame.size = CGSize(width: (item.frame.width + kColumnTitleMargin) > kColumnIndictorMinW ? item.frame.width + kColumnTitleMargin : kColumnIndictorMinW, height: kColumnHasIndicator ? kColumnViewH - kColumnIndictorH : kColumnViewH)     // 增加按钮宽度，达到间隙效果
            item.frame = CGRect(x: sumItemW, y: 0, width: item.frame.width, height: item.frame.height)
            sumItemW += item.frame.width
            item.tag = i
            
            item.addTarget(self, action: #selector(self.itemDidClick(_:)), forControlEvents: .TouchUpInside)
            
            arrayItems.append(item)
            addSubview(item)
            contentSize = CGSize(width: sumItemW, height: 0)
        }
    }
    
    // 改变选中按钮状态
    private func changeItemStatus(button : UIButton) {
        selButton.titleLabel?.font = UIFont.systemFontOfSize(kColumnTitleNorFont);        selButton.selected = false
        button.titleLabel?.font = UIFont.systemFontOfSize(kColumnTitleSelFont)
        button.selected = true
        selButton = button
        autoSuitItemsPosition()

        UIView.animateWithDuration(0.3) { 
            self.indicator.frame = CGRect(x: button.frame.origin.x, y: kColumnViewH - kColumnIndictorH, width: button.frame.width, height: kColumnIndictorH)
        }
        
    }
    
    // 自动匹配scrollView 的位置，让选中的置于中间位置
    private func autoSuitItemsPosition() {
       
        
        UIView.animateWithDuration(kSpreadDuration) {
            
            if self.contentSize.width > self.frame.size.width {
                var desiredX = self.selButton.center.x - self.bounds.width/2
                if desiredX < 0 {
                    desiredX = 0
                }
                if desiredX > (self.contentSize.width - self.bounds.width) {
                    desiredX = self.contentSize.width - self.bounds.width
                }
                if !(self.bounds.width > self.contentSize.width) {
                    self.setContentOffset(CGPoint(x: desiredX, y: 0), animated: true)
                }
            }

            
        }
        
        
    }
}
