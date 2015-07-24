//
//  DBRegister.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/1/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import <Mantle.h>
#import "DBDepartment.h"
#import "DBUser.h"

@interface DBRegister : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber * code;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) DBDepartment * department;
@property (nonatomic, copy) DBUser * user;

@end
