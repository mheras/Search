//
//  GroupBuilder.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLItemBuilder : NSObject

+ (NSArray *)itemsFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end