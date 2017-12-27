//
//  LXQQSlideController.h
//  LXQQSlide
//
//  Created by chenergou on 2017/11/1.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXBasicController.h"

@interface LXQQSlideController : LXBasicController
+(instancetype)initWithLeftVC:(LXBasicController *)leftVc mainVc:(UIViewController *)mainVc;
-(void)closeDrawer;//关闭抽屉
-(void)openDrawer;//打开抽屉
@end
