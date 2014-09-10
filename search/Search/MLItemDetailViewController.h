//
//  MLItemDetailViewController.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLSearchItem.h"
#import "MLAbstractViewController.h"


@interface MLItemDetailViewController : MLAbstractViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (id)initWithItem:(MLSearchItem*)item;
@end
