//
//  DBDestination.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/18/15.
//  Copyright © 2015 Alex Krush. All rights reserved.
//

#import <Mantle.h>

@interface DBDestination : MTLModel <MTLJSONSerializing>

- (id)initWithObjectId:(NSNumber *)objectId;

@property (nonatomic, copy, readonly) NSNumber * objectId;
@property (nonatomic, copy) NSDate * createdAt;
@property (nonatomic, copy) NSDate * updatedAt;
@property (nonatomic, copy) NSNumber * department_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSNumber * ordering;

@end
