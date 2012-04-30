//
//  MultiPlayerViewController.m
//  RPSIphoneOnly
//
//  Created by student student on 11/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import "MultiPlayerViewController.h"
#import "GCHelper.h"
#import "AppSpecificValues.h"

@implementation MultiPlayerViewController


@synthesize gameCenterManager;
@synthesize lblStatus;
@synthesize imgOppPick;
@synthesize imgUserPick;
@synthesize lblRound;
@synthesize lblPlayerName;
@synthesize lblUserScore;
@synthesize lblOppScore;
@synthesize lblYOUResult;
@synthesize lblHowResult;
@synthesize lblVS;
@synthesize btnRock;
@synthesize btnPaper;
@synthesize btnScissors;
@synthesize btnUnicorn;
@synthesize btnRobot;
@synthesize btnAdvice;

int cArray[7];
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

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    // UIAlertView in landscape mode
    //[UIView beginAnimations:@"" context:nil];
    //[UIView setAnimationDuration:0.1];
    alertView.transform = CGAffineTransformRotate(alertView.transform, 3.14159/2);
    //[UIView commitAnimations];
}

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
    
    lblStatus.text = @"Please press Game Center to get started";
    lblRound.text = @"";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XRPSInterfacebackground3" ofType:@"png" inDirectory:@""];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:path]]];
    
    UIAlertView *eventInstruct = [[UIAlertView alloc] initWithTitle:nil message:@"Please press Game Center to either \n\n START NEW game \n or \n CONTINUE game" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [eventInstruct show];
    [self didPresentAlertView:eventInstruct];
    
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
    [self setLblPlayerName:nil];
    [self setLblUserScore:nil];
    [self setLblOppScore:nil];
    [self setLblYOUResult:nil];
    [self setLblHowResult:nil];
    [self setLblVS:nil];
    [self setBtnAdvice:nil];
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


-(void)tie
{
    lblHowResult.textColor =[UIColor blueColor];
    lblYOUResult.textColor = [UIColor blueColor];
    lblYOUResult.text = @"YOU TIE";
    lblHowResult.text = @"No Win, No Lose";
    //[self displayORHide:3];  
    
}

-(void)win
{
    lblHowResult.textColor =[UIColor greenColor];
    lblYOUResult.textColor = [UIColor greenColor];
    lblYOUResult.text = @"YOU WIN";
    
    
    //update userscore by one if win
    if (playerMe == 2)
    {
        cArray[1] = [[gameInfoArray objectAtIndex:1] floatValue] + 1;
        [gameInfoArray replaceObjectAtIndex:1 withObject:[NSNumber numberWithDouble:cArray[1]]];
    }
    
    //[self displayORHide:3];  
}

-(void)lose
{
    lblHowResult.textColor =[UIColor redColor];
    lblYOUResult.textColor = [UIColor redColor];
    lblYOUResult.text =@"YOU LOSE";
    
    //update oppscore by one if win
    if (playerMe == 2)
    {
        cArray[0] = [[gameInfoArray objectAtIndex:0] floatValue] + 1;
        [gameInfoArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble:cArray[0]]];
    }
    
    //[self displayORHide:3];  
}



