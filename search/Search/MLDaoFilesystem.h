//
//  MLDaoFilesystem.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/26/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MLDaoFilesystemDelegate <NSObject>
@optional
-(NSMutableArray*) didFinishLoadingHistory:(NSMutableArray *)history;
-(UIImage*) didFinishUnarchivingImage:(UIImage*)image;
@end

@interface MLDaoFilesystem : NSObject

-(UIImage*) getImageWithId:(NSString*) identification andPath:(NSString*)path;
-(BOOL)isImageCachedWithId:(NSString*) identification andPath:(NSString*)path;
-(void)saveImage:(UIImage*)image withId:(NSString*)identification andPath:(NSString*)path;
-(NSMutableArray*) getHistoryFromPath:(NSString*)path;
-(void)saveHistory:(NSMutableArray*) history inPath:(NSString*)path;

//-(void) getHistoryFromPath:(NSString*)path completionBlock:(void (^)(NSMutableArray*)) completion errorBlock:(void (^)(NSMutableArray*)) error;
//-(void) getImageWithId:(NSString*) identification andPath:(NSString*)path completionBlock:(void (^)(UIImage*)) completion errorBlock:(void (^)(UIImage*)) error;
//@property id<MLDaoFilesystemDelegate> delegate;
@end
