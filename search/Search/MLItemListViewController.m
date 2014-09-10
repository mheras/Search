//
//  MLItemListViewController.m
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLItemListViewController.h"
#import "ProductTableViewCell.h"
#import "MLSearchItem.h"
#import "MLItemDetailViewController.h"
#import "MLSearchService.h"
#import "MLImageService.h"
#import "MLDaoImageManager.h"
#import "MLNoResultsViewController.h"
#define kProductCellHeight 72

@interface MLItemListViewController ()<MLSearchDelegate>

@property (nonatomic,strong) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSString* input;
@property (nonatomic,strong) ProductTableViewCell* lastVisibleCell;
@property (nonatomic,strong) MLSearchService* searchService;
@property (nonatomic,strong) MLImageService* thumbnailService;
@property (nonatomic,strong) NSOperationQueue* thumbnailDownloadQueue;
@property (nonatomic,strong) ProductTableViewCell* prototypeCell;

@property (nonatomic,copy) NSString * myString;

@end

@implementation MLItemListViewController

-(instancetype) init{
    
    if (self = [super init]){
        
        self.searchService = [[MLSearchService alloc]init];
        self.thumbnailService=[[MLImageService
                                alloc]init];
    }
    return self;
}

- (instancetype)initWithInput:(NSString*)input
{
    self = [self init];
    if (self) {
        self.input=input;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setTitle:@"Resultados"];
    
    [self showLoadingHud];
    
    [self.searchService startFetchingItemsWithInput:self.input andOffset:0 withCompletionBlock:^(NSArray * items) {
            [self removeLoadingHud];
            if (self.items == nil){
                self.items= [NSMutableArray arrayWithArray:items] ;
            }
            if([items count]==0) {
                [self didNotReceiveItems];
            }else{
                [self didReceiveItems:items];
            }
        
            [self.tableView reloadData];
        }
        errorBlock:^(NSError *err) {
            [self removeLoadingHud];
            NSLog(@"Error %@; %@", err, [err localizedDescription]);
        }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductCellIdentifier"];
    self.prototypeCell=[self.tableView dequeueReusableCellWithIdentifier:@"ProductCellIdentifier"];
}
-(void) viewWillDisappear:(BOOL)animated{
    [self.searchService cancel];
}

#pragma mark - SearchManagerDelegate
- (void)didReceiveItems:(NSArray *)items
{
    [self.items addObjectsFromArray:items];
}

- (void)fetchingItemsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

-(void)didNotReceiveItems{
    //Sets a noResultsView
    MLNoResultsViewController * noResultsView = [[MLNoResultsViewController alloc]initWithNibName:nil bundle:nil];
    [self.view addSubview:noResultsView.view];

}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
#warning y no hay una manera mas eficiente?
    [self setCellContent:self.prototypeCell cellForRowAtIndexPath:indexPath];
    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kProductCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTableViewCell * productCell = [tableView dequeueReusableCellWithIdentifier:@"ProductCellIdentifier"];
    [self setCellContent:productCell cellForRowAtIndexPath:indexPath];
    return productCell;
}

-(void) setCellContent:(ProductTableViewCell *) cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLSearchItem *item = self.items[indexPath.row];
    [cell.labeltitle setText:item.title];
    [cell.labelPrice setText:[NSString stringWithFormat:@"$ %@", item.price ]];
    
    NSString* soldQty=[NSString stringWithFormat:@"%d%@",item.sold_quantity,@" vendidos." ];
    [cell.labelSubtitle setText:soldQty];
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    MLSearchItem *item = self.items[indexPath.row];
    [(ProductTableViewCell*)cell setThumbnailInCell:item];
}

-(void) tableView:(UITableView *)tableView didEndDisplayingCell:(ProductTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //Cancel
    ((ProductTableViewCell *)cell).imageViewPreview.image=nil;
    [(ProductTableViewCell *)cell cancelService];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSArray *visibleRows = [self.tableView visibleCells];
    ProductTableViewCell *lastCell = [visibleRows lastObject];
    NSIndexPath *path = [self.tableView indexPathForCell:lastCell];
    if(path.row == [self.items count]-1)
    {
        if(lastCell!= self.lastVisibleCell){
            self.lastVisibleCell=lastCell;
            UIActivityIndicatorView * spinner= [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner startAnimating];
            spinner.frame = CGRectMake(0, 0, 320, 44);
            self.tableView.tableFooterView =spinner;
            [self.searchService fetchNextPage];
        }
    }
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MLSearchItem *item = self.items[indexPath.row];
    MLItemDetailViewController * detailView= [[MLItemDetailViewController alloc] initWithItem:item ];
    [self.navigationController pushViewController:detailView animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end