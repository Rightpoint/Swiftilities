//
//  NavTitleTransitionBehavior.swift
//  Swiftilities
//
//  Created by Jason Clark on 5/12/17.
//
//

public final class NavTitleTransitionBehavior: ViewControllerLifecycleBehavior {

    fileprivate var navTitlePositionUpdater: NavTitlePositionUpdater?

    public init(scrollView: UIScrollView, titleView: UIView) {
        self.navTitlePositionUpdater = NavTitlePositionUpdater(scrollView: scrollView,
                                                               titleView: titleView)
    }

    public func beforeAppearing(_ viewController: UIViewController, animated: Bool) {
        navTitlePositionUpdater?.viewController = viewController
        navTitlePositionUpdater?.enabled = true
    }

    public func beforeDisappearing(_ viewController: UIViewController, animated: Bool) {
        navTitlePositionUpdater?.enabled = false
    }

}

fileprivate final class NavTitlePositionUpdater: NSObject {

    var enabled: Bool = false {
        didSet {
            if enabled != oldValue {
                enabled ? activate() : cleanUp()
            }
        }
    }

    weak var viewController: UIViewController? {
        didSet {
            title = viewController?.navigationItem.title
            navigationBar = viewController?.navigationController?.navigationBar
        }
    }

    var title: String?
    weak var scrollView: UIScrollView?
    weak var titleView: UIView?
    weak var navigationBar: UINavigationBar?

    var offscreenTranslationY: CGFloat = 0

    init(scrollView: UIScrollView, titleView: UIView) {
        self.scrollView = scrollView
        self.titleView = titleView

        super.init()
    }

    func activate() {
        if let navBar = navigationBar {
            let font = navBar.titleTextAttributes?[NSAttributedStringKey.font] as? UIFont ??
                UIFont.systemFont(ofSize: 17, weight:UIFont.Weight.semibold) //NavBar default
            navBarDidChangeBounds(navBar)
            let navHeight = navBar.frame.size.height
            let fontHeight = font.pointSize

            //To move title off nav bar, translate it from the center by half the height of the nav bar and half the height of itself
            offscreenTranslationY = 0.5 * (navHeight + fontHeight)
            navBar.titleOffset = offscreenTranslationY
        }
        addObservers()
    }

    func cleanUp() {
        navigationBar?.titleOffset = 0
        navigationBar?.layer.mask = nil
        removeObservers()
    }

    deinit {
        enabled = false
    }

}

fileprivate extension NavTitlePositionUpdater {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let navBar = navigationBar,
            let titleView = titleView,
            titleView.isDescendant(of: scrollView)
            else { return }

        let titleTransitionRange = 0...offscreenTranslationY //offset range through which the title will translate

        let titleRect = scrollView.convert(titleView.bounds, from: titleView) //title rect in scrollView coordinate system

        let titleCenter = titleRect.midY //center x of the titleView

        let scrollRange = titleCenter...titleCenter + offscreenTranslationY //scrollView contentOffset range through which the animation will take place

        let offset = scrollView.contentOffset.y + scrollView.contentInset.top
        let adjustment = offset.scaled(from: scrollRange, to: titleTransitionRange, clamped: true) //map scroll view offset to title offset
        let invertedAdjustment = titleTransitionRange.upperBound - adjustment //invert the relationship

        navBar.titleOffset = invertedAdjustment

        //if title is offscreen, set text to nil to help with VC transitions.
        viewController?.navigationItem.title = (invertedAdjustment == titleTransitionRange.upperBound) ? nil : title
    }

    func navBarDidChangeBounds(_ navBar: UINavigationBar) {
        //We want to clip the bottom edge of the navbar, but don't clip out the status bar
        var rect = navBar.bounds
        let offset = navBar.frame.origin.y
        rect.size.height += offset
        rect.origin = CGPoint(x: 0, y: -offset)

        var maskLayer = navBar.layer.mask
        if maskLayer == nil {
            maskLayer = CALayer()
            maskLayer?.backgroundColor = UIColor.black.cgColor
        }

        maskLayer?.bounds = rect
        maskLayer?.position = CGPoint(x: rect.width / 2,
                                     y: rect.height / 2 + rect.origin.y)
        navBar.layer.mask = maskLayer
    }

}

fileprivate extension NavTitlePositionUpdater {

    enum KeyPath {
        static let contentOffset = #keyPath(UIScrollView.contentOffset)
        static let navBarBounds = #keyPath(UINavigationBar.bounds)
    }

    func addObservers() {
        self.navigationBar?.addObserver(self, forKeyPath: KeyPath.navBarBounds, options: .new, context: nil)
        self.scrollView?.addObserver(self, forKeyPath: KeyPath.contentOffset, options: .new, context: nil)
    }

    func removeObservers() {
        scrollView?.removeObserver(self, forKeyPath: KeyPath.contentOffset)
        navigationBar?.removeObserver(self, forKeyPath: KeyPath.navBarBounds)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == KeyPath.contentOffset, let sv = object as? UIScrollView {
            scrollViewDidScroll(sv)
        }
        else if keyPath == KeyPath.navBarBounds, let nb = object as? UINavigationBar {
            navBarDidChangeBounds(nb)
        }
        else {
            super.observeValue(forKeyPath: keyPath, of:object, change: change, context: context)
        }
    }

}

fileprivate extension UINavigationBar {

    var titleOffset: CGFloat {
        set {
            setTitleVerticalPositionAdjustment(newValue, for: .default)
            setTitleVerticalPositionAdjustment(newValue, for: .compact)
        }
        get { return titleVerticalPositionAdjustment(for: .default) }
    }

}
