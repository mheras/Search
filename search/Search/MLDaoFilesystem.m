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
    #warning must be async
    UIImage * thumbnail=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return thumbnail;
}
-(BOOL)isImageCachedWithId:(NSString*) identification andPath:(NSString*)path{
    return ([self getImageWithId:identification andPath:path]==nil)? NO :YES;
//    __block BOOL cached;
//    [self getImageWithId:identification andPath:path completionBlock:^(UIImage * image)  {
//        cached=YES;
//    } errorBlock:^(UIImage *image) {
//        cached=NO;
//    }];
//    return cached;
}
-(void)saveImage:(UIImage*)image withId:(NSString*)identification andPath:(NSString*)path{
    //writing to disk never in main thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:image toFile:path];
        
    });
}

-(NSMutableArray*) getHistoryFromPath:(NSString*)path{
#warning must be async
    NSMutableArray* history=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return history;
}

-(void) getHistoryFromPath:(NSString*)path completionBlock:(void (^)(NSMutableArray*)) completion errorBlock:(void (^)(NSMutableArray*)) error {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray* history=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (history!=nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(history);
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                error(history);
            });
        }
    });
}
//-(void) getImageWithId:(NSString*) identification andPath:(NSString*)path {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//     UIImage * thumbnail=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
//        if (thumbnail!=nil){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.delegate didFinishUnarchivingImage:thumbnail];
//            });
//        }
//    });
//}



-(void)saveHistory:(NSMutableArray*) history inPath:(NSString*)path{
    //writing to disk never in main thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [NSKeyedArchiver archiveRootObject:history toFile:path];
        
    });
}
@end
