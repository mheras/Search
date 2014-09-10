//
//  MLDaoFilesystem.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/26/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLDaoFilesystem : NSObject
-(UIImage*) getImageWithId:(NSString*) identification andPath:(NSString*)path;
-(BOOL)isImageCachedWithId:(NSString*) identification andPath:(NSString*)path;
-(void)saveImage:(UIImage*)image withId:(NSString*)identification andPath:(NSString*)path;
-(NSMutableArray*) getHistoryFromPath:(NSString*)path;
-(void)saveHistory:(NSMutableArray*) history inPath:(NSString*)path;
@end
