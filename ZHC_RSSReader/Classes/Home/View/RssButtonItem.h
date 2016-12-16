//
//  RssButtonItem.h
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/18.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RssButtonItem : UIBarButtonItem

+ (instancetype)leftButtonItemWithIconUrl:(NSString *)iconUrl andName:(NSString *)name;

+ (instancetype)rightButtonItem;
@end
