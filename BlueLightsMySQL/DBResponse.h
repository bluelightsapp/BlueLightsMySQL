//
//  DBResponse.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/18/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import <Mantle.h>
#import "DBUser.h"
#import "DBDestination.h"
#import <MapKit/MapKit.h>

@interface DBResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber * objectId;
@property (nonatomic, copy) NSDate * createdAt;
@property (nonatomic, copy) NSDate * updatedAt;
@property (nonatomic, copy) NSNumber * user_id;
@property (nonatomic, copy) DBUser * user;
@property (nonatomic, copy) NSNumber * firecall_id;
@property (nonatomic, copy) NSNumber * destination_id;
@property (nonatomic, copy) DBDestination * destination;
@property (nonatomic, copy) NSNumber * latitude;
@property (nonatomic, copy) NSNumber * longitude;

- (NSString *)timeString;
- (NSString *)updatedTimeString;
- (CLLocationCoordinate2D)coordinate;

@end
