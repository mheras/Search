//
//  MLWebService.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/27/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLWebServiceDelegate.h"

@interface MLWebService : NSObject

@property (weak, nonatomic) id<MLWebServiceDelegate> delegate;
@property (nonatomic,strong) NSURLConnection* connection;
@property (nonatomic, strong) NSMutableData *responseData;
@property (copy)void (^errorBlock)(NSError* err);
@property (copy)void (^successBlock)(NSArray *items);
-(void)cancel;
@end
