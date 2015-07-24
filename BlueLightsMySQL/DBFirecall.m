//
//  DBFirecall.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/7/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "DBFirecall.h"
#import "DBResponse.h"
#import "APIClient.h"
#import "constants.m"

@implementation DBFirecall

+ (NSDictionary*)JSONKeyPathsByPropertyKey {
    return @{
             @"objectId": @"id",
             @"createdAt": @"created_at",
             @"updatedAt": @"updated_at",
             @"departmentId": @"department_id",
             @"callId": @"call_id",
             @"callDate": @"call_date",
             @"additional": @"additional",
             @"type": @"type",
             @"subtype": @"subtype",
             @"address": @"address",
             @"sitename": @"sitename",
             @"city": @"city",
             @"grid": @"grid",
             @"crosses": @"crosses",
             @"hydrants": @"hydrants",
             @"responses": @"responses"
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

+ (NSValueTransformer *)callDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        NSDate * date = [[self dateFormatter] dateFromString:str];
        return date;
    } reverseBlock:^(NSDate *date) {
        return [[self dateFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)responsesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[DBResponse class]];
}

- (NSString *)dispType {
    return [NSString stringWithFormat:@"%@ - %@", self.type, self.subtype];
}

- (NSString *)dispAddress {
    if (![self.sitename isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@ %@", self.sitename, self.address];
    } else {
        return self.address;
    }
}

- (NSString *)detailAddress {
    NSString * detailAddress = self.sitename;
    if (![detailAddress isEqualToString:@""])
        detailAddress = [NSString stringWithFormat:@"%@\n%@", detailAddress, self.address];
    else
        detailAddress = self.address;
   
    if (![self.city isEqualToString:@""])
        detailAddress = [NSString stringWithFormat:@"%@\n%@", detailAddress, self.city];
    
    return detailAddress;
}

- (NSArray *)detailsArray {
    NSMutableArray * details = [NSMutableArray array];
    
    [details addObject:@{
                         @"title" : @"Date",
                         @"detail" : self.dateString
                         }];
    [details addObject:@{
                         @"title" : @"Type",
                         @"detail" : self.dispType
                         }];
    [details addObject:@{
                         @"title" : @"Address",
                         @"detail" : [self detailAddress]
                         }];
    if (![self.additional isEqualToString:@""])
        [details addObject:@{
                             @"title" : @"Additional",
                             @"detail" : self.additional
                             }];
    //    if ([self.firecall.crosses count] > 0)
    //        [details addObject:@{
    //                             @"title" : @"Cross",
    //                             @"detail" : @(self.firecall.crosses.count)
    //                             }];
    //    if ([self.firecall.hydrants count] > 0)
    //        [details addObject:@{
    //                             @"title" : @"Hydrant",
    //                             @"detail" : @(self.firecall.hydrants.count)
    //                             }];
    if (![self.grid isEqualToString:@""])
        [details addObject:@{
                             @"title" : @"Grid",
                             @"detail" : self.grid
                             }];
    
    return details;
}

- (NSString *)timeString {
    NSDateFormatter * f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH:mm"];
    
    return [f stringFromDate:self.callDate];
}

- (NSString *)dayString {
    NSDateFormatter * f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"EEEE, MMMM dd, yyyy"];
    
    return [f stringFromDate:self.callDate];
}

- (NSString *)dateString {
    NSDateFormatter * f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"MM/dd/yy HH:mm"];
    
    return [f stringFromDate:self.callDate];
}

- (NSDate *)dateWithoutTime {
    NSDateComponents * comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.callDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (CLLocationCoordinate2D)coordinate {
    if (!self.latitude && !self.longitude) return CLLocationCoordinate2DMake(0, 0);
    return CLLocationCoordinate2DMake([self.latitude floatValue], [self.longitude floatValue]);
}

- (void)saveLocation {
    NSString * url = [NSString stringWithFormat:@"firecall/%@", self.objectId];
    NSDictionary * params = @{@"latitude": self.latitude,
                              @"longitude": self.longitude};
    
    APIClient * apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    
    [apiClient POST:url parameters:params completion:^(OVCResponse * response, NSError * error) {
        if (!error) {
            NSLog(@"location saved: %@", response);
//            DBLogin * login = response.result;
//            if ([login.code isEqualToString:@"success"]) {
//                MainNavigationController * mnc = (MainNavigationController *)self.navigationController;
//                [mnc loginUser:login.user];
//            } else {
//                [HUD setMode:MBProgressHUDModeText];
//                [HUD setDetailsLabelText:login.message];
//                [HUD show:YES];
//                [HUD hide:YES afterDelay:1.0];
//            }
        } else {
            NSLog(@"error: %@", error);
//            [HUD setMode:MBProgressHUDModeText];
//            [HUD setDetailsLabelText:@"Unable to connect."];
//            [HUD show:YES];
//            [HUD hide:YES afterDelay:1.0];
        }
    }];

}

@end
