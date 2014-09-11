//
//  MLLoginViewController.m
//  Search
//
//  Created by Mauricio Minestrelli on 9/11/14.
//  Copyright (c) 2014 mercadolibre. All rights reserved.
//

#import "MLLoginViewController.h"

@interface MLLoginViewController ()

- (IBAction)loginButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@end

@implementation MLLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Iniciar sesión"];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Cancelar"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                     action:@selector(dismissModal)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [self.textFieldUserName setPlaceholder:@"E-mail o nombre de usuario"];
    [self.textFieldPassword setPlaceholder:@"Contraseña"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissModal{
   [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)loginButtonPressed:(id)sender {
}
@end
