//
//  SwipeView.swift
//  SwipeCellKit
//
//  Created by korshunov on 17.10.2022.
//

import UIKit

open class SwipeView: UIView {

    /// The object that acts as the delegate of the `SwipeViewDelegate`.
    public weak var delegate: SwipeViewDelegate?

    var state = SwipeState.center
    var actionsView: SwipeActionsView?
    var scrollView: UIScrollView? {
        return swipeRecognizer
    }

    var indexPath: IndexPath? { IndexPath() }

    var panGestureRecognizer: UIGestureRecognizer {
        return swipeController.panGestureRecognizer
    }

    var swipeController: SwipeController!

    weak var swipeRecognizer: SwipeRecognizable?

    /// :nodoc:
    open override var frame: CGRect {
        set { super.frame = state.isActive ? CGRect(origin: CGPoint(x: frame.minX, y: newValue.minY), size: newValue.size) : newValue }
        get { return super.frame }
    }

    /// :nodoc:
    open override var layoutMargins: UIEdgeInsets {
        get {
            return frame.origin.x != 0 ? swipeController.originalLayoutMargins : super.layoutMargins
        }
        set {
            super.layoutMargins = newValue
        }
    }

    /// :nodoc:
    override public init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configure()
    }

    deinit {
        swipeRecognizer?.panGestureRecognizer.removeTarget(self, action: nil)
    }

    func configure() {
        clipsToBounds = false

        swipeController = SwipeController(swipeable: self, actionsContainerView: self)
        swipeController.delegate = self
    }

    /// :nodoc:
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()

        var view: UIView = self
        while let superview = view.superview {
            view = superview

            if let swipeRecognizer = view as? SwipeRecognizable {
                self.swipeRecognizer = swipeRecognizer

                swipeController.scrollView = swipeRecognizer

                swipeRecognizer.panGestureRecognizer.removeTarget(self, action: nil)
                swipeRecognizer.panGestureRecognizer.addTarget(self, action: #selector(handleTablePan(gesture:)))
                return
            }
        }
    }

    /// :nodoc:
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let superview = superview else { return false }

        let point = convert(point, to: superview)

//        if !UIAccessibility.isVoiceOverRunning {
//            for cell in tableView?.swipeCells ?? [] {
//                if (cell.state == .left || cell.state == .right) && !cell.contains(point: point) {
//                    tableView?.hideSwipeCell()
//                    return false
//                }
//            }
//        }

        return contains(point: point)
    }

    func contains(point: CGPoint) -> Bool {
        return point.y > frame.minY && point.y < frame.maxY
    }

    /// :nodoc:
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return swipeController.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    /// :nodoc:
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        swipeController.traitCollectionDidChange(from: previousTraitCollection, to: self.traitCollection)
    }

    @objc func handleTablePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            hideSwipe(animated: true)
        }
    }

    func reset() {
        swipeController.reset()
        clipsToBounds = false
    }
}

extension SwipeView: SwipeControllerDelegate {
    func swipeController(_ controller: SwipeController, canBeginEditingSwipeableFor orientation: SwipeActionsOrientation) -> Bool {
        return delegate?.swipeView(self, canBeginEditingSwipeableFor: orientation) ?? false
    }

    func swipeController(_ controller: SwipeController, editActionsForSwipeableFor orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        return delegate?.swipeView(self, editActionsForSwipeableFor: orientation)
    }

    func swipeController(_ controller: SwipeController, editActionsOptionsForSwipeableFor orientation: SwipeActionsOrientation) -> SwipeOptions {
        return delegate?.swipeView(self, editActionsOptionsForSwipeableFor: orientation) ?? SwipeOptions()
    }

    func swipeController(_ controller: SwipeController, visibleRectFor scrollView: UIScrollView) -> CGRect? {
        guard let swipeRecognizer = swipeRecognizer else { return nil }

        return delegate?.swipeView(self, visibleRectFor: swipeRecognizer)
    }

    func swipeController(_ controller: SwipeController, willBeginEditingSwipeableFor orientation: SwipeActionsOrientation) {
        delegate?.swipeView(self, willBeginEditingSwipeableFor: orientation)
    }

    func swipeController(_ controller: SwipeController, didEndEditingSwipeableFor orientation: SwipeActionsOrientation) {
        delegate?.swipeView(self, didEndEditingSwipeableFor: orientation)
    }

    func swipeController(_ controller: SwipeController, didDeleteSwipeableAt indexPath: IndexPath) {
        removeFromSuperview()
    }
}

