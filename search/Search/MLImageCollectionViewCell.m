//
//  MLImageCollectionViewCell.m
//  Networking
//
//  Created by Mauricio Minestrelli on 8/27/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLImageCollectionViewCell.h"

#import "MLImageService.h"
@interface MLImageCollectionViewCell()
//
@property (strong, nonatomic) MLImageService* imageService;
@property (nonatomic,strong) UIActivityIndicatorView* spinner;

@end
@implementation MLImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageService=[[MLImageService alloc]init];
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MLImageCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
-(void) loadImageWithUrl:(NSURL*) url andIdentification:(NSString*)imgId{
    [self setSpinnerCenteredInView:self.imageViewPhoto];
    [self.imageService cancel];
    self.imageService=[[MLImageService alloc]init];
    [self.imageService downloadImageWithURL:url andIdentification:imgId
                        withCompletionBlock:^(NSArray *items) {
                            [self.spinner stopAnimating];
                            UIImage * image= (UIImage*)[items objectAtIndex:0];
                            if (image==nil) {
                                [self setImage:[UIImage imageNamed:@"noPicl.png" ]];
                            }else{
                                [self setImage:image];
                            }
                            
                        } errorBlock:^(NSError *err) {
                            [self.spinner stopAnimating];
                            
                        }];
}
-(void) setImage:(UIImage*) image{
    [self.imageViewPhoto setImage:image];
    [self.imageViewPhoto setContentMode:UIViewContentModeScaleAspectFit];
}
#pragma mark - aux
-(void) setSpinnerCenteredInView:(UIView*) containerView{
    self.spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(containerView.frame.size.width/2,containerView.frame.size.height/2);
    [containerView addSubview:self.spinner];
    [self.spinner startAnimating];
}

-(void) cancelService{
    [self.imageService cancel];
}

@end
