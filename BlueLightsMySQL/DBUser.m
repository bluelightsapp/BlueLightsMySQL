//
//  DBUser.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/1/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "DBUser.h"
#import "DBDepartment.h"

@implementation DBUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"objectId": @"id",
             @"createdAt": @"created_at",
             @"updatedAt": @"updated_at",
             @"email": @"email",
             @"admin": @"admin",
             @"active": @"active",
             @"firstName": @"first_name",
             @"lastName": @"last_name",
             @"phone": @"phone",
             @"sound": @"sound",
             @"departments": @"departments",
             @"channels": @"channels"
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

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

+ (DBUser *)currentUser {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * userDict = [defaults objectForKey:@"currentUser"];
    DBUser * user = [[DBUser alloc] initWithDictionary:userDict error:nil];
    return user;
}

@end
