//
//  ZH.m
//  ZH_4DAGE_AR
//
//  Created by 4DAGE_HUA on 16/4/14.
//  Copyright © 2016年 4DAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBarButtonItem_ZHExtension.h"

@implementation UIBarButtonItem (ZHExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
        [button sizeToFit];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        return [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

+ (UIBarButtonItem *)itemWithBigImage:(NSString *)image target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *Bigimage = [UIImage imageNamed:image];
    
    button.frame = CGRectMake(0, 0, 35, 35);
    [button setBackgroundImage:Bigimage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}


+ (UIBarButtonItem *)itemWithNormalImage:(NSString *)image target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *Bigimage = [UIImage imageNamed:image];
    
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setBackgroundImage:Bigimage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithNormalImage:(NSString *)image target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *Bigimage = [UIImage imageNamed:image];
    
    button.frame = CGRectMake(0, 0, width, height);
    [button setBackgroundImage:Bigimage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTintColor:titleColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];

}
@end