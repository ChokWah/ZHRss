//
//  XmlModel.h
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/16.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FeedModel;

#pragma mark - FeedItem属性
@interface FeedModel : NSObject

/** 文章链接*/
@property (nonatomic, copy) NSString *link;

/** 文章标题*/
@property (nonatomic, copy) NSString *title;

/** 短描述*/
@property (nonatomic, copy) NSString *summary;

/** 分类*/
@property (nonatomic, copy) NSString *category;

/** 发布时间*/
@property (nonatomic, copy) NSString *updatedDate;

/** 作者*/
@property (nonatomic, copy) NSString *authorName;

/** 正文内容*/
@property (nonatomic, copy) NSString *feedDescription;

/** 是否已读*/
@property (nonatomic, assign) NSUInteger isRead;

/** 文章ID*/
@property (nonatomic, assign) NSUInteger fID;

/** Feed名字*/
@property (nonatomic, strong) NSString *feedName;

/** 是否隐藏*/
//@property (nonatomic, assign) NSUInteger ishide;

@end


// ==========================================================================================

#pragma mark - Xml文档属性
@interface XmlModel : NSObject

@property (nonatomic, strong) NSMutableArray <FeedModel *> *modelArray;

/** 标题*/
@property (nonatomic, copy) NSString *title;

/** 副标题*/
@property (nonatomic, copy) NSString *subtitle;

/** 发现*/
@property (nonatomic, copy) NSString *generator;

/** 描述*/
@property (nonatomic, copy) NSString *rssDescription;

/** 官网主页*/
@property (nonatomic, copy) NSString *link;

/** 版权*/
@property (nonatomic, copy) NSString *copyright;

/** 图标*/
@property (nonatomic, copy) NSString *imageUrl;

/** FeedURL*/
@property (nonatomic, copy) NSString *feedUrl;

/** 最后更新*/
@property (nonatomic, copy) NSString *lastUpdateDate;

/** ID*/
@property (nonatomic, assign) NSInteger xID;

/** 未读数*/
@property (nonatomic, assign) NSUInteger unreadCount;

- (instancetype)initWithTitle:(NSString *)title andLink:(NSString *)link;

@end


