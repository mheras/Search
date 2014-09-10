//
//  MLDaoFilesystem.m
//  Networking
//
//  Created by Mauricio Minestrelli on 8/26/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLDaoFilesystem.h"

@implementation MLDaoFilesystem

-(UIImage*) getImageWithId:(NSString*) identification andPath:(NSString*)path{
    UIImage * thumbnail=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return thumbnail;
}
-(BOOL)isImageCachedWithId:(NSString*) identification andPath:(NSString*)path{
    return ([self getImageWithId:identification andPath:path]==nil)? NO :YES;
}
-(void)saveImage:(UIImage*)image withId:(NSString*)identification andPath:(NSString*)path{
    //writing to disk never in main thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:image toFile:path];
        
    });
}

-(NSMutableArray*) getHistoryFromPath:(NSString*)path{
#warning read should be asynchronous
    
    NSMutableArray* history=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return history;
}

-(void)saveHistory:(NSMutableArray*) history inPath:(NSString*)path{
    //writing to disk never in main thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [NSKeyedArchiver archiveRootObject:history toFile:path];
        
    });
}
@end
