//
//  RSSHeader.h
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/18.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedModel;
@interface RSSHeader : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview;

- (void)configureCellWith:(FeedModel *)model;

@end
