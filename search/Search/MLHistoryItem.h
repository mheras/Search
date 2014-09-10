//
//  MLHistoryItem.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/22/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLHistoryItem : NSObject

@property (nonatomic,copy) NSString * searchedItem;
@property (nonatomic,strong) NSDate* searchDate;
-(id)initWithItem:(NSString*)item andDate:(NSDate*)date;
@end
