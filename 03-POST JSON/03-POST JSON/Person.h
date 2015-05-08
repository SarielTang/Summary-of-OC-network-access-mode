//
//  Person.h
//  03-POST JSON
//
//  Created by apple on 15/4/26.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;

+ (instancetype)personWithDict:(NSDictionary *)dict;

@end
