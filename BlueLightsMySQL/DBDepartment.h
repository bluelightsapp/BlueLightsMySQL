//
//  DBDepartment.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/1/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import <Mantle.h>

@interface DBDepartment : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber * objectId;
@property (nonatomic, copy) NSDate * createdAt;
@property (nonatomic, copy) NSDate * updatedAt;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * callForwarder;
@property (nonatomic, copy) NSArray * destinations;

@end
