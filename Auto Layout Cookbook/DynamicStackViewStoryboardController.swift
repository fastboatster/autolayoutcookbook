//
//  DynamicStackViewStoryboardController.swift
//  Auto Layout Cookbook
//
//  Created by Sergey Mukhin on 7/6/18.
//  Copyright © 2018 Rich Warren. All rights reserved.
//

import Foundation
import UIKit

class DynamicStackViewStoryboardController: UIViewController {
//    MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var stackView: UIStackView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup scrollview
        let insets = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
    }
    
    
    
    // MARK: Action Methods
    
    @IBAction func addEntry(sender: AnyObject) {
        
        let stack = stackView
        let index = stack.arrangedSubviews.count - 1
        let addView = stack.arrangedSubviews[index]
        
        let scroll = scrollView
        let offset = CGPoint(x: scroll.contentOffset.x,
                             y: scroll.contentOffset.y + addView.frame.size.height)
        
        let newView = createEntry()
        newView.hidden = true
        stack.insertArrangedSubview(newView, atIndex: index)
        
        UIView.animateWithDuration(0.25) { () -> Void in
            newView.hidden = false
            scroll.contentOffset = offset
        }
    }
    
    
    func deleteStackView(sender: UIButton) {
        if let view = sender.superview {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                view.hidden = true
                }, completion: { (success) -> Void in
                    view.removeFromSuperview()
            })
        }
    }
    
    
    
    // MARK: - Private Methods
    private func createEntry() -> UIView {
        let date = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .NoStyle)
        let number = "\(randomHexQuad())-\(randomHexQuad())-\(randomHexQuad())-\(randomHexQuad())"
        
        let stack = UIStackView()
        stack.axis = .Horizontal
        stack.alignment = .FirstBaseline
        stack.distribution = .Fill
        stack.spacing = 8
        
        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        let numberLabel = UILabel()
        numberLabel.text = number
        numberLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        
        let deleteButton = UIButton(type: .RoundedRect)
        deleteButton.setTitle("Delete", forState: .Normal)
        deleteButton.addTarget(self, action: "deleteStackView:", forControlEvents: .TouchUpInside)
        
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(numberLabel)
        stack.addArrangedSubview(deleteButton)
        
        return stack
    }
    
    private func randomHexQuad() -> String {
        return NSString(format: "%X%X%X%X",
                        arc4random() % 16,
                        arc4random() % 16,
                        arc4random() % 16,
                        arc4random() % 16
            ) as String
    }

}