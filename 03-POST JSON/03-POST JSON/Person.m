//
//  Person.m
//  03-POST JSON
//
//  Created by apple on 15/4/26.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "Person.h"

@interface Person() {
    double _height;
}

@property (nonatomic, copy) NSString *title;
@end

@implementation Person

+ (instancetype)personWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _title = @"BOSS";
        _height = 1.5;
    }
    return self;
}

@end
