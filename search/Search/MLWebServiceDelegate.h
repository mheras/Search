//
//  MLWebServiceDelegate.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/28/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSearchItem.h"

@protocol MLWebServiceDelegate <NSObject>
- (void)didReceiveItem:(MLSearchItem*)item;
-(void)didNotReceiveItem;
- (void)fetchingItemsFailedWithError:(NSError *)error;
@end
