//
//  DBLogin.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/4/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "DBLogin.h"

@implementation DBLogin

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code": @"code",
             @"message": @"message",
             @"user": @"user"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[DBUser class]];
}

@end