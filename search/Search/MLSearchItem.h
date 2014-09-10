//
//  MLSearchItem.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLSearchItem : NSObject
@property (nonatomic,copy) NSString* identifier;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic) NSNumber * price;
@property (nonatomic,copy) NSString * thumbnail;
@property (nonatomic,copy) NSString * permalink;
@property (nonatomic) NSInteger sold_quantity;
@property (nonatomic,strong)NSMutableArray* pictures;
@end
