//
//  DBResponse.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/18/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import "DBResponse.h"

@implementation DBResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"objectId": @"id",
             @"createdAt": @"created_at",
             @"updatedAt": @"updated_at",
             @"user_id": @"user_id",
             @"user": @"user",
             @"firecall_id": @"firecall_id",
             @"destination_id": @"destination_id",
             @"destination": @"destination",
             @"latitude": @"latitude",
             @"longitude": @"longitude"
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

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[DBUser class]];
}

+ (NSValueTransformer *)destinationJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[DBDestination class]];
}

- (NSString *)timeString {
    NSDateFormatter * f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH:mm:ss"];
    
    return [f stringFromDate:self.createdAt];
}

- (NSString *)updatedTimeString {
    NSDateFormatter * f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH:mm:ss"];
    
    return [f stringFromDate:self.updatedAt];
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude floatValue], [self.longitude floatValue]);
}

@end
