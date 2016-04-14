//
//  ViewController.swift
//  EmojiKeyboard
//
//  Created by tanson on 16/4/12.
//  Copyright © 2016年 tanson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var emojiVC:EmojiKeyboardController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emojiVC = EmojiKeyboardController()
        self.addChildViewController(self.emojiVC)
        self.view.addSubview(self.emojiVC.view)
        self.emojiVC.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

