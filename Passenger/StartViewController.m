/******************************************************************************
 *
 * Copyright (C) 2013 T Dispatch Ltd
 *
 * Licensed under the GPL License, Version 3.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.gnu.org/licenses/gpl-3.0.html
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ******************************************************************************
 *
 * @author Marcin Orlowski <marcin.orlowski@webnet.pl>
 *
 ****/

#import "StartViewController.h"
#import "LoginViewController.h"
#import "CreateAccountViewController.h"
#import "UserSettings.h"

@interface StartViewController () <LoginProtocolDelegate>

@property (weak, nonatomic) IBOutlet FlatButton *signInButton;
@property (weak, nonatomic) IBOutlet FlatButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *demoView;
@property (weak, nonatomic) IBOutlet UILabel *demoLabel;

@end

@implementation StartViewController

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
    
    [_signInButton setTitle:NSLocalizedString(@"main_login", @"") forState:UIControlStateNormal];
    [_signInButton setTitleColor:[UIColor buttonTextColor] forState:UIControlStateNormal];
    [_registerButton setTitle:NSLocalizedString(@"main_register", @"") forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor buttonTextColor] forState:UIControlStateNormal];

    _demoView.backgroundColor = [UIColor demoWarningBackgroundColor];
    _demoLabel.textColor = [UIColor demoWarningTextColor];
    _demoLabel.font = [UIFont lightOpenSansOfSize:14];
    _demoLabel.text = NSLocalizedString(@"demo_warning", @"");
    
    if ([CabOfficeSettings hideDemoWarning])
    {
        _demoView.hidden = YES;
    }
    else
    {
        _demoView.hidden = NO;
    }
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![UserSettings tourHasBeenShown])
    {
        [self performSegueWithIdentifier:@"showTourViewController" sender:self];
        [UserSettings setTourHasBeenShown:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSignInButton:nil];
    [self setRegisterButton:nil];
    [self setDemoView:nil];
    [self setDemoLabel:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showLoginViewController"])
    {
        LoginViewController* lvc = segue.destinationViewController;
        lvc.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"showCreateAccountViewController"])
    {
        CreateAccountViewController* cavc = segue.destinationViewController;
        cavc.delegate = self;
    }
}

- (void)loginFailed:(NSError *)error
{
    [MessageDialog showError:error.localizedDescription withTitle:NSLocalizedString(@"dialog_error_title", @"")];
}

- (void)loginFinished
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"showMainViewController" sender:self];
    }];
}

@end