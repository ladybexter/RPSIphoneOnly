//
//  ViewController.m
//  RPSIphoneOnly
//
//  Created by student student on 03/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import "ViewController.h"

#import "GCHelper.h"
#import "AppSpecificValues.h"
#import "Reachability.h"
#import "SystemConfiguration/SystemConfiguration.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XRPSInterfacebackground3" ofType:@"png" inDirectory:@""];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:path]]];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
    
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    // UIAlertView in landscape mode
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.1];
    //alertView.transform = CGAffineTransformRotate(alertView.transform, 3.14159/2);
    [UIView commitAnimations];
}

- (BOOL) connectedToNetwork
{
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

-(BOOL) checkInternet
{
	//Make sure we have internet connectivity
	if([self connectedToNetwork] != YES)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make an internet connection at this time. The leaderboard will be unavailabe until a connection is made." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self didPresentAlertView:alert];
		return NO;
	}
	else {
		return YES;
	}
}


- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated: YES];
}

- (IBAction)btnLeaderboard:(id)sender {
    
    if ([self checkInternet] == YES)
    {
        
        [GCHelper sharedInstance].delegate = (id)self;
        [[GCHelper sharedInstance] authenticateLocalUser]; 
    
        if([GKLocalPlayer localPlayer].authenticated) {
            GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
            if (leaderboardController != NULL)
            {
                leaderboardController.category = kLeaderboardID;
                leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
                leaderboardController.leaderboardDelegate = (id)self;
                [self presentModalViewController: leaderboardController animated: YES];
            }
        }
    }
}


@end
