//
//  MLThumbnailResponseDelegate.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/29/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLThumbnailResponseDelegate <NSObject>
-(void) loadImageWithData:(NSData*)data andIdentifier:(NSString*)identifier;
-(void) noImageFound;
@optional
//-(void) loadImageWithData:(NSData*)data andIdentifier:(NSString*)identifier onImage:(UIImage*)image;
//-(void) noImageFoundOnImage:(UIImage*)image;
-(void) loadImage:(UIImage *) image;
@end
