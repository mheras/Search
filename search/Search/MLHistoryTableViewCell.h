//
//  MLHistoryTableViewCell.h
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelHistoryItem;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@end