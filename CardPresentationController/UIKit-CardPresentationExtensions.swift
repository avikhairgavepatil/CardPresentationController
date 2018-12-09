//
//  UIKit-CardPresentationExtensions.swift
//  CardPresentationExample
//
//  Created by Aleksandar Vacić on 12/8/18.
//  Copyright © 2018 Aleksandar Vacić. All rights reserved.
//

import UIKit

extension UIViewController {
	private struct AssociatedKeys {
		static var cardTransitionManager = "CardTransitionManager"
	}
	private var transitionManager: CardTransitionManager? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.cardTransitionManager) as? CardTransitionManager
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.cardTransitionManager, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}


	@available(iOS 10.0, *)
	/// Presents given View Controller using custom Card-like modal transition. Think like Apple‘s Music or Wallet apps.
	///
	///	Existing view will slide down and fade a bit and top corners would be rounded.
	///	Presented controller will slide up, over it, slightly below and also with rounder corners.
	///
	/// - Parameters:
	///   - viewControllerToPresent: `UIViewController` instance to present.
	///   - transitionManager: an instance of `CardTransitionManager`. By default it's `nil` which means that one will be created and managed internally.
	///   - flag: Pass `true` to animate the presentation; otherwise, `pass` false.
	///   - completion: The closure to execute after the presentation finishes. This closure has no return value and takes no parameters. You may specify `nil` for this parameter or omit it entirely.
	open func presentCard(_ viewControllerToPresent: UIViewController,
						  using transitionManager: CardTransitionManager? = nil,
						  animated flag: Bool,
						  completion: (() -> Void)? = nil)
	{
		//	make it custom
		viewControllerToPresent.modalPresentationStyle = .custom
		//	so we can use our Card transition
		let tm = transitionManager ?? CardTransitionManager()
		self.transitionManager = tm
		viewControllerToPresent.transitioningDelegate = tm

		present(viewControllerToPresent,
				animated: flag,
				completion: completion)
	}

}

extension UIView {
	func maskTopCard(cornerRadius: CGFloat = 24) {
		let corners: UIRectCorner = [.topLeft, .topRight]
		let maskPath = UIBezierPath(roundedRect: bounds,
									byRoundingCorners: corners,
									cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = bounds
		print(bounds)
		maskLayer.path = maskPath.cgPath
		layer.mask = maskLayer
	}
}
