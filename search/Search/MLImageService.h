//
//  MLThumbnailService.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLThumbnailResponseDelegate.h"
#import "MLWebService.h"

@interface MLImageService : MLWebService<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

-(void)cancel;
- (void)downloadImageWithURL:(NSURL *)url andIdentification:(NSString*) identification withCompletionBlock:(void (^)(NSArray *items))completionBlock errorBlock:(void (^)(NSError* err)) error;
@end
