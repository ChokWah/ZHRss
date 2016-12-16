//
//  ZHTabbarController.m
//  ZH_4DAGE_AR
//
//  Created by 4DAGE_HUA on 16/4/14.
//  Copyright © 2016年 4DAGE. All rights reserved.
//

#import "ZHTabbarController.h"
#import "RSSNavViewController.h"
#import "MainViewController.h"



@interface ZHTabbarController ()

@end

@implementation ZHTabbarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpItem];
    [self setUpChildVc];
}

/**
 *  设置Item的属性
 */
- (void)setUpItem{
    
    //UIcontrolstateNormal情况下的文字属性
    NSMutableDictionary *normalAtrrs = [NSMutableDictionary dictionary];
    //文字颜色
    normalAtrrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    //UIControlStateSelected情况的文字属性
    NSMutableDictionary *selectedAtrrs = [NSMutableDictionary dictionary];
    //文字颜色
    selectedAtrrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAtrrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAtrrs forState:UIControlStateSelected];
}


/**
 *  设置setUpChildVc的属性，添加所有的子控件
 */
- (void)setUpChildVc{
    
    [self setUpChildVc:[[MainViewController alloc] init] title:@"Main" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    [self setUpChildVc:[[UIViewController alloc] init] title:@"全景" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    [self setUpChildVc:[[UIViewController alloc] init] title:@"更多" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    [self setUpChildVc:[[UIViewController alloc] init] title:@"关于" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];

}

- (void)setUpChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    
    if([title isEqualToString:@"Main"]){
        
        // 包装一个导航控制器
        RSSNavViewController *nav = [[RSSNavViewController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
        // 设置子控制器的tabBarItem
        nav.tabBarItem.title = title;
        
    }else{
        
        UIViewController *vc = [[UIViewController alloc]init];
        [self addChildViewController:vc];
        vc.tabBarItem.title = title;
    }
//    
//    // 包装一个导航控制器
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self addChildViewController:nav];
//    // 设置子控制器的tabBarItem
//    nav.tabBarItem.title = title;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
