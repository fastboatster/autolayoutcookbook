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
    
    @IBAction func addEntry(_ sender: AnyObject) {
        
        let stack = stackView
        let index = (stack?.arrangedSubviews.count)! - 1
        let addView = stack?.arrangedSubviews[index]
        
        let scroll = scrollView
        let offset = CGPoint(x: (scroll?.contentOffset.x)!,
                             y: (scroll?.contentOffset.y)! + (addView?.frame.size.height)!)
        
        let newView = createEntry()
        newView.isHidden = true
        stack?.insertArrangedSubview(newView, at: index)
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            newView.isHidden = false
            scroll?.contentOffset = offset
        }) 
    }
    
    
    @objc func deleteStackView(_ sender: UIButton) {
        if let view = sender.superview {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                view.isHidden = true
                }, completion: { (success) -> Void in
                    view.removeFromSuperview()
            })
        }
    }
    
    
    
    // MARK: - Private Methods
    fileprivate func createEntry() -> UIView {
        let date = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        let number = "\(randomHexQuad())-\(randomHexQuad())-\(randomHexQuad())-\(randomHexQuad())"
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        stack.spacing = 8
        
        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
        let numberLabel = UILabel()
        numberLabel.text = number
        numberLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        
        let deleteButton = UIButton(type: .roundedRect)
        deleteButton.setTitle("Delete", for: UIControlState())
        deleteButton.addTarget(self, action: #selector(DynamicStackViewStoryboardController.deleteStackView(_:)), for: .touchUpInside)
        
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(numberLabel)
        stack.addArrangedSubview(deleteButton)
        
        return stack
    }
    
    fileprivate func randomHexQuad() -> String {
        return NSString(format: "%X%X%X%X",
                        arc4random() % 16,
                        arc4random() % 16,
                        arc4random() % 16,
                        arc4random() % 16
            ) as String
    }

}
