//
//  LXControlRootController.m
//  LXQQSlide
//
//  Created by chenergou on 2017/11/1.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXControlRootController.h"
#import "UIBarButtonItem+SXCreate.h"
@interface LXControlRootController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@end

@implementation LXControlRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"仿QQ侧滑";
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage LX_imageWithOriginalName:@"head"] style:UIBarButtonItemStylePlain target:self action:@selector(openDrawer)];
   [self.view addSubview:self.tableview];
}
-(void)openDrawer{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appdelegate.qqSlideVc openDrawer];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"他大舅他二舅都是他舅";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    LXBasicController *vc = [LXBasicController new];
   
    
    vc.view.backgroundColor = LXRandomColor;
    vc.title = @"😝😝😋🌶🌶";
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableView *)tableview{
    
    if (!_tableview) {
        _tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, NAVH, Device_Width, Device_Height - NAVH) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.showsHorizontalScrollIndicator = NO;
        _tableview.tableFooterView = [UIView new];
        _tableview.rowHeight = 44;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _tableview;
}


@end
