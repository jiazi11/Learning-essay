# Learning-essay

## 说明
Learning-essay记录本人在开发中一些比较好的点子，或者一些问题的解决。

## 功能

1、debug输出。
```Swfit
#if !DEBUG
let print = { (items: Any...) -> Void in }
#endif
```
2、判断是否支持apns推送，跳转到系统设置
```Swfit
// 判断是否允许显示通知
if UIApplication.sharedApplication().isRegisteredForRemoteNotifications() == true {
  println("Yes, allowed")
}
    
//跳转到系统设置
if #available(iOS 9.0, *), let url = URL(string: UIApplicationOpenSettingsURLString) {
  if UIApplication.shared.canOpenURL(url) {
    UIApplication.shared.openURL(url)
  }
}
```
[我的博客](#) 
