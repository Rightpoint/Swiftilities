//
//  NavBarHairlineFadeBehavior.swift
//  Swiftilities
//
//  Created by Jason Clark on 5/12/17.
//
//

public final class NavBarHairlineFadeBehavior: ViewControllerLifecycleBehavior {

    fileprivate var navBarHairlineFadeUpdater: NavBarHairlineFadeUpdater

    public init(scrollView: UIScrollView) {
        self.navBarHairlineFadeUpdater = NavBarHairlineFadeUpdater(scrollView: scrollView)
        self.navBarHairlineFadeUpdater.contentOffsetFadeRange = contentOffsetFadeRange
    }

    public func beforeAppearing(_ viewController: UIViewController, animated: Bool) {
        navBarHairlineFadeUpdater.navigationBar = viewController.navigationController?.navigationBar
        navBarHairlineFadeUpdater.enabled = true
    }

    public func beforeDisappearing(_ viewController: UIViewController, animated: Bool) {
        navBarHairlineFadeUpdater.enabled = false
    }

}

public extension NavBarHairlineFadeBehavior {

    var contentOffsetFadeRange: ClosedRange<CGFloat> {
        set { navBarHairlineFadeUpdater.contentOffsetFadeRange = newValue }
        get { return navBarHairlineFadeUpdater.contentOffsetFadeRange }
    }

    var hairlineColor: UIColor {
        set { navBarHairlineFadeUpdater.hairline.hairlineColor = newValue }
        get { return navBarHairlineFadeUpdater.hairline.hairlineColor }
    }

    var hairlineThickness: CGFloat {
        set { navBarHairlineFadeUpdater.hairline.thickness = newValue }
        get { return navBarHairlineFadeUpdater.hairline.thickness }
    }

}

fileprivate final class NavBarHairlineFadeUpdater: NSObject {

    var contentOffsetFadeRange: ClosedRange<CGFloat> = 0...100

    var enabled: Bool = false {
        didSet {
            if enabled != oldValue {
                enabled ? activate() : cleanUp()
            }
        }
    }

    var hairlineAlpha: CGFloat {
        set { hairline.alpha = newValue }
        get { return hairline.alpha }
    }

    let hairline = HairlineView(axis: .horizontal)

    weak var scrollView: UIScrollView?
    weak var navigationBar: UINavigationBar?

    init(scrollView: UIScrollView) {
        self.scrollView = scrollView

        super.init()
        self.hairlineAlpha = 0
    }

    func activate() {
        addObservers()
        if let navBar = navigationBar {
            navBar.addSubview(hairline)
            navBarDidChangeBounds(navBar)
        }
    }

    func cleanUp() {
        removeObservers()
        hairline.removeFromSuperview()
    }

    deinit {
        enabled = false
    }

}

fileprivate extension NavBarHairlineFadeUpdater {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shift = scrollView.contentInset.top + scrollView.contentOffset.y
        hairlineAlpha = shift.scaled(from: contentOffsetFadeRange, to: 0...1, clamped: true)
    }

    func navBarDidChangeBounds(_ navBar: UINavigationBar) {
        let rect = navBar.bounds
        let thickness = hairline.intrinsicContentSize.height
        hairline.frame = CGRect(x: 0, y: rect.height - thickness, width: rect.width, height: thickness)
    }

}

fileprivate extension NavBarHairlineFadeUpdater {

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
