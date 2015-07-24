//
//  DBUser.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/1/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import <Mantle.h>

@interface DBUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber * objectId;
@property (nonatomic, copy) NSDate * createdAt;
@property (nonatomic, copy) NSDate * updatedAt;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSNumber * active;
@property (nonatomic, copy) NSNumber * admin;
@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, copy) NSString * lastName;
@property (nonatomic, copy) NSString * sound;
@property (nonatomic, copy) NSArray * departments;
@property (nonatomic, copy) NSArray * channels;

- (NSString *)fullName;
+ (DBUser *)currentUser;

@end
