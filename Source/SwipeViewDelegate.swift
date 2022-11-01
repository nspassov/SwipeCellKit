//
//  SwipeViewDelegate.swift
//  SwipeCellKit
//
//  Created by korshunov on 20.10.2022.
//

import UIKit

public protocol SwipeViewDelegate: AnyObject {
    func swipeView(_ view: SwipeView, canBeginEditingSwipeableFor orientation: SwipeActionsOrientation) -> Bool
    func swipeView(_ view: SwipeView, editActionsForSwipeableFor orientation: SwipeActionsOrientation) -> [SwipeAction]?
    func swipeView(_ view: SwipeView, editActionsOptionsForSwipeableFor orientation: SwipeActionsOrientation) -> SwipeOptions
    func swipeView(_ view: SwipeView, visibleRectFor scrollView: UIScrollView) -> CGRect?
    func swipeView(_ view: SwipeView, willBeginEditingSwipeableFor orientation: SwipeActionsOrientation)
    func swipeView(_ view: SwipeView, didEndEditingSwipeableFor orientation: SwipeActionsOrientation)
}

public extension SwipeViewDelegate {
    func swipeView(_ view: SwipeView, canBeginEditingSwipeableFor orientation: SwipeActionsOrientation) -> Bool {
        return true
    }

    func swipeView(_ view: SwipeView, visibleRectFor scrollView: UIScrollView) -> CGRect? {
        return nil
    }

    func swipeView(_ view: SwipeView, willBeginEditingSwipeableFor orientation: SwipeActionsOrientation) {}

    func swipeView(_ view: SwipeView, didEndEditingSwipeableFor orientation: SwipeActionsOrientation) {}
}
