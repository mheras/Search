//
//  MLDaoFilesystem.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/26/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MLDaoFilesystem : NSObject

-(BOOL)isImageCachedWithId:(NSString*) identification andPath:(NSString*)path;
-(void)saveImage:(UIImage*)image withId:(NSString*)identification andPath:(NSString*)path;
-(void)saveHistory:(NSMutableArray*) history inPath:(NSString*)path;
-(void)getImageWithId:identification andPath:(NSString*)path onCompletion:(void(^)(UIImage* image))completitionBlock;
-(void)getHistoryFromPath:(NSString*)path onCompletion:(void(^)(NSMutableArray* array))completitionBlock;
@end
