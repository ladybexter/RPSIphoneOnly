//
//  MultiPlayerViewController.m
//  RPSIphoneOnly
//
//  Created by student student on 11/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import "MultiPlayerViewController.h"
#import "GCHelper.h"

@implementation MultiPlayerViewController
@synthesize lblStatus;
@synthesize imgOppPick;
@synthesize imgUserPick;
@synthesize btnRock;
@synthesize btnPaper;
@synthesize btnScissors;
@synthesize btnUnicorn;
@synthesize btnRobot;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [GCHelper sharedInstance].delegate = self;
    [[GCHelper sharedInstance] authenticateLocalUser];
}

- (void)viewDidUnload
{
    [self setLblStatus:nil];
    [self setImgOppPick:nil];
    [self setImgUserPick:nil];
    [self setBtnRock:nil];
    [self setBtnPaper:nil];
    [self setBtnScissors:nil];
    [self setBtnUnicorn:nil];
    [self setBtnRobot:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

-(void)imageChange:(NSString*) image:(int) number{
    if(number == 1)
    {
        imgUserPick.image = [UIImage imageNamed:(image)];
    }
    else
    {
        imgOppPick.image = [UIImage imageNamed:(image)];
    }
}

- (IBAction)btnPaper:(id)sender {
    
    GKTurnBasedMatch *currentMatch = 
    [[GCHelper sharedInstance] currentMatch];
    
    [self imageChange:@"paper2_finalise-android(78x78)nobg.png":1];
    
    NSString *userPick;
    userPick = @"2";
    NSData *data = 
    [userPick dataUsingEncoding:NSUTF8StringEncoding ];
    
    NSUInteger currentIndex = [currentMatch.participants 
                               indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    nextParticipant = [currentMatch.participants objectAtIndex: 
                       ((currentIndex + 1) % [currentMatch.participants count ])];
    [currentMatch endTurnWithNextParticipant:nextParticipant 
                                   matchData:data completionHandler:^(NSError *error) {
                                       if (error) {
                                           NSLog(@"%@", error);
                                       }
                                   }];
    NSLog(@"Send Turn, %@, %@", data, nextParticipant);
    
    
    
    
}

- (IBAction)btnScissors:(id)sender {
    
    GKTurnBasedMatch *currentMatch = 
    [[GCHelper sharedInstance] currentMatch];
    
    [self imageChange:@"scissors4_finalise-android(78x78)nobg.png":1];
    
    NSString *userPick;
    userPick = @"3";
    NSData *data = 
    [userPick dataUsingEncoding:NSUTF8StringEncoding ];
    
    NSUInteger currentIndex = [currentMatch.participants 
                               indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    nextParticipant = [currentMatch.participants objectAtIndex: 
                       ((currentIndex + 1) % [currentMatch.participants count ])];
    [currentMatch endTurnWithNextParticipant:nextParticipant 
                                   matchData:data completionHandler:^(NSError *error) {
                                       if (error) {
                                           NSLog(@"%@", error);
                                       }
                                   }];
    NSLog(@"Send Turn, %@, %@", data, nextParticipant);
}

- (IBAction)btnUnicorn:(id)sender {
    
    GKTurnBasedMatch *currentMatch = 
    [[GCHelper sharedInstance] currentMatch];
    
    [self imageChange:@"unicorn3_finalise-android(78x78)nobg.png":1];
    
    NSString *userPick;
    userPick = @"4";
    NSData *data = 
    [userPick dataUsingEncoding:NSUTF8StringEncoding ];
    
    NSUInteger currentIndex = [currentMatch.participants 
                               indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    nextParticipant = [currentMatch.participants objectAtIndex: 
                       ((currentIndex + 1) % [currentMatch.participants count ])];
    [currentMatch endTurnWithNextParticipant:nextParticipant 
                                   matchData:data completionHandler:^(NSError *error) {
                                       if (error) {
                                           NSLog(@"%@", error);
                                       }
                                   }];
    NSLog(@"Send Turn, %@, %@", data, nextParticipant);
}

- (IBAction)btnRobot:(id)sender {
    
    GKTurnBasedMatch *currentMatch = 
    [[GCHelper sharedInstance] currentMatch];
    
    [self imageChange:@"robot4_finalise-android(78x78)nobg.png":1];
    
    NSString *userPick;
    userPick = @"5";
    NSData *data = 
    [userPick dataUsingEncoding:NSUTF8StringEncoding ];
    
    NSUInteger currentIndex = [currentMatch.participants 
                               indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    nextParticipant = [currentMatch.participants objectAtIndex: 
                       ((currentIndex + 1) % [currentMatch.participants count ])];
    [currentMatch endTurnWithNextParticipant:nextParticipant 
                                   matchData:data completionHandler:^(NSError *error) {
                                       if (error) {
                                           NSLog(@"%@", error);
                                       }
                                   }];
    NSLog(@"Send Turn, %@, %@", data, nextParticipant);
}

- (IBAction)btnRock:(id)sender {
    
    GKTurnBasedMatch *currentMatch = 
    [[GCHelper sharedInstance] currentMatch];
    
    [self imageChange:@"rock5._finalise-android(78x78)nobg.png":1];
    
    NSString *userPick;
    userPick = @"1";
    NSData *data = 
    [userPick dataUsingEncoding:NSUTF8StringEncoding ];
    
    NSUInteger currentIndex = [currentMatch.participants 
                               indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    nextParticipant = [currentMatch.participants objectAtIndex: 
                       ((currentIndex + 1) % [currentMatch.participants count ])];
    [currentMatch endTurnWithNextParticipant:nextParticipant 
                                   matchData:data completionHandler:^(NSError *error) {
                                       if (error) {
                                           NSLog(@"%@", error);
                                       }
                                   }];
    NSLog(@"Send Turn, %@, %@", data, nextParticipant);
}

- (IBAction)btnAIAdvice:(id)sender {
    
    UIAlertView *eventChoiceNow = [[UIAlertView alloc] initWithTitle:nil message:@"Lina: I suggest UNICORN \n\n Joanna: I suggest SCISSORS" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [eventChoiceNow show];
}

- (IBAction)presentGCTurnViewController:(id)sender {
    [[GCHelper sharedInstance] 
     findMatchWithMinPlayers:2 maxPlayers:2 viewController:self];
}

-(void)layoutMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Viewing match where it's not our turn...");
    NSString *statusString;
    
    if (match.status == GKTurnBasedMatchStatusEnded) {
        statusString = @"Match Ended";
    } else {
        int playerNum = [match.participants 
                         indexOfObject:match.currentParticipant] + 1;
        statusString = [NSString stringWithFormat:
                        @"Player %d's Turn", playerNum];
    }
    lblStatus.text = statusString;
    btnRobot.enabled = NO;
    btnPaper.enabled = NO;
    btnScissors.enabled = NO;
    btnUnicorn.enabled = NO;
    btnRock.enabled = NO;
    lblStatus.text = statusString;
    //NSString *storySoFar = [NSString stringWithUTF8String:
                            //[match.matchData bytes]];
    //mainTextController.text = storySoFar;
}

#pragma mark - GCTurnBasedMatchHelperDelegate

-(void)enterNewGame:(GKTurnBasedMatch *)match {
    NSLog(@"Entering new game...");
    lblStatus.text = @"Please start new game";
}

-(void)takeTurn:(GKTurnBasedMatch *)match {
    NSLog(@"Taking turn for existing game...");
    if ([match.matchData bytes]) {
        NSString *oppPick = 
        [NSString stringWithUTF8String:[match.matchData bytes]];
        lblStatus.text = oppPick;
    }
}



@end
