// YogaSwift
// Created by: resse

import Foundation

private func YogaSwizzleInstanceMethod(_ cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
    guard let originalMethod = class_getInstanceMethod(cls, originalSelector),
          let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else {
        return
    }

    let swizzledIMP = method_getImplementation(swizzledMethod)
    class_addMethod(cls, originalSelector, swizzledIMP, method_getTypeEncoding(swizzledMethod))
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

protocol LayoutRunloopQueue { }

protocol CATransactionQueueObserving {
    func prepareForCATransactionCommit()
}

private let kCATransactionQueueOrder: Int = 100000
class CATransactionQueue<T: CATransactionQueueObserving>: LayoutRunloopQueue {
    
    var isEmpty: Bool {
        self.objects.isEmpty
    }
    
    private var _preTransactionObserver: CFRunLoopObserver?
    
    private var objects: [T] = []
    private var lock = NSRecursiveLock()
    
    init() {
        let obs = CFRunLoopObserverCreateWithHandler(
            nil,
            CFRunLoopActivity.beforeWaiting.rawValue,
            true, kCATransactionQueueOrder
        ) { observer, activity in
            self.processQueue()
        }
        _preTransactionObserver = obs
                
        CFRunLoopAddObserver(CFRunLoopGetMain(), obs, .commonModes)
    }
    
    func enqueue(obj: T) {
        lock.lock()
        defer { lock.unlock() }
        
        self.objects.append(obj)
    }
    
    func processQueue() {
        lock.lock()
        defer { lock.unlock() }
        for obj in self.objects {
            obj.prepareForCATransactionCommit()
        }
        self.objects.removeAll()
    }
    
    deinit {
        assert(Thread.isMainThread, "must be in main thread")
        if let obs = _preTransactionObserver {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), obs, .commonModes)
        }
    }
}

extension UIView {
//    @objc
//    func __yoga__layoutSubviews() {
//        if self.flexEnabled {
//            self.flex.layout(mode: .fitContainer)
//        }
//        __yoga__layoutSubviews()
//    }
    
    @objc
    func __yoga_swift__setNeedsLayout() {
        if self.flexEnabled {
            self.flexSpec.markDirty()
            var root = self.flexSpec
            while let p = root.parent {
                root = p
            }
            LayoutEngine.shared.transactionQueue.enqueue(obj: root)
        }
        self.__yoga_swift__setNeedsLayout()
    }
    
    @objc
    func __yoga_swift__layoutIfNeeded() {
        if self.flexEnabled {
            self.flexSpec.layout()
        }
        self.__yoga_swift__layoutIfNeeded()
    }
}

extension UIViewController {
    @objc
    func __yoga__viewDidLayoutSubviews() {
        if self.view.flexEnabled {
            self.view.flexSpec.layout(mode: .fitContainer)
        }
        __yoga__viewDidLayoutSubviews()
    }
}

extension CALayer {
    @objc
    func __yoga__layoutSublayers() {
        if self.flexEnabled {
            self.flexSpec.layout()
        }
        __yoga__layoutSublayers()
    }
    
    @objc
    func __yoga_swift__setNeedsDisplay() {
        self.__yoga_swift__displayIfNeeded()
    }
    
    @objc
    func __yoga_swift__displayIfNeeded() {
        self.__yoga_swift__displayIfNeeded()
    }
}

public class LayoutEngine {
    static public let shared: LayoutEngine = LayoutEngine()
    
    let transactionQueue = CATransactionQueue<FlexSpec>()
    
    private init() { }
    
    public func setup() {
//        YogaSwizzleInstanceMethod(UIView.self, #selector(UIView.layoutSubviews), #selector(UIView.__yoga__layoutSubviews))
//        YogaSwizzleInstanceMethod(UIViewController.self, #selector(UIViewController.viewDidLayoutSubviews), #selector(UIViewController.__yoga__viewDidLayoutSubviews))
//        YogaSwizzleInstanceMethod(CALayer.self, #selector(CALayer.layoutSublayers), #selector(CALayer.__yoga__layoutSublayers))
        _ = transactionQueue
        YogaSwizzleInstanceMethod(
            UIView.self,
            #selector(UIView.setNeedsLayout),
            #selector(UIView.__yoga_swift__setNeedsLayout)
        )
        YogaSwizzleInstanceMethod(
            UIView.self,
            #selector(UIView.layoutIfNeeded),
            #selector(UIView.__yoga_swift__layoutIfNeeded)
        )
        
//        YogaSwizzleInstanceMethod(
//            CALayer.self,
//            #selector(CALayer.setNeedsDisplay),
//            #selector(CALayer.__yoga_swift__setNeedsDisplay)
//        )
//        
//        YogaSwizzleInstanceMethod(
//            CALayer.self,
//            #selector(CALayer.displayIfNeeded),
//            #selector(CALayer.__yoga_swift__displayIfNeeded)
//        )
        
    }
    
}

extension FlexSpec: CATransactionQueueObserving {
    func prepareForCATransactionCommit() {
        self.layout()
    }
    
    
}
