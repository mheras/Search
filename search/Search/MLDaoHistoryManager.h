//
//  MLDaoHistoryManager.h
//  Networking
//
//  Created by Mauricio Minestrelli on 9/2/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLDaoHistoryManager : NSObject

-(NSMutableArray*) getHistory;
+ (id)sharedManager;
-(void)saveHistory:(NSMutableArray*) history;
-(void) deleteHistory;
@end
