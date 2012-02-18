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
@synthesize lblRound;
@synthesize btnRock;
@synthesize btnPaper;
@synthesize btnScissors;
@synthesize btnUnicorn;
@synthesize btnRobot;

int cArray[5];
int playerMe;


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
    
    btnRobot.enabled = NO;
    btnPaper.enabled = NO;
    btnScissors.enabled = NO;
    btnUnicorn.enabled = NO;
    btnRock.enabled = NO;
    
    lblStatus.text = @"";
    lblRound.text = @"";
    
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
    [self setLblRound:nil];
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

-(void)sendTurn{
    
    GKTurnBasedMatch *currentMatch = 
    [[GCHelper sharedInstance] currentMatch];
    
    NSUInteger currentIndex = [currentMatch.participants 
                               indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    
    NSUInteger nextIndex = (currentIndex + 1) % 
    [currentMatch.participants count];
    nextParticipant = 
    [currentMatch.participants objectAtIndex:nextIndex];
    
    for (int i = 0; i < [currentMatch.participants count]; i++) {
        nextParticipant = [currentMatch.participants 
                           objectAtIndex:((currentIndex + 1 + i) % 
                                          [currentMatch.participants count ])];
        if (nextParticipant.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            NSLog(@"isnt' quit %@", nextParticipant);
            break;
        } else {
            NSLog(@"nex part %@", nextParticipant);
        }
    }
    
    
    //increase turn count to 1
    
    cArray[2] = [[gameInfoArray objectAtIndex:2] floatValue] + 1;
    [gameInfoArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithDouble:cArray[2]]];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameInfoArray]; 
    
    if ([[gameInfoArray objectAtIndex:2] floatValue] /2 == 5 ) {
        for (GKTurnBasedParticipant *part in currentMatch.participants) {
            part.matchOutcome = GKTurnBasedMatchOutcomeTied;
        }
        [currentMatch endMatchInTurnWithMatchData:data 
                                completionHandler:^(NSError *error) {
                                    if (error) {
                                        NSLog(@"%@", error);
                                    }
                                }];
        lblStatus.text = @"Game has ended";
    } else {
        [currentMatch endTurnWithNextParticipant:nextParticipant 
                                       matchData:data completionHandler:^(NSError *error) {
                                           if (error) {
                                               NSLog(@"%@", error);
                                               lblStatus.text = 
                                               @"Oops, there was a problem.  Try that again.";
                                           } else {
                                               lblStatus.text = @"Your turn is over.";
                                               btnRobot.enabled = NO;
                                               btnPaper.enabled = NO;
                                               btnScissors.enabled = NO;
                                               btnUnicorn.enabled = NO;
                                               btnRock.enabled = NO;
                                           }
                                       }];
        
        
    }
    NSLog(@"Send Turn, %@, %@", data, nextParticipant);
    
    

    
}

- (IBAction)btnPaper:(id)sender {
    
    
    
    [self imageChange:@"paper2_finalise-android(78x78)nobg.png":1];
    
    //set userMePick to 2
    if (playerMe == 1)
    {
        [gameInfoArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithDouble:2]];
    }
    else if (playerMe == 2)
    {
        [gameInfoArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithDouble:2]];
    }
    
    [self sendTurn];
        
}

- (IBAction)btnScissors:(id)sender {
    
    
    [self imageChange:@"scissors4_finalise-android(78x78)nobg.png":1];
    
    //set userMePick to 3
    if (playerMe == 1)
    {
        [gameInfoArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithDouble:3]];
    }
    else if (playerMe == 2)
    {
        [gameInfoArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithDouble:3]];
    }
    
    [self sendTurn];
    
}

- (IBAction)btnUnicorn:(id)sender {
    
    
    [self imageChange:@"unicorn3_finalise-android(78x78)nobg.png":1];
    
    //set userMePick to 4
    if (playerMe == 1)
    {
        [gameInfoArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithDouble:4]];
    }
    else if (playerMe == 2)
    {
        [gameInfoArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithDouble:4]];
    }
    [self sendTurn];
}

- (IBAction)btnRobot:(id)sender {
    
    
    [self imageChange:@"robot4_finalise-android(78x78)nobg.png":1];
    
    //set userMePick to 5
    if (playerMe == 1)
    {
        [gameInfoArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithDouble:5]];
    }
    else if (playerMe == 2)
    {
        [gameInfoArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithDouble:5]];
    }
    
    [self sendTurn];
}

- (IBAction)btnRock:(id)sender {
    
    [self imageChange:@"rock5._finalise-android(78x78)nobg.png":1];
    
    //set userMePick to 1
    if (playerMe == 1)
    {
        [gameInfoArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithDouble:1]];
    }
    else if (playerMe == 2)
    {
        [gameInfoArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithDouble:1]];
    }
    
    [self sendTurn];
}

