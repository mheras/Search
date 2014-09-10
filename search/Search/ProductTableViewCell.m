//
//  ProductTableViewCell.m
//  Almacen de productos
//
//  Created by Mauricio Minestrelli on 7/25/14.
//  Copyright (c) 2014 Mercadolibre. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "MLImageService.h"

@interface ProductTableViewCell()
@property (nonatomic,strong)MLImageService* thumbnailService;
@property (strong,nonatomic) UIActivityIndicatorView * spinner;
@end

@implementation ProductTableViewCell

- (void)awakeFromNib
{
    self.imageViewPreview.image=nil;
    self.thumbnailService=[[MLImageService alloc]init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setThumbnailInCell: (MLSearchItem *) item {
    
    NSURL *url = [NSURL URLWithString:item.thumbnail];
    [self setSpinnerCenteredInView:self.imageViewPreview];
    
    if([item.thumbnail isEqualToString:@"" ]){
        [self noImageFound];
    }
    else{
        //prevent displaying inconsistent data
        [self.thumbnailService cancel];
        // download the image asynchronously
        [self.thumbnailService downloadImageWithURL:url andIdentification:item.identifier withCompletionBlock:^(NSArray *items) {
                UIImage*imageFromArray= (UIImage*)[items objectAtIndex:0];
                [self loadImage:imageFromArray withIdentifier:item.identifier];

            } errorBlock:^(NSError *err) {
                NSLog(@"Error %@; %@", err, [err localizedDescription]);
        }];
    }
    
}


-(void) cancelService{
    [self.thumbnailService cancel];
}

-(void) setSpinnerCenteredInView:(UIView*) containerView{
    self.spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(containerView.frame.size.width/2,containerView.frame.size.height/2);
    [containerView addSubview:self.spinner];
    [self.spinner startAnimating];
}

-(void) loadImage:(UIImage*)thumbnail withIdentifier:(NSString*)identifier{
    [self.spinner stopAnimating];
    self.imageViewPreview.image=thumbnail;
}

-(void) noImageFound{
    [self.spinner stopAnimating];
    self.imageViewPreview.image=[UIImage imageNamed:@"noPicI.png"];
}

@end
