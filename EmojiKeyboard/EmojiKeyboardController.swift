//
//  EmojiKeyboard.swift
//  EmojiKeyboard
//
//  Created by tanson on 16/4/13.
//  Copyright © 2016 tanson. All rights reserved.
//

import UIKit

private let inputMessageToolBarHeight:CGFloat = 50
private let emojiViewBoardHeight:CGFloat = 190
private let bottomViewHeight:CGFloat = 30
private let emojiKeyboradHeight:CGFloat = inputMessageToolBarHeight+emojiViewBoardHeight+bottomViewHeight

class EmojiKeyboardController: UIViewController {
    
    var inputState:InputState = InputState.None
    
    
    lazy var containerView:UIView = {
        let size = self.view.bounds.size
        let frame = CGRect(x: 0, y: size.height-inputMessageToolBarHeight, width: size.width, height: emojiKeyboradHeight)
        let view = UIView(frame: frame)
        return view
    }()
    
    lazy var inputToolBar:InputMessageToolBar = {
        let size = self.view.bounds.size
        let frame = CGRect(x: 0, y:0 , width: size.width, height: inputMessageToolBarHeight)
        let toolbar = InputMessageToolBar(frame:frame)
        toolbar.delegate = self
        return toolbar
    }()
    
    lazy var emojiView:EmojiSelectView = {
        let size = self.view.bounds.size
        let frame = CGRect(x: 0, y:inputMessageToolBarHeight, width: size.width, height: emojiViewBoardHeight)
        let view = EmojiSelectView(frame: frame)
        view.emojiSelectDelegate = self
        return view
    }()
    
    lazy var pageCtl:UIPageControl = {
        let size = self.view.bounds.size
        let frame = CGRect(x: 0, y: 0, width: size.width, height: bottomViewHeight)
        let pageCtl = UIPageControl(frame: frame)
        pageCtl.currentPageIndicatorTintColor = UIColor.darkGrayColor()
        pageCtl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageCtl.numberOfPages = 5
        return pageCtl
    }()
    
    lazy var bottomView:UIView = {
        let size = self.view.bounds.size
        let frame = CGRect(x: 0, y: inputMessageToolBarHeight+emojiViewBoardHeight, width: size.width, height: bottomViewHeight)
        let view = UIView(frame:frame)
        view.backgroundColor =  EmojiKeyBoardBGColor
        return view
    }()
    
    var keyboardObserverManager:KeyboardManager = {
        let m = KeyboardManager()
        return m
    }()
    
    func avoidTheSystemKeyborad(keyboradHeight:CGFloat){
        let size = self.view.bounds.size
        self.containerView.frame.origin.y = size.height - keyboradHeight - inputMessageToolBarHeight
    }
    
    func showEmojiView(){
        let size = self.view.bounds.size
        let y = size.height - emojiKeyboradHeight
        UIView.animateWithDuration(0.3) {
            self.containerView.frame.origin.y = y
        }
    }
    
    func moveToViewBottom(){
        let size = self.view.bounds.size
        UIView.animateWithDuration(0.3) {
            self.containerView.frame.origin.y = size.height - inputMessageToolBarHeight
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.inputToolBar)
        self.containerView.addSubview(self.emojiView)
        self.containerView.addSubview(self.bottomView)
        self.bottomView.addSubview(self.pageCtl)
        
        self.keyboardObserverManager.animateWhenKeyboardAppear = { height in
            self.avoidTheSystemKeyborad(height)
        }
        
        self.keyboardObserverManager.animateWhenKeyboardDisappear = { height in
            if self.inputState != .Emoji{
                let size = self.view.bounds.size
                self.containerView.frame.origin.y = size.height - inputMessageToolBarHeight
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.inputState == .Emoji{
            self.moveToViewBottom()
        }else{
            self.view.endEditing(true)
        }
        self.inputToolBar.resetInputButton()
    }
}

//MARK:- EmojiSelectView delegate
extension EmojiKeyboardController:EmojiSelectViewDelegate{
    func didSelectEmoji(emojiText: String) {
        let oldValue = self.inputToolBar.inputTextView.text
        self.inputToolBar.setInputValue(oldValue + emojiText)
    }
    
    func didTapBackspace() {
        self.inputToolBar.setInputValue("")
    }
    func changeToPage(page: Int) {
        self.pageCtl.currentPage = page
    }
}

//MARK:- InputMessageToolBar delegate
extension EmojiKeyboardController:InputMessageToolBarDelegate{
    func changeToInputState(state: InputState) {
//        print(state)
        self.inputState = state
        switch self.inputState {
        case .Emoji:
            self.showEmojiView()
        case .Text:
            self.inputToolBar.resetInputButton()
        case .Audio:
            self.moveToViewBottom()
        default:
            break
        }
    }
}
