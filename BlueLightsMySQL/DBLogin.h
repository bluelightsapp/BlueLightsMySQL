//
//  DBLogin.h
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/4/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "DBUser.h"

@interface DBLogin : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) DBUser * user;

@end
