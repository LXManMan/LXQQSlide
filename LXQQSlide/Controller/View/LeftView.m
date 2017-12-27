//
//  LeftView.m
//  LXQQSlide
//
//  Created by chenergou on 2017/12/25.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LeftView.h"
@interface LeftView()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *backIcon;
@end
@implementation LeftView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [UIImage LX_ClipCircleImageWithImage:[UIImage imageNamed:@"icon"] circleRect:self.icon.bounds borderWidth:2 borderColor:[UIColor whiteColor]];
    self.backIcon.layer.masksToBounds = YES;
}
+(LeftView *)showView{
    return [[NSBundle mainBundle]loadNibNamed:@"LeftView" owner:self options:nil].firstObject;
}
@end
