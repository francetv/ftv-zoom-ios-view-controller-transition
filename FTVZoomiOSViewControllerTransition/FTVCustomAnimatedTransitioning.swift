/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 France Télévisions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
 * to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of
 * the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
 * THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import UIKit

class FTVCustomAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    let scaleFactor: CGFloat = 0.8

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? FirstViewController,
            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? SecondViewController,
            containerView = transitionContext.containerView() else {
                return
        }

        containerView.addSubview(toVC.view)

        // Extract width and height of contentTableView
        let containerViewWidth = containerView.frame.width
        let containerViewHeight = containerView.frame.height

        let fakeView1 = UIView(frame: CGRect(x: 0, y: containerViewHeight, width: containerViewWidth, height: containerViewHeight))
        fakeView1.backgroundColor = UIColor.redColor()
        toVC.view.insertSubview(fakeView1, belowSubview: toVC.contentView)

        let fakeView2 = UIView(frame: CGRect(x: 20, y: containerViewHeight, width: containerViewWidth, height: containerViewHeight))
        fakeView2.backgroundColor = UIColor.greenColor()
        toVC.view.insertSubview(fakeView2, belowSubview: fakeView1)

        // Screen translation animation
        UIView.animateKeyframesWithDuration(transitionDuration(transitionContext), delay: 0.0, options: [],
                                            animations:  animationsBlock(fromVC, toVC: toVC, fakeView1: fakeView1, fakeView2: fakeView2, containerViewHeight: containerViewHeight),
                                            completion: animationCompletionBlock(transitionContext, fakeView1: fakeView1, fakeView2: fakeView2))
    }

    private func animationsBlock(fromVC: FirstViewController, toVC: SecondViewController, fakeView1: UIView, fakeView2: UIView, containerViewHeight: CGFloat) -> (() -> Void) {
        return {
            // Initial state
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0) {
                toVC.view.transform = CGAffineTransformTranslate(toVC.view.transform, toVC.view.frame.size.width, 0.0)
                toVC.contentView.transform = CGAffineTransformScale(toVC.contentView.transform, self.scaleFactor, self.scaleFactor)
                fakeView1.transform = CGAffineTransformScale(fakeView1.transform, self.scaleFactor, self.scaleFactor)
                fakeView2.transform = CGAffineTransformScale(fakeView2.transform, self.scaleFactor, self.scaleFactor)
                toVC.contentView.transform = CGAffineTransformTranslate(toVC.contentView.transform, -20.0, toVC.contentView.frame.size.height)
            }

            // Screen translation
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5) {
                fromVC.view.transform = CGAffineTransformTranslate(fromVC.view.transform, -fromVC.view.frame.size.width, 0.0)
                toVC.view.transform = CGAffineTransformTranslate(toVC.view.transform, -toVC.view.frame.size.width, 0.0)
            }

            // Real content translation to the top
            UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.5) {
                toVC.contentView.transform = CGAffineTransformTranslate(toVC.contentView.transform, 0.0, -toVC.contentView.frame.size.height)
            }

            // Fake1 translation to the top
            UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.4) {
                fakeView1.transform = CGAffineTransformTranslate(fakeView1.transform, 0.0, -fakeView1.frame.size.height - 140.0)
            }

            // Fake2 translation to the top
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.3) {
                fakeView2.transform = CGAffineTransformTranslate(fakeView2.transform, 0.0, -fakeView2.frame.size.height - 70.0)
            }

            // Real content rescaled to normal
            UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3) {
                toVC.contentView.transform = CGAffineTransformScale(toVC.view.transform, 1.0, 1.0)
            }
        }
    }

    private func animationCompletionBlock(transitionContext: UIViewControllerContextTransitioning, fakeView1: UIView, fakeView2: UIView) -> (Bool -> Void) {
        return { flag in
            guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? SecondViewController else {
                return
            }

            // Remove fake views
            fakeView1.removeFromSuperview()
            fakeView2.removeFromSuperview()
            
            // Enable Clip Subviews on contentTableView
            toVC.contentView.clipsToBounds = true

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
}
