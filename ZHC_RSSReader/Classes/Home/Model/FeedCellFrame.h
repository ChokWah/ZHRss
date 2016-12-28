//
//  FeedCellFrame.h
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/12/21.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import <Foundation/Foundation.h>

// 昵称字体
#define FeedCellNameFont [UIFont systemFontOfSize:13]
// 时间字体
#define FeedCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define FeedCellSourceFont FeedCellTimeFont
// 正文字体
#define FeedCellTitleFont [UIFont systemFontOfSize:14]
// 标题字体
#define FeedCellDetailFont [UIFont systemFontOfSize:17]

// cell之间的间距
#define HWStatusCellMargin 15

// cell的边框宽度
#define HWStatusCellBorderW 10

@class FeedModel;
@interface FeedCellFrame : NSObject

@property (nonatomic, strong) FeedModel *model;



@end
