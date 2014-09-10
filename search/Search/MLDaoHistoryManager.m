//
//  MLDaoHistoryManager.m
//  Networking
//
//  Created by Mauricio Minestrelli on 9/2/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLDaoHistoryManager.h"
#import "MLDaoMemory.h"
#import "MLDaoFilesystem.h"
@interface MLDaoHistoryManager()

@property (nonatomic,strong) MLDaoMemory * daoMemory;
@property (nonatomic,strong) MLDaoFilesystem * daoFileSystem;
@property (nonatomic) BOOL initializedFromCache;

@end

@implementation MLDaoHistoryManager

+ (id)sharedManager {
    static MLDaoHistoryManager *sharedDaoHistoryManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDaoHistoryManager = [[self alloc] init];
    });
    return sharedDaoHistoryManager;
}
-(id) init{
    if([super init]){
        self.initializedFromCache=NO;
        self.daoFileSystem=[[MLDaoFilesystem alloc]init];
        self.daoMemory=[[MLDaoMemory alloc]init];
    }
    return self;
}
-(NSMutableArray*) getHistory{
    return [self.daoFileSystem getHistoryFromPath:[[self getCacheFilePath]stringByAppendingString:@"history.dat"]];
}

-(void)saveHistory:(NSMutableArray*) history {
    [self.daoFileSystem saveHistory:history inPath:[[self getCacheFilePath]stringByAppendingString:@"history.dat"]];
}

-(void) deleteHistory{
    [self saveHistory:[[NSMutableArray alloc]init]];
}

-(NSString*) getCacheFilePath{
    /*Library folder, where you store configuration files and writable databases that you also want to keep around, but you don't want the user to be able to mess with through iTunes*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return documentDirectory;
}
@end
