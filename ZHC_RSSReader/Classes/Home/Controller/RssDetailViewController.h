//
//  RssDetailViewController.h
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/17.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedModel;
@interface RssDetailViewController : UIViewController

- (instancetype)initWithModel:(FeedModel *)feedModel;

@end
