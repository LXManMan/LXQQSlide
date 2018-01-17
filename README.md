# LXQQSlide
![image](https://github.com/liuxinixn/LXQQSlide/blob/master/%E4%BB%BFQQ%E4%BE%A7%E6%BB%91.gif)

使用方法：
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor =[UIColor whiteColor];
    
    LXLeftController *leftVc =[[LXLeftController alloc]init];
    LXTabbarController *mainVc =[[LXTabbarController alloc]init];
    LXQQSlideController *qqSlideVc =[LXQQSlideController initWithLeftVC:leftVc mainVc:mainVc];
    self.window.rootViewController = qqSlideVc;
    
    self.qqSlideVc = qqSlideVc;
    self.window.backgroundColor =[UIColor whiteColor];
    return YES;
}
```
