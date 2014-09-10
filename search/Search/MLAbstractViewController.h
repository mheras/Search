//
//  MLAbstractViewController.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MLAbstractViewController : UIViewController
@property (nonatomic,strong) MBProgressHUD * progressHud;
@property (nonatomic,strong) NSOperationQueue* thumbnailDownloadQueue;
-(void) showLoadingHud;
-(void) removeLoadingHud;
@end
