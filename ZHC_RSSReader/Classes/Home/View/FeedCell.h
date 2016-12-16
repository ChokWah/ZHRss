//
//  FeedCell.h
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/12/12.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class XmlModel;
@class FeedModel;
@interface FeedCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)config:(FeedModel *)model;
@end
