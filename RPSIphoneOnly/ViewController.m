//
//  ViewController.m
//  RPSIphoneOnly
//
//  Created by student student on 03/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import "ViewController.h"
#import "GCHelper.h"



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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testBackground" ofType:@"jpg" inDirectory:@""];
    
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)btnLeaderboard:(id)sender {
    
    [GCHelper sharedInstance].delegate = self;
    [[GCHelper sharedInstance] authenticateLocalUser]; 
    
}
@end
