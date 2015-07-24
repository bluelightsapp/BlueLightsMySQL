//
//  APIClient.m
//  BlueLightsMySQL
//
//  Created by Alex Krush on 6/1/15.
//  Copyright (c) 2015 Alex Krush. All rights reserved.
//

#import "APIClient.h"
#import "DBRegister.h"
#import "DBLogin.h"
#import "DBUser.h"
#import "DBFirecall.h"
#import "DBResponse.h"
#import "DBDepartment.h"

@implementation APIClient

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"register": [DBRegister class],
             @"login": [DBLogin class],
             @"firecall/*": [DBFirecall class],
             @"firecall/department/*/*": [DBFirecall class],
             @"response/firecall/*": [DBResponse class],
             @"response/firecall/*/user/*": [DBResponse class],
             @"department/*": [DBDepartment class]
             };
}

@end