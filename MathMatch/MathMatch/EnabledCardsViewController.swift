//
//  EnabledCardsViewController.swift
//  MathMatch
//
//  Created by Kyle O'Brien on 2016.3.17.
//  Copyright © 2016 Computer Lab. All rights reserved.
//

import UIKit

class EnabledCardsViewController: UICollectionViewController {
    
    // MARK: Properties
    
    var isCardEnabled = [Bool]()
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        if let arrayFromDefaults = NSUserDefaults.standardUserDefaults().arrayForKey(kMMXUserDefaultsEnabledCards) as? [Bool] {
            self.isCardEnabled = arrayFromDefaults
        }
        else {            
            for _ in 0..<Int(MMXCardStyle.Count.rawValue) {
                self.isCardEnabled.append(true)
            }
        }
        
        super.init(coder: aDecoder);
    }
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.allowsMultipleSelection = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        MMXAudioManager.sharedManager().playSoundEffect(.TapBackward)
    }
    
    deinit {
        NSUserDefaults.standardUserDefaults().setObject(self.isCardEnabled, forKey: kMMXUserDefaultsEnabledCards)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(MMXCardStyle.Count.rawValue) - 1
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EnabledCardCell", forIndexPath: indexPath)
        if let enabledCardCell = cell as? EnabledCardCell {
            enabledCardCell.configureForEnabled(self.isCardEnabled[indexPath.row + 1])
            
            if let cardStyle = MMXCardStyle(rawValue: UInt(indexPath.row) + 1) {
                enabledCardCell.isAccessibilityElement = true
                enabledCardCell.accessibilityLabel = cardTitleForCardStyle(cardStyle)
                
                if let image = UIImage(named: MMXGameData.imageNameForStyle(cardStyle)) {
                    enabledCardCell.cardImageView.backgroundColor = UIColor(patternImage: image)
                }
            }
            
            return enabledCardCell
        }
        else {
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "EnabledCardsHeader", forIndexPath: indexPath)
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.flipEnabledForIndexPath(indexPath)
    }

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        self.flipEnabledForIndexPath(indexPath)
    }
    
    // MARK: Helper Methods
    
    func flipEnabledForIndexPath(indexPath: NSIndexPath) {
        MMXAudioManager.sharedManager().playSoundEffect(.TapNeutral);
        
        self.isCardEnabled[indexPath.row + 1] = !self.isCardEnabled[indexPath.row + 1]
        
        if let enabledCardCell = self.collectionView?.cellForItemAtIndexPath(indexPath) as? EnabledCardCell {
            UIView.animateWithDuration(0.23, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    enabledCardCell.configureForEnabled(self.isCardEnabled[indexPath.row + 1])
                }, completion: nil)
        }
    }

    // TODO: Refactor this out into a tuple or class that represents card style info.
    func cardTitleForCardStyle(cardStyle: MMXCardStyle) -> String {
        var cardTitle = ""
        
        if (cardStyle == MMXCardStyle.Beach)
        {
            cardTitle = NSLocalizedString("Beach", comment: "Descriptive name of Beach card.")
        }
        else if (cardStyle == MMXCardStyle.Checkers)
        {
            cardTitle = NSLocalizedString("Checkers", comment: "Descriptive name of Checkers card.")
        }
        else if (cardStyle == MMXCardStyle.Citrus)
        {
            cardTitle = NSLocalizedString("Citrus", comment: "Descriptive name of Citrus card.")
        }
        else if (cardStyle == MMXCardStyle.Cupcake)
        {
            cardTitle = NSLocalizedString("Cupcake", comment: "Descriptive name of Cupcake card.")
        }
        else if (cardStyle == MMXCardStyle.Emerald)
        {
            cardTitle = NSLocalizedString("Emerald", comment: "Descriptive name of Emerald card.")
        }
        else if (cardStyle == MMXCardStyle.Grass)
        {
            cardTitle = NSLocalizedString("Grass", comment: "Descriptive name of Grass card.")
        }
        else if (cardStyle == MMXCardStyle.Honey)
        {
            cardTitle = NSLocalizedString("Honey", comment: "Descriptive name of Honey card.")
        }
        else if (cardStyle == MMXCardStyle.Moon)
        {
            cardTitle = NSLocalizedString("Moon", comment: "Descriptive name of Moon card.")
        }
        else if (cardStyle == MMXCardStyle.Stars)
        {
            cardTitle = NSLocalizedString("Stars", comment: "Descriptive name of Stars card.")
        }
        else if (cardStyle == MMXCardStyle.Steel)
        {
            cardTitle = NSLocalizedString("Steel", comment: "Descriptive name of Steel card.")
        }
        else if (cardStyle == MMXCardStyle.Sushi)
        {
            cardTitle = NSLocalizedString("Sushi", comment: "Descriptive name of Sushi card.")
        }
        else if (cardStyle == MMXCardStyle.Thatch)
        {
            cardTitle = NSLocalizedString("Thatch", comment: "Descriptive name of Thatch card.")
        }
        else if (cardStyle == MMXCardStyle.Velvet)
        {
            cardTitle = NSLocalizedString("Velvet", comment: "Descriptive name of Velvet card.")
        }
        
        return cardTitle
    }
}

extension EnabledCardsViewController: UICollectionViewDelegateFlowLayout {

    func calculateGapWidthForCardsPerRow(cardsPerRow: Int) -> CGFloat
    {
        if let cl = self.collectionView {
            return floor((cl.bounds.size.width - (80.0 * CGFloat(cardsPerRow))) / (CGFloat(cardsPerRow) + 1.0))
        }
        else {
            return 0.0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let gap = self.calculateGapWidthForCardsPerRow(3)

        return UIEdgeInsetsMake(0.0, gap, gap, gap)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.calculateGapWidthForCardsPerRow(3)
    }
  
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.calculateGapWidthForCardsPerRow(3)
    }
}
