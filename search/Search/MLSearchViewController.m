//
//  MLSearchViewController.m
//  Networking
//
//  Created by Mauricio Minestrelli on 8/25/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLSearchViewController.h"
#import "MLItemListViewController.h"
#import "MLHistoryTableViewCell.h"
#import "MLDaoHistoryManager.h"
#import "MLKeyboardToolbar.h"

#define kHistoryCellHeight 36;

@interface MLSearchViewController ()
//Search history
@property (nonatomic,strong)NSMutableArray* history;
@property (nonatomic,strong)MLHistoryTableViewCell* prototypeCell;
@end

@implementation MLSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.history=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewHistory.delegate = self;
    self.tableViewHistory.dataSource = self;
    self.tableViewHistory.scrollEnabled=YES;
    self.searchBar.delegate=self;
    [self registerForKeyboardNotifications];
    
    // Particular de la search
    UIImage* logoImage = [UIImage imageNamed:@"mercadolibre.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    [self.searchBar setPlaceholder:@"Buscar en Mercadolibre"];
    
    if ([[MLDaoHistoryManager sharedManager] getHistory]!=nil) {
        self.history=[[MLDaoHistoryManager sharedManager] getHistory];
    }
    
    MLKeyboardToolbar *toolBar = [[MLKeyboardToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                                 0.0f,
                                                                                 self.view.window.frame.size.width,
                                                                                 35.0f)];
    toolBar.okButton.action=@selector(doneEditing);
    self.searchBar.inputAccessoryView = toolBar;
    
    [self.tableViewHistory registerNib:[UINib nibWithNibName:@"MLHistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchHistoryCellIdentifier"];
    self.prototypeCell=[self.tableViewHistory dequeueReusableCellWithIdentifier:@"SearchHistoryCellIdentifier"];
    
    
    [self setTitle:@"Buscar"];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableViewHistory reloadData];
    /*Alternativa de appending no para un reloadeo total*/
    //    NSArray* indexPaths=[NSArray arrayWithObject:indexPath];
    //    [self.tableViewHistory beginUpdates];
    //    [self.tableViewHistory insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    //    [self.tableViewHistory endUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   MLHistoryTableViewCell * historyCell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCellIdentifier"];
    
    [self setCellContent:historyCell cellForRowAtIndexPath:indexPath];
    historyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return historyCell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MLHistoryItem* item=[self.history objectAtIndex:indexPath.row];
    [self.history removeObject:item];
    [self.history addObject:[[MLHistoryItem alloc]initWithItem:item.searchedItem andDate:[NSDate date]]];
    
    [[MLDaoHistoryManager sharedManager] saveHistory:self.history];
    [self searchWithInput:item.searchedItem];
    [self.tableViewHistory deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) setCellContent:(MLHistoryTableViewCell *) cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLHistoryItem * item=[self.history objectAtIndex:indexPath.row];
    cell.labelHistoryItem.text=item.searchedItem;
    
    //FEO
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if([item.searchDate isToday]){
        [formatter setDateFormat:@"hh:mm"];
    }
    else{
        [formatter setDateFormat:@"dd/MM/yyyy"];
    }
    
    NSString *stringFromDate = [formatter stringFromDate:item.searchDate];
    cell.labelDate.text=stringFromDate;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
#warning y no hay una manera mas eficiente?
    [self setCellContent:self.prototypeCell cellForRowAtIndexPath:indexPath];
    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHistoryCellHeight;
}
#pragma mark keyboard
/*Dismisses searchbar keyboard*/
-(void)dismissKeyboard{
    [self.searchBar resignFirstResponder];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    self.tableViewHistory.scrollEnabled=YES;
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
#warning -55.0 deberia ser tableview.bottomspace to container
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height -55.0, 0.0);
        self.tableViewHistory.contentInset = contentInsets;
        self.tableViewHistory.scrollIndicatorInsets = contentInsets;
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0,0.0, 0.0);;
        self.tableViewHistory.contentInset = contentInsets;
       self.tableViewHistory.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark searchbar
/*Search bar button clicked pushes item list view controller, adds input from search to history*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self dismissKeyboard];
    
    [self.history addObject:[[MLHistoryItem alloc]initWithItem:self.searchBar.text andDate:[NSDate date]]];
    MLDaoHistoryManager * daoHistoryManager=[MLDaoHistoryManager sharedManager];
    [daoHistoryManager saveHistory:self.history];
    
    [self searchWithInput:self.searchBar.text];
    self.searchBar.text=@"";
}

-(void)searchWithInput:(NSString*)input{
    [self dismissKeyboard];
    MLItemListViewController * controller=[[MLItemListViewController alloc]initWithInput:input];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void) doneEditing{
    [self.searchBar resignFirstResponder];
}

@end