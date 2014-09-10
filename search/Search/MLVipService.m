//
//  MLVipService.m
//  Networking
//
//  Created by Mauricio Minestrelli on 8/28/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLVipService.h"

@implementation MLVipService

- (void)startFetchingItemsWithInput:(NSString*)input withCompletionBlock:(void (^)(NSArray *items))completionBlock errorBlock:(void (^)(NSError* err)) error{
    
    self.successBlock=completionBlock;
    self.errorBlock=error;
    NSString *urlAsString = [NSString stringWithFormat:@"https://api.mercadolibre.com/items/%@",input ];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.connection=[NSURLConnection connectionWithRequest:request delegate:self];
}

- (MLSearchItem*)receivedItemsFromJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    MLSearchItem *item = [self itemsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        self.errorBlock(error);
        return nil;
    }
    return item;
}
#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData {
	[self.responseData appendData:someData];
}

-(void)connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse *)response{
    self.responseData = [[NSMutableData alloc] init];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)aConnection {
    NSArray* items=[NSArray arrayWithObject:[self receivedItemsFromJSON:self.responseData]];
    self.successBlock(items);
}

-(void)connection:(NSURLConnection*) connection didFailWithError:(NSError *)error{
    self.errorBlock(error);
}

#pragma mark item building

- (MLSearchItem *)itemsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    MLSearchItem *item = [[MLSearchItem alloc] init];
    item.identifier=[parsedObject valueForKey:@"id"];
    item.title=[parsedObject valueForKey:@"title"];
    item.subtitle=[parsedObject valueForKey:@"subtitle"];
    item.price=[parsedObject valueForKey:@"price"];
    item.thumbnail=[parsedObject valueForKey:@"thumbnail"];
    item.permalink=[parsedObject valueForKey:@"permalink"];
    item.sold_quantity=[[parsedObject valueForKey:@"sold_quantity"] integerValue];
    NSArray * picturesResults = [parsedObject valueForKey:@"pictures"];
    NSMutableArray * picturesUrls= [[NSMutableArray alloc]init];
    for (NSDictionary *pics in picturesResults) {
        //cargar los links en el array que hay que crear arriba
        [picturesUrls addObject: [pics valueForKey:@"secure_url" ]];
    }
    //asignar el array a la property pictures
    item.pictures=picturesUrls;
    return item;
}
#pragma mark - Connection cancelling

-(void)cancel{
    [self.connection cancel];
}

-(void) dealloc{
    [self.connection cancel];
}


@end
