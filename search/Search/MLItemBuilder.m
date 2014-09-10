//
//  GroupBuilder.m
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLItemBuilder.h"
#import "MLSearchItem.h"

@implementation MLItemBuilder
+ (NSArray *)itemsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"results"];
    NSLog(@"Count %d", results.count);
    
    for (NSDictionary *itemDic in results) {
        MLSearchItem *item = [[MLSearchItem alloc] init];
        
//        pseudo reflection
//        for (NSString *key in itemDic) {
//            if ([item respondsToSelector:NSSelectorFromString(key)]) {
//                [item setValue:[itemDic valueForKey:key] forKey:key];
//            }
//        }

        item.identifier=[itemDic valueForKey:@"id"];
        item.title=[itemDic valueForKey:@"title"];
        item.subtitle=[itemDic valueForKey:@"subtitle"];
        item.price=[itemDic valueForKey:@"price"];
        item.thumbnail=[itemDic valueForKey:@"thumbnail"];
        item.permalink=[itemDic valueForKey:@"permalink"];
        item.sold_quantity=[[itemDic valueForKey:@"sold_quantity"] integerValue];
        [items addObject:item];
    }
    
    return items;
    
}
@end
