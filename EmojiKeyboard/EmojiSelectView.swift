//
//  EmojiSelectView.swift
//  EmojiKeyboard
//
//  Created by tanson on 16/4/12.
//  Copyright © 2016年 tanson. All rights reserved.
//

import UIKit

private let ExpressionBundle = NSBundle(URL: NSBundle.mainBundle().URLForResource("Expression", withExtension: "bundle")!)
private let ExpressionPlist = NSBundle.mainBundle().pathForResource("Expression", ofType: "plist")

private let numberPerRow:CGFloat = 8.0
private let numberPerCol:CGFloat = 3.0
private let numberPerPage = Int(numberPerRow * numberPerCol) - 1

struct EmojiModel {
    var image:UIImage
    var text:String
}

protocol EmojiSelectViewDelegate{
    func didSelectEmoji(emojiText:String)
    func didTapBackspace()
    func changeToPage(page:Int)
}

class EmojiSelectView: UICollectionView{

    var emojiSelectDelegate:EmojiSelectViewDelegate?
    
    lazy var emojiList:Array<EmojiModel> = {
        
        var emojiList = [EmojiModel]()
        
        guard let emojiArray = NSArray(contentsOfFile:ExpressionPlist!)  else {
            return emojiList
        }
        for data in  emojiArray {
            
            let emojiDic  = data as! NSDictionary
            var imageName = emojiDic["image"] as! String ; imageName = "\(imageName)@2x"
            var emojiText = emojiDic["text"] as! String
            
            let image = UIImage(contentsOfFile: (ExpressionBundle!.pathForResource(imageName, ofType: "png"))!)
            let model = EmojiModel(image:image!, text: emojiText)
            emojiList.append(model)
        }
        return emojiList
        
    }()
    
    var numberOfEmojiSection:Int{
        return Int(ceil( Float(self.emojiList.count ) / Float(numberPerPage)))
    }
    
    //transpose line/row
    private func emojiForIndexPath(indexPath: NSIndexPath) -> EmojiModel? {
        let page = indexPath.section
        var index = page * numberPerPage + indexPath.row
        
        let ip = index / numberPerPage  //重新计算的所在 page
        let ii = index % numberPerPage  //重新计算的所在 index
        let reIndex = (ii % 3) * Int(numberPerRow) + (ii / 3)  //最终在数据源里的 Index
        
        index = reIndex + ip * numberPerPage
        if index < self.emojiList.count {
            return self.emojiList[index]
        } else {
            return nil
        }
    }
    
    init(frame:CGRect){
        
        let paddingLeft:CGFloat = 5
        let paddingRight:CGFloat = 5
        
        let itemWidth   = (frame.size.width - paddingLeft - paddingRight) / numberPerRow
        let itemHeight  = frame.size.height / numberPerCol
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(itemWidth, itemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight)
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.dataSource = self
        self.delegate = self
        self.pagingEnabled = true
        self.backgroundColor = EmojiKeyBoardBGColor
        self.showsHorizontalScrollIndicator = false
        self.registerClass(EmojiCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - @protocol UICollectionViewDelegate
extension EmojiSelectView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == numberPerPage{
            self.emojiSelectDelegate?.didTapBackspace()
            return
        }
        if let emojiModel = self.emojiForIndexPath(indexPath){
            self.emojiSelectDelegate?.didSelectEmoji(emojiModel.text)
        }
    }
}

// MARK: - @protocol UICollectionViewDataSource
extension EmojiSelectView: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.numberOfEmojiSection
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(numberPerPage)+1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! EmojiCell
        
        if indexPath.row == numberPerPage {
            cell.imageView.image = UIImage(contentsOfFile: (ExpressionBundle!.pathForResource("emotion_delete_highlighted@2x", ofType: "png"))!)
        }else{
            if let image = self.emojiForIndexPath(indexPath)?.image{
                cell.imageView.image = image
            }
        }
        return cell
    }
}

// MARK: - @protocol UIScrollViewDelegate
extension EmojiSelectView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth: CGFloat = self.bounds.size.width
        let currentPage = Int(self.contentOffset.x / pageWidth)
        self.emojiSelectDelegate?.changeToPage(currentPage)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
}

//MARK:- EmojiCell
class EmojiCell:UICollectionViewCell{
    var imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imageView)
        self.contentView.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: 32))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 32))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}

