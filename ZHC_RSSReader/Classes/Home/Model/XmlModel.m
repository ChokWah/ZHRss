//
//  XmlModel.m
//  ZHC_RSSReader
//
//  Created by 4DAGE_HUA on 16/11/16.
//  Copyright © 2016年 ZHC. All rights reserved.
//

#import "XmlModel.h"

@interface XmlModel ()

@end


@implementation XmlModel

- (instancetype)initWithTitle:(NSString *)title andLink:(NSString *)link{
    
    if (self = [super init]) {
        
        _title   = title;
        _feedUrl = link;
    }
    return self;
}

- (NSMutableArray<FeedModel *> *)modelArray{
    
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end

@implementation FeedModel

@end