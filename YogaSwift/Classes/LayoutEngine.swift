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
        __YogaSwiftAssertMainQueue()
        if let obs = _preTransactionObserver {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), obs, .commonModes)
        }
    }
}

extension UIView {
    @objc
    fileprivate func __yoga_swift__layoutSubviews() {
        if self.flexEnabled && self.flexSpec.parent == nil  {
            self.flexSpec.layout()
        }
        __yoga_swift__layoutSubviews()
    }
    
//    @objc
//    fileprivate func __yoga_swift__setNeedsLayout() {
//        if self.flexEnabled {
//            self.flexSpec.markDirty()
//            var root = self.flexSpec
//            while let p = root.parent {
//                root = p
//            }
//            LayoutEngine.shared.transactionQueue.enqueue(obj: root)
//        }
//        self.__yoga_swift__setNeedsLayout()
//    }
//    
//    @objc
//    fileprivate func __yoga_swift__layoutIfNeeded() {
//        if self.flexEnabled {
//            self.flexSpec.layout()
//        }
//        self.__yoga_swift__layoutIfNeeded()
//    }
}

extension CALayer {
    @objc
    fileprivate func __yoga_swift__layoutSublayers() {
        if self.flexEnabled && self.flexSpec.parent == nil {
            self.flexSpec.layout()
        }
        __yoga_swift__layoutSublayers()
    }
    
//    @objc
//    fileprivate func __yoga_swift__setNeedsDisplay() {
//        self.__yoga_swift__displayIfNeeded()
//    }
//    
//    @objc
//    fileprivate func __yoga_swift__displayIfNeeded() {
//        self.__yoga_swift__displayIfNeeded()
//    }
}

public class LayoutEngine {
    static public let shared: LayoutEngine = LayoutEngine()
    
    private init() { }
    
    public func setup() {
        YogaSwizzleInstanceMethod(UIView.self, #selector(UIView.layoutSubviews), #selector(UIView.__yoga_swift__layoutSubviews))
        
        YogaSwizzleInstanceMethod(CALayer.self, #selector(CALayer.layoutSublayers), #selector(CALayer.__yoga_swift__layoutSublayers))
        
    }
    
}

extension FlexSpec: CATransactionQueueObserving {
    func prepareForCATransactionCommit() {
        self.layout()
    }
}
