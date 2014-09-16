//
//  MLDaoFilesystem.m
//  Networking
//
//  Created by Mauricio Minestrelli on 8/26/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLDaoFilesystem.h"

@implementation MLDaoFilesystem

-(void)getImageWithId:identification andPath:(NSString*)path onCompletion:(void(^)(UIImage* image))completitionBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * thumbnail=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(thumbnail);
        });
        
    });
}
-(BOOL)isImageCachedWithId:(NSString*) identification andPath:(NSString*)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
-(void)saveImage:(UIImage*)image withId:(NSString*)identification andPath:(NSString*)path{
    //writing to disk never in main thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:image toFile:path];
        
    });
}

-(void)getHistoryFromPath:(NSString*)path onCompletion:(void(^)(NSMutableArray* array))completitionBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray* history=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(history);
        });
        
    });
}

-(void)saveHistory:(NSMutableArray*) history inPath:(NSString*)path{
    //writing to disk never in main thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [NSKeyedArchiver archiveRootObject:history toFile:path];
        
    });
}
@end
