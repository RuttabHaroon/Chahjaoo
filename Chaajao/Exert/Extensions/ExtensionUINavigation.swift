
import Foundation
import UIKit

extension UINavigationController {
    func fixNavigationItemsMargin(_ margin: CGFloat = 8) {
        let systemMajorVersion = ProcessInfo.processInfo.operatingSystemVersion.majorVersion
        if systemMajorVersion >= 11 {
            // iOS >= 11
            guard let contentView = navigationBar.subviews
                .first(
                    where: { sub in
                        String(describing: sub).contains("ContentView")
                }) else { return }
            
            // refer to: https://www.matrixprojects.net/p/uibarbuttonitem-ios11/
            // if rightBarButtonItems has not any custom views, then margin would be 8(320|375)/12(414)
            // should use customView
            let needAdjustRightItems: Bool
            if let currentVC = viewControllers.last,
                let rightItems = currentVC.navigationItem.rightBarButtonItems,
                rightItems.count > 0,
                rightItems.filter({ $0.customView != nil }).count > 0 {
                needAdjustRightItems = true
            } else {
                //print("Use 8(320|375)/12(414), if need precious margin ,use UIBarButtonItem(customView:)!!!")
                needAdjustRightItems = false
            }
            
            let needAdjustLeftItems: Bool
            if let currentVC = viewControllers.last,
                let leftItems = currentVC.navigationItem.leftBarButtonItems,
                leftItems.count > 0,
                leftItems.filter({ $0.customView != nil }).count > 0 {
                needAdjustLeftItems = true
            } else {
                //print("Use 8(320|375)/12(414), if need precious margin ,use UIBarButtonItem(customView:)!!!")
                needAdjustLeftItems = false
            }
            
            let layoutMargins: UIEdgeInsets
            if #available(iOS 11.0, *) {
                let directionInsets = contentView.directionalLayoutMargins
                layoutMargins = UIEdgeInsets(
                    top: directionInsets.top,
                    left: directionInsets.leading,
                    bottom: directionInsets.bottom,
                    right: directionInsets.trailing)
            } else {
                layoutMargins = contentView.layoutMargins
            }
            
            contentView.constraints.forEach(
                { cst in
                    
                    // iOS 11 the distance between rightest item and NavigationBar should be  margin
                    // rightStackView trailing space is -margin / 2
                    // rightestItem trailing to rightStackView trailing is -margin / 2
                    let rightConstant = -margin / 2
                    
                    switch (cst.firstAttribute, cst.secondAttribute) {
                    case (.leading, .leading), (.trailing, .trailing):
                        
                        if let stackView = cst.firstItem as? UIStackView,
                            stackView.frame.minX < navigationBar.frame.midX {
                            // is leftItems
                            if needAdjustLeftItems {
                                cst.constant = margin - layoutMargins.left
                            }
                        } else if let layoutGuide = cst.firstItem as? UILayoutGuide,
                            layoutGuide.layoutFrame.minX < navigationBar.frame.midX {
                            // is leftItems
                            if needAdjustLeftItems {
                                cst.constant = margin - layoutMargins.left
                            }
                        }
                        
                        if let stackView = cst.firstItem as? UIStackView,
                            stackView.frame.maxX > navigationBar.frame.midX {
                            // is rightItems
                            if needAdjustRightItems {
                                cst.constant = rightConstant
                            }
                        } else if let layoutGuide = cst.firstItem as? UILayoutGuide,
                            layoutGuide.layoutFrame.maxX > navigationBar.frame.midX {
                            // is rightItems
                            if needAdjustRightItems {
                                cst.constant = rightConstant
                            }
                        }
                        
                    default: break
                    }
                    
            })
            
            // ensure items space == 8， minispcae
            contentView.subviews.forEach(
                { subsub in
                    guard subsub is UIStackView else { return }
                    subsub.constraints.forEach(
                        { cst in
                            guard cst.firstAttribute == .width
                                || cst.secondAttribute == .width
                                else { return }
                            cst.constant = 0
                    })
            })
            
        } else {
            // iOS < 11
            
            let versionItemsCount: Int
            if systemMajorVersion == 10 {
                // iOS 10 navigationItem.rightBarButtonItems == 0
                // space = 16(320|375) / 20(414)
                // should adjust margin
                versionItemsCount = 0
            } else {
                // iOS 9 navigationItem.rightBarButtonItems == 0
                // space = 8(320|375) / 12(414)
                // should not adjust margin
                versionItemsCount = 1
            }
            
            let spaceProducer = { () -> UIBarButtonItem in
                let spaceItem = UIBarButtonItem(
                    barButtonSystemItem: .fixedSpace,
                    target: nil,
                    action: nil)
                spaceItem.width = margin - 16
                return spaceItem
            }
            if let currentVC = viewControllers.last,
                var rightItems = currentVC.navigationItem.rightBarButtonItems,
                rightItems.count > versionItemsCount,
                let first = rightItems.first {
                
                // ensure the first BarButtonItem is NOT fixedSpace
                if first.title == nil && first.image == nil && first.customView == nil {
                    //print("rightBarButtonItems SPACE SETTED!!!  SPACE: ", abs(first.width))
                    
                } else {
                    rightItems.insert(spaceProducer(), at: 0)
                    
                    // arranged right -> left
                    currentVC.navigationItem.rightBarButtonItems = rightItems
                }
            }
            
            if let currentVC = viewControllers.last,
                var leftItems = currentVC.navigationItem.leftBarButtonItems,
                leftItems.count > versionItemsCount,
                let first = leftItems.first {
                if first.title == nil && first.image == nil && first.customView == nil {
                    //print("leftBarButtonItems  SPACE SETTED!!!  SPACE: ", abs(first.width))
                } else {
                    leftItems.insert(spaceProducer(), at: 0)
                    
                    // arranged left -> right
                    currentVC.navigationItem.leftBarButtonItems = leftItems
                }
            }
        }
    }
}
