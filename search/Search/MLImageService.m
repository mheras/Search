//
//  MLThumbnailService.m
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLImageService.h"
#import "MLDaoImageManager.h"

@interface MLImageService()
@property (nonatomic,strong) NSURLConnection* connection;
@property (nonatomic,copy) NSString* identification;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic,strong) MLDaoImageManager * daoManager;
// @property (nonatomic,strong) UIImage* currentImage;
@end

@implementation MLImageService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.daoManager=[MLDaoImageManager sharedManager];
        self.identification=@"";
    }
    return self;
}


- (void)downloadImageWithURL:(NSURL *)url andIdentification:(NSString*) identification withCompletionBlock:(void (^)(NSArray *items))completionBlock errorBlock:(void (^)(NSError* err)) error{
    self.successBlock=completionBlock;
    self.errorBlock=error;
    if(![self.daoManager isImageCachedWithId:identification]){
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        self.identification=identification;
        self.connection=[NSURLConnection connectionWithRequest:request delegate:self];
    }else{
        UIImage* image=[self.daoManager getImageWithId:identification];
        NSArray * imageInArray= [NSArray arrayWithObject:image];
        completionBlock(imageInArray);
    }

}
#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}

-(void)connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse *)response{
    self.responseData = [[NSMutableData alloc] init];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{

    UIImage* image= [UIImage imageWithData:self.responseData];
    NSArray * imageInArray= [NSArray arrayWithObject:image];
    [self.daoManager saveImage:image withId:self.identification];
    self.successBlock(imageInArray);

}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.errorBlock(error);
}

-(void)cancel{
    [self.connection cancel];
}

-(void) dealloc{
    [self.connection cancel];
}
@end
