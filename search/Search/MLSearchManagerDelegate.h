//
//  MLSearchManagerDelegate.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLSearchDelegate
- (void)didReceiveItems:(NSArray *)items;
-(void)didNotReceiveItems;
- (void)fetchingItemsFailedWithError:(NSError *)error;
@end
