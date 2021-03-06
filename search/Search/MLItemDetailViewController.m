//
//  MLItemDetailViewController.m
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLItemDetailViewController.h"
#import "MLImageCollectionViewCell.h"
#import "MLVipService.h"
#import "MLSearchItem.h"
#import "MLImageService.h"
#import "MLLoginViewController.h"

@interface MLItemDetailViewController ()<MLWebServiceDelegate>
@property (nonatomic,strong) MLVipService * vipService;
@property (nonatomic) int currentIndex;
@property (nonatomic,strong) MLSearchItem* searchItem;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlGallery;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPhotoGallery;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *buttonBuy;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTrailingConstraint;
- (IBAction)buyButtonPressed:(id)sender;
@end

@implementation MLItemDetailViewController

-(instancetype) init{
    if([super init]){
        self.vipService= [[MLVipService alloc]init];
    }
    return self;
}
- (instancetype)initWithItem:(MLSearchItem*)item
{
    self = [self init];
    if (self) {
        // Custom initialization
        self.searchItem=item;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(![MLUtils isRunningIos7]){
        self.topViewConstraint.constant=0.0;
        self.labelTopConstraint.constant=0.0;
        

    }
    [self setupCollectionView];
    self.vipService.delegate=self;
    self.pageControlGallery.hidden = YES;
    
    [self showLoadingHud];
    
    [self.vipService startFetchingItemsWithInput:self.searchItem.identifier
        withCompletionBlock:^(NSArray * items) {
            [self removeLoadingHud];
            if([items count]==0) {
                [self didNotReceiveItem];
            }else{
                MLSearchItem * searchItem=(MLSearchItem*) [items objectAtIndex:0];
                [self didReceiveItem:searchItem];
            }
        }
        errorBlock:^(NSError *err) {
            [self removeLoadingHud];
            NSLog(@"Error %@; %@", err, [err localizedDescription]);
    }];
    
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.vipService cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)buyButtonPressed:(id)sender {
    MLLoginViewController * loginController= [[MLLoginViewController alloc]init];
    UINavigationController * navigationControllerLogin = [[UINavigationController alloc]initWithRootViewController: loginController];
    [self presentViewController:navigationControllerLogin animated:YES completion:nil];
}
#pragma mark UICollectionView methods

-(void)setupCollectionView {
    [self.collectionViewPhotoGallery registerClass:[MLImageCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionViewPhotoGallery setPagingEnabled:YES];
    [self.collectionViewPhotoGallery setCollectionViewLayout:flowLayout];

}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.searchItem.pictures count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MLImageCollectionViewCell *cell = (MLImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    self.pageControlGallery.currentPage = indexPath.row;
    self.pageControlGallery.hidden = NO;
    
    NSURL* url=[NSURL URLWithString:[self.searchItem.pictures objectAtIndex:indexPath.row]];
    NSString * imgId=[NSString stringWithFormat: @"%@-%d",self.searchItem.identifier,indexPath.row];
    [cell loadImageWithUrl:url andIdentification:imgId];
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionViewPhotoGallery.frame.size;
}

-(void) collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //Cancel
    ((MLImageCollectionViewCell *)cell).imageViewPhoto.image=nil;
    [(MLImageCollectionViewCell *)cell cancelService];
}

#pragma mark Data methods

-(void)loadVipDescriptionWithItem:(MLSearchItem*)item {
    
    self.searchItem=item;
    self.labelTitle.text=item.title;
    self.labelPrice.text=[NSString stringWithFormat:@"%f",[item.price floatValue]];
    [self.collectionViewPhotoGallery reloadData];
}

#pragma mark - search manager delegates
- (void)didReceiveItem:(MLSearchItem*)item{
    [self removeLoadingHud];
    self.pageControlGallery.numberOfPages=[item.pictures count];
    [self loadVipDescriptionWithItem:item];
}

-(void)didNotReceiveItem{
    
}
-(void)fetchingItemsFailedWithError:(NSError *)error{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


@end
