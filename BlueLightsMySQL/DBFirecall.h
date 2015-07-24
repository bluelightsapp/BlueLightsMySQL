//
//  DBFirecall.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/7/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import <Mantle.h>
#import <MapKit/MapKit.h>

@interface DBFirecall : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber * objectId;
@property (nonatomic, copy) NSDate * createdAt;
@property (nonatomic, copy) NSDate * updatedAt;
@property (nonatomic, copy) NSNumber * departmentId;
@property (nonatomic, copy) NSString * callId;
@property (nonatomic, copy) NSDate * callDate;
@property (nonatomic, copy) NSString * additional;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * subtype;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * sitename;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * grid;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSArray * crosses;
@property (nonatomic, copy) NSArray * hydrants;
@property (nonatomic, copy) NSArray * responses;
@property (nonatomic, copy) NSNumber * latitude;
@property (nonatomic, copy) NSNumber * longitude;

- (NSArray *)detailsArray;

- (NSString *)dispType;
- (NSString *)dispAddress;
- (NSString *)timeString;
- (NSString *)dayString;
- (NSString *)dateString;
- (NSDate *)dateWithoutTime;
- (CLLocationCoordinate2D)coordinate;

- (void)saveLocation;

@end
