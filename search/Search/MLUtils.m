//
//  MLUtils.m
//  Search
//
//  Created by Mauricio Minestrelli on 9/15/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLUtils.h"

@implementation MLUtils

+(BOOL)isRunningIos7
{
    return (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)?NO:YES;
}

@end
