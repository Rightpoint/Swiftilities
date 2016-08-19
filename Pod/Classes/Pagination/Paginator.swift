//
//  Paginator.swift
//  Pods
//
//  Created by Adam Tierney on 8/19/16.
//
//

import Foundation

/// Represents Paginator state:
enum PageState: Int {
    case Idle, Loading, Finished
}


public class Paginator<T>: NSObject {
    
    /// Current Page
    public private(set) var page: Int {
        didSet {
            if pageState == .Loading { return }
            pageState = .Idle
        }
    }
    
    public let count: Int
    
    public var offset: Int = PaginationConstants.DefaultOffset
    
    var pageState: PageState = .Idle
    
    var canFetch: Bool {
        return pageState != .Loading && pageState != .Finished
    }
    
    public var fetchPage: (page: Int, count: Int, offset: Int, completion: ([T]?, PageData?, NSError?)->Void)->()
    
    public required init(
        startingPage page: Int = PaginationConstants.DefaultStartPage,
        resultPerPage count: Int = PaginationConstants.DefaultPageCount,
        fetchPage: (page: Int, count: Int, offset: Int, completion: ([T]?, PageData?, NSError?)->Void)->()) {
        
        self.page = page
        self.count = count
        self.fetchPage = fetchPage
        super.init()
    }
    
    /// Sets the internal state to Loading, fetches a page, if it is the final page it sets the state to Finished
    /// otherwise it returns the state to Idle
    public func fetch(completion: (([T]?, PageData?, NSError?)->())? = nil) {
        
        guard canFetch else { completion?(nil, nil, nil); return }
        
        pageState = .Loading
        fetchPage(page: page, count: count, offset: offset, completion: { [weak self] (page: [T]?, pageInfo: PageData?, error: NSError?) in
            self?.pageState = .Idle
            self?.handleResponse(page, pageInfo: pageInfo, error: error)
            completion?(page, pageInfo, error)
        })
    }
    
    /// Sets the page count to the default start page and calls fetch()
    public func refresh(completion: (([T]?, PageData?, NSError?)->())? = nil) {
        
        guard pageState != .Loading else { completion?(nil, nil, nil); return }
        
        page = PaginationConstants.DefaultStartPage
        
        fetch() { (page: [T]?, pageInfo: PageData?, error: NSError?) in
            completion?(page, pageInfo, error)
        }
    }
    
    /// Increments the page count by one and calls fetch()
    public func fetchNext(completion: (([T]?, PageData?, NSError?)->())? = nil) {
        
        guard canFetch else { completion?(nil, nil, nil); return }
        
        page += 1
        
        fetch() { (page: [T]?, pageInfo: PageData?, error: NSError?) in
            completion?(page, pageInfo, error)
        }
    }
    
    private func handleResponse(page: [T]?, pageInfo: PageData?, error: NSError?) {
        
        guard error == nil else {
            return
        }
        
        if let pageInfo = pageInfo {
            self.page = pageInfo.page
            pageState = pageInfo.page == pageInfo.pages ? .Finished : .Idle
        } else {
            pageState = .Finished
        }
    }
}


// MARK: - Constants
public struct PaginationConstants {
    
    static let DefaultStartPage: Int = 1
    static let DefaultPageCount: Int = 20
    static let DefaultOffset: Int = 0
}


// MARK: - PageData
public class PageData: NSObject {
    
    /// total pages
    public var pages: Int = 0
    
    /// numper of entitiies
    public var count: Int = 0
    
    /// current page
    public var page: Int = 0
}


// MARK: - Protocol
public protocol Paginatable {
    
    var fetchTriggerPercentage: Float { get }
    
    func shouldFetchNext(forDimensions dimensions: ScrollViewDimensions, onAxis axis: UILayoutConstraintAxis) -> Bool
}


public extension Paginatable {
    
    public var fetchTriggerPercentage: Float { return 0.8 }
    
    public func shouldFetchNext(forDimensions dimensions: ScrollViewDimensions, onAxis axis: UILayoutConstraintAxis = .Vertical) -> Bool {
        
        let contentSize = axis == .Vertical ? dimensions.contentSize.height : dimensions.contentSize.width
        let size = axis == .Vertical ? dimensions.size.height : dimensions.size.width
        let bottomOffset = size + (axis == .Vertical ? dimensions.offset.y : dimensions.offset.x)
        let percentage = Float(bottomOffset / contentSize)
        return percentage > fetchTriggerPercentage
    }
}


// MARK: - Scroll View Helpers
public typealias ScrollViewDimensions = (size: CGSize, contentSize: CGSize, offset: CGPoint)

public extension UIScrollView {
    
    public var currentDimensions: ScrollViewDimensions {
        return (size: frame.size, contentSize: contentSize, offset: contentOffset)
    }
}
