//
//  DBStation.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/26/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import "DBStation.h"

@implementation DBStation

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"objectId": @"id",
             @"createdAt": @"created_at",
             @"updatedAt": @"updated_at",
             @"department_id": @"department_id",
             @"name": @"name",
             @"phone": @"phone",
             @"address": @"address",
             @"city": @"city",
             @"state": @"state",
             @"zip": @"zip",
             @"ordering": @"ordering"
             };
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_formatter;
    
    if (!_formatter) {
        _formatter = [NSDateFormatter new];
        _formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _formatter;
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        NSDate * date = [[self dateFormatter] dateFromString:str];
        return date;
    } reverseBlock:^(NSDate *date) {
        return [[self dateFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        NSDate * date = [[self dateFormatter] dateFromString:str];
        return date;
    } reverseBlock:^(NSDate *date) {
        return [[self dateFormatter] stringFromDate:date];
    }];
}

@end