- (IBAction)btnAIAdvice:(id)sender {
    
    UIAlertView *eventChoiceNow = [[UIAlertView alloc] initWithTitle:nil message:@"Lina: I suggest UNICORN \n\n Joanna: I suggest SCISSORS" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [eventChoiceNow show];
}

- (IBAction)presentGCTurnViewController:(id)sender {
    [[GCHelper sharedInstance] 
     findMatchWithMinPlayers:2 maxPlayers:2 viewController:self];
    btnRobot.enabled = YES;
    btnPaper.enabled = YES;
    btnScissors.enabled = YES;
    btnUnicorn.enabled = YES;
    btnRock.enabled = YES;
    
}

-(void)checkForEnding:(double)roundCount {
    
    if (roundCount/2 == 5)
    {
        
        lblStatus.text = @"Match has ended";
    }
}


-(void) displayChange:(int)indexForPlayer:(int) selfOrOpp
{
    //check what opp picked
    cArray[indexForPlayer] = [[gameInfoArray objectAtIndex:indexForPlayer] floatValue];
    
    if (cArray[indexForPlayer] == 1)
    {
        [self imageChange:@"rock5._finalise-android(78x78)nobg.png":selfOrOpp];
    }
    else if (cArray[indexForPlayer] == 2)
    {
        [self imageChange:@"paper2_finalise-android(78x78)nobg.png":selfOrOpp];
    }
    else if (cArray[indexForPlayer] == 3)
    {
        [self imageChange:@"scissors4_finalise-android(78x78)nobg.png":selfOrOpp];
    }
    else if (cArray[indexForPlayer] == 4)
    {
        [self imageChange:@"unicorn3_finalise-android(78x78)nobg.png":selfOrOpp];
    }
    else if (cArray[indexForPlayer] == 5)
    {
        [self imageChange:@"robot4_finalise-android(78x78)nobg.png":selfOrOpp];
    }
}

-(void)layoutMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Viewing match where it's not our turn...");
    NSString *statusString;
    
    if (match.status == GKTurnBasedMatchStatusEnded) {
        statusString = @"Match Ended";
    } 
    else
    {
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
    
    gameInfoArray = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    
    GKTurnBasedParticipant *firstParticipant = 
    [match.participants objectAtIndex:0];
    if (firstParticipant == match.currentParticipant)
    {
        playerMe = 1;
    }
    else
    {
        playerMe = 2;
    }
    
    // check to see if turn count is even, if even then display opp, if odd dont
    cArray[2] = [[gameInfoArray objectAtIndex:2] floatValue];
    if (cArray[2]% 2 ==0)
    {
        //display round
        int round = cArray[2]/2;
        lblRound.text = [NSString stringWithFormat:@"%d",round];
        
        if (playerMe == 1)
        {
            //display what user picked for round
            [self displayChange:3 :1];
            //display what opp picked for round
            [self displayChange:4:2];
        }
        else if (playerMe == 2)
        {
            [self displayChange:4 : 1];
            [self displayChange:3:2];
        }

    }
    else
    {
        int round = cArray[2]/2 - 1;
        lblRound.text = [NSString stringWithFormat:@"%d",round];
        [self imageChange:@"xrps-wp7-f4-2.png.png":2];
    }
    
    
        [self checkForEnding:cArray[2]];
    
    //NSString *storySoFar = [NSString stringWithUTF8String:
                            //[match.matchData bytes]];
    //mainTextController.text = storySoFar;
}

-(void)sendNotice:(NSString *)notice forMatch:
(GKTurnBasedMatch *)match {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:
                       @"Another game needs your attention!" message:notice 
                                                delegate:self cancelButtonTitle:@"Sweet!" 
                                       otherButtonTitles:nil];
    [av show];
}



-(void)recieveEndGame:(GKTurnBasedMatch *)match {
    [self layoutMatch:match];
}

#pragma mark - GCTurnBasedMatchHelperDelegate

-(void)enterNewGame:(GKTurnBasedMatch *)match {
    NSLog(@"Entering new game...");
    
    // 0= currentScorePlayer1, 1 = currentScorePlayer2, 2= turn, 3 = player1Pick, 4= player2Pick,
    
     gameInfoArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble:1],
                                   [NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble:1],nil];
    
    btnRobot.enabled = YES;
    btnPaper.enabled = YES;
    btnScissors.enabled = YES;
    btnUnicorn.enabled = YES;
    btnRock.enabled = YES;
    lblStatus.text = @"Please start new game";
    lblRound.text = @"Round:1";
}



-(void)takeTurn:(GKTurnBasedMatch *)match {
    
    
    gameInfoArray = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    
    NSLog(@"Taking turn for existing game...");
    btnRobot.enabled = YES;
    btnPaper.enabled = YES;
    btnScissors.enabled = YES;
    btnUnicorn.enabled = YES;
    btnRock.enabled = YES;
    lblStatus.text =@"It's your turn";
    
    GKTurnBasedParticipant *firstParticipant = 
    [match.participants objectAtIndex:0];
    if (firstParticipant == match.currentParticipant)
    {
        playerMe = 1;
    }
    else
    {
        playerMe = 2;
    }
        
    
    // check to see if turn count is even, if even then display opp, if odd dont
    cArray[2] = [[gameInfoArray objectAtIndex:2] floatValue];
    if (cArray[2]% 2 ==0)
    {
        //display round
        int round = cArray[2]/2;
        lblRound.text = [NSString stringWithFormat:@"%d",round];
        
        if (playerMe == 1)
        {
            //display what user picked for round
            [self displayChange:3 :1];
            //display what opp picked for round
            [self displayChange:4:2];
        }
        else if (playerMe == 2)
        {
            //display what user picked for round
            [self displayChange:4 :1];
            //display whatt opp picked for round
            [self displayChange:3:2];
        }
    }
    else
    {
        int round = cArray[2]/2 - 1;
        lblRound.text = [NSString stringWithFormat:@"%d",round];
        [self imageChange:@"xrps-wp7-f4-2.png.png":2];
    }
    
    [self checkForEnding:cArray[2]];
}



@end
