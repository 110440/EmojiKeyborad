//
//  InputMessageToolBar.swift
//  EmojiKeyboard
//
//  Created by tanson on 16/4/13.
//  Copyright © 2016年 tanson. All rights reserved.
//

import UIKit

enum InputState {
    case None
    case Text
    case Emoji
    case Audio
}

protocol InputMessageToolBarDelegate:NSObjectProtocol {
    func changeToInputState(state:InputState)
}

class InputMessageToolBar: UIView , UITextViewDelegate{
    
    weak var delegate:InputMessageToolBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var audioBtn:StateButton = {
        let states = [
            StateButtonModel(stateStr:"audio", stateImage1:UIImage(named:"ToolViewInputVoice.png")!,
                stateImage2: UIImage(named:"ToolViewInputVoiceHL.png")!),
            StateButtonModel(stateStr:"text", stateImage1:UIImage(named:"ToolViewKeyboard.png")!,
                stateImage2: UIImage(named: "ToolViewKeyboardHL.png")!) ]
        let btn = StateButton(states: states)
        btn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btn)
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.CenterY, relatedBy:.Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Left, relatedBy:.Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 5))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Width, relatedBy:.Equal, toItem:nil, attribute: .Width, multiplier: 1, constant: 35))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Height, relatedBy:.Equal, toItem:nil, attribute: .Height, multiplier: 1, constant: 35))
        
        return btn
    }()
    
    lazy var emojiBtn:StateButton = {
        let states = [
            StateButtonModel(stateStr:"emoji", stateImage1:UIImage(named:"ToolViewEmotion.png")!,
                stateImage2: UIImage(named:"ToolViewEmotionHL.png")!),
            StateButtonModel(stateStr:"text", stateImage1:UIImage(named:"ToolViewKeyboard.png")!,
                stateImage2: UIImage(named: "ToolViewKeyboardHL.png")!) ]
        let btn = StateButton(states: states)
        btn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btn)
        
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.CenterY, relatedBy:.Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Right, relatedBy:.Equal, toItem: self.sendBtn, attribute: .Left, multiplier: 1, constant: -5))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Width, relatedBy:.Equal, toItem:nil, attribute: .Width, multiplier: 1, constant: 35))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Height, relatedBy:.Equal, toItem:nil, attribute: .Height, multiplier: 1, constant: 35))
        
        return btn
    }()
    
    lazy var sendBtn:UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("发送", forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        let c:CGFloat = 218.0/255.0
        btn.layer.cornerRadius = 5.0
        btn.backgroundColor = UIColor(red:49.0/255.0, green:163.0/255.0, blue:67.0/255.0, alpha: 1)
        self.addSubview(btn)
        
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.CenterY, relatedBy:.Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Right, relatedBy:.Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -5))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Width, relatedBy:.Equal, toItem:nil, attribute: .Width, multiplier: 1, constant: 40))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Height, relatedBy:.Equal, toItem:nil, attribute: .Height, multiplier: 1, constant: 28))
        return btn
    }()
    
    lazy var inputTextView:UITextView = {
        
        let c:CGFloat = 218.0/255.0
        let view = UITextView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFontOfSize(17)
        view.layer.borderColor = UIColor(red:c, green: c, blue: c, alpha: 1).CGColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5.0
        view.scrollsToTop = false
        view.textContainerInset = UIEdgeInsetsMake(7, 5, 5, 5)
        view.backgroundColor = UIColor(red:0.97, green:0.99, blue:0.98, alpha: 1)
        view.returnKeyType = .Send
        view.enablesReturnKeyAutomatically = true
        view.layoutManager.allowsNonContiguousLayout = false
        view.scrollsToTop = false
        self.addSubview(view)
        
        self.addConstraint(NSLayoutConstraint(item:view, attribute:.CenterY, relatedBy:.Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item:view, attribute:.Right, relatedBy:.Equal, toItem: self.emojiBtn, attribute: .Left, multiplier: 1, constant: -5))
        self.addConstraint(NSLayoutConstraint(item:view, attribute:.Left, relatedBy:.Equal, toItem:self.audioBtn, attribute: .Right, multiplier: 1, constant: 5))
        self.addConstraint(NSLayoutConstraint(item:view, attribute:.Height, relatedBy:.Equal, toItem:nil, attribute: .Height, multiplier: 1, constant: 30))
        
        return view
    }()
    
    lazy var recordBtn:UIButton = {
        
        let btn = UIButton(type: UIButtonType.Custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("按住录音", forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(15)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
        //let c:CGFloat = 218.0/255.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderColor = UIColor.lightGrayColor().CGColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 5.0
        btn.backgroundColor = UIColor.clearColor()
        self.addSubview(btn)
        
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.CenterY, relatedBy:.Equal, toItem: self.inputTextView, attribute: .CenterY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.CenterX, relatedBy:.Equal, toItem: self.inputTextView, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Width, relatedBy:.Equal, toItem:self.inputTextView, attribute: .Width, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item:btn, attribute:.Height, relatedBy:.Equal, toItem:self.inputTextView, attribute: .Height, multiplier: 1, constant: 0))
        
        btn.hidden = true
        return btn
    }()
    
    private func initView(){
        
        self.backgroundColor = UIColor(colorLiteralRed: 239.0/255.0, green: 240.0/255.0, blue: 245.0/255.0, alpha: 1)
        self.layer.borderColor = UIColor(red:194.0/255.0, green: 195.0/255.0, blue: 199.0/255.0, alpha: 1).CGColor
        self.layer.borderWidth = 0.5
        
        self.audioBtn.action = { stateStr in
            if stateStr == "audio"{
                self.recordBtn.hidden = false
                self.inputTextView.hidden = true
                self.delegate?.changeToInputState(InputState.Audio)
                self.inputTextView.resignFirstResponder()
            }else{
                self.recordBtn.hidden = true
                self.inputTextView.hidden = false
                self.delegate?.changeToInputState(InputState.Text)
                self.inputTextView.becomeFirstResponder()
            }
            self.emojiBtn.reSet()
        }
        self.emojiBtn.action = { stateStr in
            if stateStr == "emoji"{
                self.delegate?.changeToInputState(InputState.Emoji)
                self.inputTextView.resignFirstResponder()
            }else{
                self.delegate?.changeToInputState(InputState.Text)
                self.inputTextView.becomeFirstResponder()
            }
            self.recordBtn.hidden = true
            self.inputTextView.hidden = false
            self.audioBtn.reSet()
        }
        self.inputTextView.delegate = self
        self.recordBtn.addTarget(self, action: #selector(recordTouchDown), forControlEvents: .TouchDown)
        self.recordBtn.addTarget(self, action: #selector(recordTouchDragOutside), forControlEvents: .TouchDragOutside)
        self.recordBtn.addTarget(self, action: #selector(recordTouchUpInside), forControlEvents: .TouchUpInside)
        self.recordBtn.addTarget(self, action: #selector(recordTouchUpOutside), forControlEvents: .TouchUpOutside)
    }
    
    func resetInputButton(){
        self.audioBtn.reSet()
        self.emojiBtn.reSet()
        self.recordBtn.hidden = true
        self.inputTextView.hidden = false
    }
    
    func setInputValue(value:String) {
        self.inputTextView.text = value
    }

    func recordTouchDown(){
        print(#function)
    }
    func recordTouchDragOutside(){
        print(#function)
    }
    func recordTouchUpInside() {
        print(#function)
    }
    func recordTouchUpOutside(){
        print(#function)
    }
    
    //MARK:- TextView delegate
    func textViewDidBeginEditing(textView: UITextView) {
        self.delegate?.changeToInputState(InputState.Text)
        self.resetInputButton()
    }
    
}

// MARK:- stateButton
struct StateButtonModel {
    var stateStr:String
    var stateImage1:UIImage
    var stateImage2:UIImage
}

class StateButton: UIButton {
    
    var action:( (stateStr:String)->Void )?
    var curStateIndex = 0
    var states:Array<StateButtonModel>!
    
    init(states:Array<StateButtonModel>){
        self.states = states
        super.init(frame: CGRectZero)
        self.reSet()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reSet(){
        self.curStateIndex = 0
        self.setImage(self.states[self.curStateIndex].stateImage1, forState: .Normal)
        self.setImage(self.states[self.curStateIndex].stateImage2, forState: .Highlighted)
        self.addTarget(self, action: #selector(touch) , forControlEvents: .TouchUpInside)
    }
    
    func touch() -> Void {
        let curStateStr = self.states[self.curStateIndex].stateStr
        self.curStateIndex += 1
        self.curStateIndex %= self.states.count
        
        self.setImage(self.states[self.curStateIndex].stateImage1, forState: .Normal)
        self.setImage(self.states[self.curStateIndex].stateImage2, forState: .Highlighted)
        
        self.action?(stateStr:curStateStr)
    }
    
}