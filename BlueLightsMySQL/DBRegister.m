//
//  DBRegister.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/1/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "DBRegister.h"

@implementation DBRegister

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code": @"code",
             @"message": @"message",
             @"department": @"department",
             @"user": @"user"
             };
}

+ (NSValueTransformer *)departmentJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[DBDepartment class]];
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[DBUser class]];
}

@end
