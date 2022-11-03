//
//  SwipeView+Accessibility.swift
//  SwipeCellKit
//
//  Created by korshunov on 17.10.2022.
//

import UIKit

extension SwipeView {
    /// :nodoc:
    open override func accessibilityElementCount() -> Int {
        guard state != .center else {
            return super.accessibilityElementCount()
        }

        return 1
    }

    /// :nodoc:
    open override func accessibilityElement(at index: Int) -> Any? {
        guard state != .center else {
            return super.accessibilityElement(at: index)
        }

        return actionsView
    }

    /// :nodoc:
    open override func index(ofAccessibilityElement element: Any) -> Int {
        guard state != .center else {
            return super.index(ofAccessibilityElement: element)
        }

        return element is SwipeActionsView ? 0 : NSNotFound
    }
}

extension SwipeView {
    /// :nodoc:
    open override var accessibilityCustomActions: [UIAccessibilityCustomAction]? {
        get {
            let leftActions = delegate?.swipeView(self, editActionsForSwipeableFor: .left) ?? []
            let rightActions = delegate?.swipeView(self, editActionsForSwipeableFor: .right) ?? []

            let actions = [rightActions.first, leftActions.first].compactMap({ $0 }) + rightActions.dropFirst() + leftActions.dropFirst()

            if actions.count > 0 {
                return actions.compactMap({ SwipeAccessibilityCustomAction(action: $0,
                                                                           indexPath: IndexPath(),
                                                                           target: self,
                                                                           selector: #selector(performAccessibilityCustomAction(accessibilityCustomAction:))) })
            } else {
                return super.accessibilityCustomActions
            }
        }

        set {
            super.accessibilityCustomActions = newValue
        }
    }

    @objc func performAccessibilityCustomAction(accessibilityCustomAction: SwipeAccessibilityCustomAction) -> Bool {
        let swipeAction = accessibilityCustomAction.action

        swipeAction.handler?(swipeAction, accessibilityCustomAction.indexPath)

        if swipeAction.style == .destructive {
            removeFromSuperview()
        }

        return true
    }
}
