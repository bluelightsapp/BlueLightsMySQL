//
//  DBStation.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/26/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import <Mantle.h>

@interface DBStation : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber * objectId;
@property (nonatomic, copy) NSDate * createdAt;
@property (nonatomic, copy) NSDate * updatedAt;
@property (nonatomic, copy) NSNumber * department_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * zip;
@property (nonatomic, copy) NSNumber * ordering;

@end