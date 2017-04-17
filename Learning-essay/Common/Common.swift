//
//  Common.swift
//  Swift-Test
//
//  Created by 邱振佳 on 2017/4/6.
//  Copyright © 2017年 邱振佳. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Swift3 oneToken
public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block:(Void)->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

// MARK: - 获取类名
private func objcast<T>(_ obj: Any) -> T {
    return obj as! T
}

extension NSObject {
    
    // 获取类名
    class var className: String {
        return (NSStringFromClass(self) as NSString).pathExtension
    }
    
    var className: String {
        return (NSStringFromClass(self.classForCoder) as NSString).pathExtension
    }
}

// MARK: UIView xib初始化；UIView 获取UIViewController(只有被 addSubview 后才能获取到)
extension UIView {
    
    class func instantiateWithNib() -> Self {
        return objcast(Bundle.main.loadNibNamed(self.className, owner: nil, options: nil)!.first!)
    }
    
    /// 当前 view 所在的 UIViewController，只有被 addSubview 后才能获取到
    var viewController: UIViewController? {
        var responder = self.next
        while responder != nil {
            if let viewController = responder as? UIViewController {
                assert(self.isDescendant(of: viewController.view), "UIView.viewController找到了错误的UIViewControler")
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
}

// MARK: - DEBUG
#if DEBUG
extension UIViewController {
    // MARK: - Method Swizzling
    func newViewDidLoad() {
        self.newViewDidLoad()
        print("进入：\(self.className)")
    }
    
    open override class func initialize() {
        DispatchQueue.once { () in
            let originalSelector = #selector(UIViewController.viewDidLoad)
            let swizzledSelector = #selector(UIViewController.newViewDidLoad)
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
}
    
let print = { (items: Any...) -> Void in }

#endif