-(void)resultsDisplay:(double)userpick :(double)opppick
{
    
    if (userpick == 1)
    {
        if (opppick == 1)
        {
            [self tie];
        }
        else if (opppick == 2)
        {
            lblHowResult.text = @"Paper 'wraps' around Rock";
            [self lose];
            
        }
        else if (opppick == 3)
        {
            lblHowResult.text = @"Rock 'breaks' Scissors";
            [self win];
            
        }
        else if (opppick == 4)
        {
            lblHowResult.text = @"Rock 'knocks' out Unicorn";
            [self win];
        }
        else if (opppick == 5)
        {
            lblHowResult.text = @"Robot 'smashes' Rock";
            [self lose];
        }
    }
    else if (userpick == 2)
    {
        if (opppick == 1)
        {
            lblHowResult.text = @"Paper 'wraps' around Rock";
            [self win ];
        }
        else if (opppick == 2)
        {
            [self tie ];
        }
        else if (opppick == 3)
        {
            lblHowResult.text = @"Scissors 'cut' Paper";
            [self lose ];
        }
        else if (opppick == 4)
        {
            lblHowResult.text = @"Unicorn 'pokes' hole in Paper";
            [self lose ];
        }
        else if (opppick == 5)
        {
            lblHowResult.text = @"Paper 'blinds' Robot vision";
            [self win ];
        }
    }
    else if (userpick == 3)
    {
        if (opppick == 1)
        {
            lblHowResult.text = @"Rock 'breaks' Scissors";
            [self lose ];
        }
        else if (opppick == 2)
        {
            lblHowResult.text = @"Scissors 'cut' Paper";
            [self win ];
        }
        else if (opppick == 3)
        {
            [self tie ];
        }
        else if (opppick == 4)
        {
            lblHowResult.text = @"Unicorn 'stomps' on Scissors";
            [self lose ];
        }
        else if (opppick == 5)
        {
            lblHowResult.text = @"Scissors 'cut' Robot wires";
            [self win ];
        }
    }
    else if (userpick == 4)
    {
        if (opppick == 1)
        {
            lblHowResult.text = @"Rock 'knocks out' Unicorn";
            [self lose ];
        }
        else if (opppick == 2)
        {
            lblHowResult.text = @"Unicorn 'pokes' hole in Paper";
            [self win ];
        }
        else if (opppick == 3)
        {
            lblHowResult.text = @"Unicorn 'stomps' on Scissors";
            [self win ];
        }
        else if (opppick == 4)
        {
            [self tie ];
        }
        else if (opppick == 5)
        {
            lblHowResult.text = @"Robot laser 'shoots' Unicorn";
            [self lose ];
        }
    }
    else if (userpick == 5)
    {
        if (opppick == 1)
        {
            lblHowResult.text = @"Robot 'smashes' Rock";
            [self win ];
        }
        else if (opppick == 2)
        {
            lblHowResult.text = @"Paper 'blinds' Robot vision";
            [self lose ];
        }
        else if (opppick == 3)
        {
            lblHowResult.text = @"Scissors 'cut' Robot wires";
            [self lose ];
        }
        else if (opppick == 4)
        {
            lblHowResult.text = @"Robot laser 'shoots' Unicorn";
            [self win ];
        }
        else if (opppick == 5)
        {
            [self tie ];
        }
    }
    
    
    if (playerMe == 1)
    {
        int oppScore = [[gameInfoArray objectAtIndex:1] floatValue];
        int userScore = [[gameInfoArray objectAtIndex:0] floatValue];
        lblOppScore.text = [NSString stringWithFormat:@"%d",oppScore];
        lblUserScore.text = [NSString stringWithFormat:@"%d",userScore];    
    }
    else
    {
        int oppScore = [[gameInfoArray objectAtIndex:0] floatValue];
        int userScore = [[gameInfoArray objectAtIndex:1] floatValue];
        lblOppScore.text = [NSString stringWithFormat:@"%d",oppScore];
        lblUserScore.text = [NSString stringWithFormat:@"%d",userScore];    
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
    else
    {
        [self imageChange:@"xrps-wp7-f4-2.png":selfOrOpp];
    }
}


-(void)checkForEnding:(double)roundCount {
    
    if (roundCount == 5)
    {
        
        lblStatus.text = @"Match has ended";
    }
}

-(void)sendTurn{
    
    
    //increase turnCount by 1
    cArray[5] = [[gameInfoArray objectAtIndex:5] floatValue] + 1;
    [gameInfoArray replaceObjectAtIndex:5 withObject:[NSNumber numberWithDouble:cArray[5]]];
    
    if (playerMe == 1)
    {
        //reset image for next round
        [gameInfoArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithDouble:0]];
        
        lblHowResult.hidden = YES;
        lblYOUResult.hidden = YES;
        
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
    
    
    //increase turn by 1 after player 2 turns
    if (playerMe == 2)
    {
        
        lblYOUResult.hidden = NO;
        lblHowResult.hidden = NO;
        
        cArray[2] = [[gameInfoArray objectAtIndex:2] floatValue] + 1;
    [gameInfoArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithDouble:cArray[2]]];
        
        
        [self resultsDisplay:[[gameInfoArray objectAtIndex:4] floatValue] : [[gameInfoArray objectAtIndex:3] floatValue]];
        
        [self checkForEnding:cArray[2]];
        
        
    }
    
    
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameInfoArray]; 
    
    if ([[gameInfoArray objectAtIndex:5] floatValue] == 5) {
            
        btnRobot.enabled = NO;
        btnPaper.enabled = NO;
        btnScissors.enabled = NO;
        btnUnicorn.enabled = NO;
        btnRock.enabled = NO;
        
            GKTurnBasedParticipant *firstPlayer;
            firstPlayer = 
            [currentMatch.participants objectAtIndex:0];
            GKTurnBasedParticipant *secondPlayer;
            secondPlayer = [currentMatch.participants objectAtIndex:1];
        
            
            if ([[gameInfoArray objectAtIndex:0] floatValue] == [[gameInfoArray objectAtIndex:1] floatValue])
            {
                //setting match outcome for currentplayer to tied .. show popup result for 2.player
                secondPlayer.matchOutcome = GKTurnBasedMatchOutcomeTied;
                UIAlertView *outcomeEventTie = [[UIAlertView alloc] initWithTitle:nil message:@"YOU TIE" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [outcomeEventTie show];
                
                //setting matchoutcome for firstplayer to tied
                firstPlayer.matchOutcome = GKTurnBasedMatchOutcomeTied;
               
            }
            else if ([[gameInfoArray objectAtIndex:0] floatValue] > [[gameInfoArray objectAtIndex:1] floatValue])
            {
                //second player lost .. display pop up result for 2.player
                secondPlayer.matchOutcome = GKTurnBasedMatchOutcomeLost;
                UIAlertView *outcomeEventLost = [[UIAlertView alloc] initWithTitle:nil message:@"YOU LOST :(" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [outcomeEventLost show];
                
                //first player won
                firstPlayer.matchOutcome = GKTurnBasedMatchOutcomeWon;
                
                
                
                 //get player 1 score on leaderboard
                 if([GKLocalPlayer localPlayer].authenticated) {
                     NSArray *arr = [[NSArray alloc] initWithObjects:[gameInfoArray objectAtIndex:8], nil];
                     GKLeaderboard *board = [[GKLeaderboard alloc] initWithPlayerIDs:arr];
                     if(board != nil) {
                         board.timeScope = GKLeaderboardTimeScopeAllTime;
                         board.range = NSMakeRange(1, 1);
                         board.category = @"HighscoreTable";
                         [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                             if (error != nil) {
                                 // handle the error.
                                 NSLog(@"Error retrieving score.");
                             }
                             if (scores != nil) {
                                 
                                 //get current player 1 leaderboard score
                                 int currentPlayer1Score = ((GKScore*)[scores objectAtIndex:0]).value;
                                 //increase current leaderboard score by 1
                                 currentPlayer1Score = currentPlayer1Score + 1;
                                 //send updated score to game center
                                 [self.gameCenterManager reportScore: currentPlayer1Score forCategory: kLeaderboardID];
                             }
                             else
                             {
                                 //send updated score to game center
                                 [self.gameCenterManager reportScore: 1 forCategory: kLeaderboardID];
                             }
                         }];
                     }
                }

                
                
            }
            else if ([[gameInfoArray objectAtIndex:0] floatValue] < [[gameInfoArray objectAtIndex:1] floatValue])
            {
                //second player won ... display pop up result for 2.player 
                secondPlayer.matchOutcome = GKTurnBasedMatchOutcomeWon;
                UIAlertView *outcomeEventWin = [[UIAlertView alloc] initWithTitle:nil message:@"YOU WIN :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [outcomeEventWin show];
                
                //get player 2 score on leaderboard
                if([GKLocalPlayer localPlayer].authenticated) {
                    NSArray *arr = [[NSArray alloc] initWithObjects:[GKLocalPlayer localPlayer].playerID, nil];
                    GKLeaderboard *board = [[GKLeaderboard alloc] initWithPlayerIDs:arr];
                    if(board != nil) {
                        board.timeScope = GKLeaderboardTimeScopeAllTime;
                        board.range = NSMakeRange(1, 1);
                        board.category = @"HighscoreTable";
                        [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                            if (error != nil) {
                                // handle the error.
                                NSLog(@"Error retrieving score.");
                            }
                            if (scores != nil) {
                                
                                //get current player 2 leaderboard score
                                int currentPlayer2Score = ((GKScore*)[scores objectAtIndex:0]).value;
                                //increase current leaderboard score by 1
                                currentPlayer2Score = currentPlayer2Score + 1;
                                //send updated score to game center
                                [self.gameCenterManager reportScore: currentPlayer2Score forCategory: kLeaderboardID];
                            }
                            else
                            {
                                [self.gameCenterManager reportScore: 1 forCategory: kLeaderboardID];
                            }
                        }];
                    }
                }
                
                
                //second player lost
                firstPlayer.matchOutcome = GKTurnBasedMatchOutcomeLost;
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
    
}

-(BOOL)checkIfOtherPlayerQuit{
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
        if (nextParticipant.matchOutcome == GKTurnBasedMatchOutcomeQuit)
        {
            [self imageChange:@"xrps-wp7-f4-2.png" :1];
            [self imageChange:@"xrps-wp7-f4-2.png" :2];
            
            
            
            lblStatus.text = @"Match was canceled, due to a player quitting";
            btnRobot.enabled = NO;
            btnPaper.enabled = NO;
            btnScissors.enabled = NO;
            btnUnicorn.enabled = NO;
            btnRock.enabled = NO;
            lblOppScore.hidden = YES;
            lblUserScore.hidden = YES;
            lblVS.hidden = YES;
            lblHowResult.hidden = YES;
            lblYOUResult.hidden = YES;
            
            return true;
        }
        else
        {
            return false;
        }
    }
}




-(void)layoutMatch:(GKTurnBasedMatch *)match {
    
    
    gameInfoArray = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    
    GKTurnBasedParticipant *firstParticipant = 
    [match.participants objectAtIndex:0];
    
    NSLog(@"Viewing match where it's not our turn...");
    NSString *statusString;
    
    if ([self checkIfOtherPlayerQuit] == false)
    {
    if (match.status == GKTurnBasedMatchStatusEnded) {
        
        //if player is looking at ended game, that player is current participant
        if ([[gameInfoArray objectAtIndex:8] isEqualToString: [[GKLocalPlayer localPlayer] playerID]])
        {
            playerMe = 1;
            int oppScore = [[gameInfoArray objectAtIndex:1] floatValue];
            int userScore = [[gameInfoArray objectAtIndex:0] floatValue];
            lblOppScore.text = [NSString stringWithFormat:@"%d",oppScore];
            lblUserScore.text = [NSString stringWithFormat:@"%d",userScore];
            
            lblPlayerName.text = [gameInfoArray objectAtIndex:7];
            
            
        }
        else
        {
            playerMe = 2;
            int oppScore = [[gameInfoArray objectAtIndex:0] floatValue];
            int userScore = [[gameInfoArray objectAtIndex:1] floatValue];
            lblOppScore.text = [NSString stringWithFormat:@"%d",oppScore];
            lblUserScore.text = [NSString stringWithFormat:@"%d",userScore];
    
            lblPlayerName.text = [gameInfoArray objectAtIndex:6];
            
        }
        
        int oppScoreInt;
        int userScoreInt;
        
        oppScoreInt = [lblOppScore.text intValue];
        userScoreInt = [lblUserScore.text intValue];
        
        if (userScoreInt == oppScoreInt)
        {
            UIAlertView *outcomeEventTie = [[UIAlertView alloc] initWithTitle:nil message:@"YOU TIE" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [outcomeEventTie show];   
        }
        else if (userScoreInt < oppScoreInt)
        {
            UIAlertView *outcomeEventLost = [[UIAlertView alloc] initWithTitle:nil message:@"YOU LOST :(" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [outcomeEventLost show];
        }
        else if (userScoreInt > oppScoreInt)
        {
            UIAlertView *outcomeEventWin = [[UIAlertView alloc] initWithTitle:nil message:@"YOU WON :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [outcomeEventWin show];
        }
        
            
        [self imageChange:@"xrps-wp7-f4-2.png" :1];
        [self imageChange:@"xrps-wp7-f4-2.png" :2];
        
        
        statusString = @"Match Ended";
        lblRound.text = @"";
    }
    //match hasnt ended yet
    else
    {
            
        
            //if players looking at game layout and it hasnt ended, it wont be his turn, so 
            if (firstParticipant == match.currentParticipant)
            {
            playerMe = 2;
            int oppScore = [[gameInfoArray objectAtIndex:0] floatValue];
            int userScore = [[gameInfoArray objectAtIndex:1] floatValue];
            lblOppScore.text = [NSString stringWithFormat:@"%d",oppScore];
            lblUserScore.text = [NSString stringWithFormat:@"%d",userScore];
            
            lblPlayerName.text = [gameInfoArray objectAtIndex:6];
            
            //display outcome of previous round
            [self displayChange: 4:1];
            [self displayChange:3:2];
            
            }
            else
            {
                playerMe = 1;
                int oppScore = [[gameInfoArray objectAtIndex:1] floatValue];
                int userScore = [[gameInfoArray objectAtIndex:0] floatValue];
                lblOppScore.text = [NSString stringWithFormat:@"%d",oppScore];
                lblUserScore.text = [NSString stringWithFormat:@"%d",userScore];
            
                
            
                //only display what player1 picked
                [self displayChange:3: 1];
                [self imageChange:@"xrps-wp7-f4-2.png" :2];
            }
            
        
        
            int playerNum = [match.participants 
                         indexOfObject:match.currentParticipant] + 1;
        
            
            statusString = [NSString stringWithFormat:
                        @"Player %d's Turn", playerNum];
            
            
        cArray[2] = [[gameInfoArray objectAtIndex:2] floatValue];
        
            //display round
            int round = cArray[2];
            lblRound.text = [NSString stringWithFormat:@"Round: %d",round];
          
        }
    
            lblStatus.text = statusString;
    }
            btnRobot.enabled = NO;
            btnPaper.enabled = NO;
            btnScissors.enabled = NO;
            btnUnicorn.enabled = NO;
            btnRock.enabled = NO;
            
            cArray[2] = [[gameInfoArray objectAtIndex:2] floatValue];
    
            int round = cArray[2];
            if (round > 1)
            {
                if (playerMe == 1)
                {
                    lblPlayerName.text = [gameInfoArray objectAtIndex:7];
                }
                else
                {
                    lblPlayerName.text = [gameInfoArray objectAtIndex:6];
                }
            }
    
            [self checkForEnding:cArray[2]];
    
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
    
    
    // 0= currentScorePlayer1, 1 = currentScorePlayer2, 2= turn, 3 = player1Pick, 4= player2Pick, 5=turnCount, 6=Player1Alias, 7= Player1ID to be replaced with Player2Alias, 8 = Player1PlayerID, 9 = Player1PlayerID to be reaplced with Player2PlayerID
    
     gameInfoArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble:1],
                                   [NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble: 1], 
                                   [[GKLocalPlayer localPlayer] alias],
                                    [[GKLocalPlayer localPlayer] playerID],
                                    [[GKLocalPlayer localPlayer] playerID],
                                    [[GKLocalPlayer localPlayer] playerID],nil];
    
    btnRobot.enabled = YES;
    btnPaper.enabled = YES;
    btnScissors.enabled = YES;
    btnUnicorn.enabled = YES;
    btnRock.enabled = YES;
    lblOppScore.text = @"000";
    lblUserScore.text = @"000";
    lblStatus.text = @"Please start new game";
    lblRound.text = @"Round:1";
    lblHowResult.hidden = YES;
    lblYOUResult.hidden = YES;
    playerMe = 1;
    lblPlayerName.text = @"Other Player";
    [self imageChange:@"xrps-wp7-f4-2.png" :1];
    [self imageChange:@"xrps-wp7-f4-2.png" :2];
    
    
}



-(void)takeTurn:(GKTurnBasedMatch *)match {
    
    
    
    gameInfoArray = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    
    
    //if ([self checkIfOtherPlayerQuit] == false)
    //{
    
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
        
        
            lblPlayerName.text = [gameInfoArray objectAtIndex:7];
        
            //display what user picked for round before
            [self displayChange:3 :1];
            //display what opp picked for round before
            [self displayChange:4:2];
        
            [self resultsDisplay:[[gameInfoArray objectAtIndex:3] floatValue] : [[gameInfoArray objectAtIndex:4] floatValue]];
        
        }
        else
        {
            playerMe = 2;
        
            lblPlayerName.text = [gameInfoArray objectAtIndex:6];
        
            int oppScore = [[gameInfoArray objectAtIndex:0] floatValue];
            int userScore = [[gameInfoArray objectAtIndex:1] floatValue];
            lblOppScore.text = [NSString stringWithFormat:@"%d",oppScore];
            lblUserScore.text = [NSString stringWithFormat:@"%d",userScore]; 
        
            [self imageChange:@"xrps-wp7-f4-2.png" :1];
            [self imageChange:@"xrps-wp7-f4-2.png" :2];
        
            lblYOUResult.hidden = YES;
            lblHowResult.hidden = YES;
        }
        
    
        // round
        cArray[2] = [[gameInfoArray objectAtIndex:2] floatValue];
    
        //display round
        int round = cArray[2];
        
        NSLog(@"%d",round);
        lblRound.text = [NSString stringWithFormat:@"Round: %d",round];
    
        if (round > 1)
        {
            btnAdvice.enabled = YES;
        }
        else
        {
            [gameInfoArray replaceObjectAtIndex:7 withObject:[[GKLocalPlayer localPlayer] alias]];
            [gameInfoArray replaceObjectAtIndex:9 withObject:[[GKLocalPlayer localPlayer] playerID]];
        }
    //}
    
}



@end
