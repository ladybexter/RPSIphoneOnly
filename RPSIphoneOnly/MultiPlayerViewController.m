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
#import "Reachability.h"
#import "SystemConfiguration/SystemConfiguration.h"
#import "AiFunction.h"


@implementation MultiPlayerViewController


@synthesize lblLBScore;
@synthesize btnPostScore;
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
int linaChoice;
int joannaChoice;



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
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.1];
    //alertView.transform = CGAffineTransformRotate(alertView.transform, 3.14159/2);
    [UIView commitAnimations];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIAlertView *eventInstruct = [[UIAlertView alloc] initWithTitle:nil message:@"Please press Game Center to either \n\n START NEW game \n or \n CONTINUE game" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

    [eventInstruct show];
    
    [GCHelper sharedInstance].delegate = self;
    [[GCHelper sharedInstance] authenticateLocalUser];    
    
    btnRobot.enabled = NO;
    btnPaper.enabled = NO;
    btnScissors.enabled = NO;
    btnUnicorn.enabled = NO;
    btnRock.enabled = NO;
    
    lblStatus.text = @"Please press Game Center to get started";
    lblRound.text = @"";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XRPS-Interface-background-main" ofType:@"png" inDirectory:@""];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:path]]];
    
   
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
    [self setLblLBScore:nil];
    [self setBtnPostScore:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

-(NSMutableDictionary*)initialPlayerDataSetup
{
    NSMutableDictionary *playerData;
    playerData = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *conditionalArrayNS = [NSMutableArray arrayWithCapacity:25]; 
    
    for (int x=0; x<25;x++)
    {
        [conditionalArrayNS addObject:[NSNumber numberWithInt:1]];
    }
     
    NSMutableArray *actionArrayNS = [NSMutableArray arrayWithCapacity:5]; 
    
    for (int x=0; x<5;x++)
    {
        [actionArrayNS addObject:[NSNumber numberWithDouble:0.2]];
        //[actionArrayNS addObject:[NSString stringWithFormat:@"%d", 0.2]];       
    }
    
    NSLog(@"actionArray: %@", actionArrayNS);
    
    [playerData setObject:conditionalArrayNS forKey:@"conditionalArray"];
    [playerData setObject:actionArrayNS forKey:@"actionArray"];
    [playerData setObject:[NSNumber numberWithInt:0] forKey:@"lastNumber"];
    [playerData setObject:[NSNumber numberWithInt:0] forKey:@"numberOfGamesPlayed"];
    
    NSLog(@"initial data:%@",playerData);
    return playerData;
    
    
}


-(NSMutableDictionary*)loadPlayersChoiceData:(NSString *)Playername{
    
    
    
    //look at this code which creates path to plist in documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"PlayersChoices.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableDictionary *playerDictionary;
    
    //next read data:
    if ([fileManager fileExistsAtPath: path]) 
    {
        // If the file exists, read dictionary from file
        playerDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        
        
        //check dictionary to see if previous player data has been saved on current device
        NSMutableDictionary *playersData;
        
        if([playerDictionary objectForKey:Playername] != nil)
        {
            //load from playerDictionary previously stored player data on current device
            
            playersData = [playerDictionary objectForKey:Playername];
        }
        else
        {
            //player hasnt stored any data on current device yet
            
            playersData = [self initialPlayerDataSetup];
        }
        
        
        return playersData;
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        playerDictionary = [[NSMutableDictionary alloc] init];
        
        //no previous games have been played on this device
        return [self initialPlayerDataSetup];
        
    }
    
}

-(void)convertNSMutableArrayToArray:(NSMutableArray *)nsArray:(double[])nsConvertedArray
{
    for (int x=0; x<[nsArray count];x++)
    {
        nsConvertedArray[x] = [[nsArray objectAtIndex:x]doubleValue];       
    }
}

-(void)convertArrayToNSMutableArray:(NSMutableArray *)nsArray:(double[])originalArray:(bool)isDouble
{
    for (int x=0; x<[nsArray count];x++)
    {
        if (isDouble == TRUE)
        {
            [nsArray replaceObjectAtIndex:x withObject:[NSNumber numberWithDouble: originalArray[x]]];
        }
        else
        {
            [nsArray replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:(int)originalArray[x]]];
        }
    }
}


-(void)savePlayerDataLocally:(NSDictionary*)playerData : (NSString *)PlayersID{
    
    //look at this code which creates path to plist in documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"PlayersChoices.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path]) 
    {
        // If the file exists, read dictionary from file
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        
        
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
    NSLog(@"%@ saving data:%@",PlayersID, playerData);
    
    
    //And write data:
    
    
    [data setObject:playerData forKey:PlayersID];
    
    [data writeToFile: path atomically:YES];
    
    
    if ([data writeToFile: path atomically:YES]) {
         NSLog(@"new plist created");
    } else {
        
        NSLog(@"couldn't write to new plist");
    }
    
}


-(void)updateLocalPlayerData:(NSString *)Playername:(int)numberBeforeLastG: (int)lastNumberG:(NSMutableDictionary *)data
{
    int numberOfGamesPlayed;
    
     //initialize normal arrays for update later (dummy arrays)
    double conditionalArray[25] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
    double actionArray[5] = { 0.2, 0.2, 0.2, 0.2, 0.2 };
    
    NSMutableArray *conditionalArrayNS1 = [NSMutableArray arrayWithCapacity:25]; 
    conditionalArrayNS1 = [data objectForKey:@"conditionalArray"];
    NSMutableArray *actionArrayNS1 = [NSMutableArray arrayWithCapacity:5]; 
    actionArrayNS1 = [data objectForKey:@"actionArray"];
    numberOfGamesPlayed = [[data objectForKey:@"numberOfGamesPlayed"]intValue];
    
    
    
    if (lastNumberG == 0) 
    {
        //only update games count
        numberOfGamesPlayed = ((int) numberOfGamesPlayed + 1);
    }
    else if (lastNumberG != 0 && numberBeforeLastG == 0)
    {
        //only update actionArray
        
        //update dummy arrays with loaded player data
        [self convertNSMutableArrayToArray:actionArrayNS1:actionArray]; 
        actionLookUp(lastNumberG, actionArray);
        [self convertArrayToNSMutableArray:actionArrayNS1:actionArray:TRUE];
        
    }
    else
    {
        //update dummy arrays with loaded player data
        [self convertNSMutableArrayToArray:conditionalArrayNS1:conditionalArray];
        [self convertNSMutableArrayToArray:actionArrayNS1:actionArray]; 
    
        //updating player data using normal arrays and previously loaded data   
        updatingConditionalArray(numberBeforeLastG, lastNumberG, conditionalArray);
    
        actionLookUp(lastNumberG, actionArray);
    
        numberOfGamesPlayed = ((int) numberOfGamesPlayed + 1);
    
        //convert array back to NSArray
        [self convertArrayToNSMutableArray:conditionalArrayNS1:conditionalArray:FALSE];
        [self convertArrayToNSMutableArray:actionArrayNS1:actionArray:TRUE]; 
    }
    
    
    NSMutableDictionary *updatedPlayerData;
    updatedPlayerData = [[NSMutableDictionary alloc] init];
    
    [updatedPlayerData setObject:conditionalArrayNS1 forKey:@"conditionalArray"];
    [updatedPlayerData setObject:actionArrayNS1 forKey:@"actionArray"];
    [updatedPlayerData setObject:[NSNumber numberWithInt:lastNumberG] forKey:@"lastNumber"];
    [updatedPlayerData setObject:[NSNumber numberWithInt:numberOfGamesPlayed] forKey:@"numberOfGamesPlayed"];
    
    [self savePlayerDataLocally:updatedPlayerData :Playername];
    
    
}



-(void)predictNextNumber:(int)lastNumberG :(NSMutableDictionary *)loadedPlayerData
{
    int numberOfGamesPlayed;
    
    //initialize normal arrays for update later (dummy arrays)
    double conditionalArray[25] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
    double actionArray[5] = { 0.2, 0.2, 0.2, 0.2, 0.2 };
    double results[2] ={ 1, 1};
    
    
    NSMutableArray *conditionalArrayNS1 = [NSMutableArray arrayWithCapacity:25]; 
    conditionalArrayNS1 = [loadedPlayerData objectForKey:@"conditionalArray"];
    NSMutableArray *actionArrayNS1 = [NSMutableArray arrayWithCapacity:5]; 
    actionArrayNS1 = [loadedPlayerData objectForKey:@"actionArray"];
    numberOfGamesPlayed = [[loadedPlayerData objectForKey:@"numberOfGamesPlayed"]intValue];
    
   
    //update dummy arrays with loaded player data
    [self convertNSMutableArrayToArray:conditionalArrayNS1:conditionalArray];
    [self convertNSMutableArrayToArray:actionArrayNS1:actionArray]; 
     
    
    //if no games have been played then no data will be available for the computer to make an estimate from
    // for the first game the computer will make a random estimation
    // for the rest of the time the computer will take users past choices to prect the next action
    if (lastNumberG == 0)
    {
        int r = (arc4random()%5) + 1;
        linaChoice = r;
        joannaChoice = r;
        
    }
    else
    {
        nextNumberPrediction(lastNumberG, conditionalArray, actionArray,results);
        
        
        linaChoice = (int)results[0];
        
        joannaChoice = (int)results[1];  
    }
    
    
    
    
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
    
    lblVS.text = @"VS";
    
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make an internet connection at this time. You will need internet connection to play multiplayer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self didPresentAlertView:alert];

        
		return NO;
	}
	else {
		return YES;
	}
}

-(void)sendTurnToSelf: (NSData*) data{
    
    GKTurnBasedMatch *currentMatch = 
    [[GCHelper sharedInstance] currentMatch];
    
    [currentMatch endTurnWithNextParticipant:currentMatch.currentParticipant
                                   matchData:data completionHandler:^(NSError *error) {
                                       if (error) {
                                           NSLog(@"%@", error);
                                           lblStatus.text = 
                                           @"Oops, there was a problem.  Try that again.";
                                       } else {
                                           lblStatus.text = @"Please Update your Leaderboard score";
                                           btnRobot.enabled = NO;
                                           btnPaper.enabled = NO;
                                           btnScissors.enabled = NO;
                                           btnUnicorn.enabled = NO;
                                           btnRock.enabled = NO;
                                       }
                                   }];
    
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
    GKTurnBasedMatch *currentMatch = 
    [[GCHelper sharedInstance] currentMatch];
    
    
    GKTurnBasedParticipant *firstPlayer;
    firstPlayer = 
    [currentMatch.participants objectAtIndex:0];
    GKTurnBasedParticipant *secondPlayer;
    secondPlayer = [currentMatch.participants objectAtIndex:1];
    
    
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = score;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // handle the reporting error
            
            btnPostScore.hidden = NO;
            lblHowResult.text = @"Opps, another error occured.Please try again to post";
            
        }
        else
        {
            
            //end of 5 rounds,player 2 must have won
            if ([[gameInfoArray objectAtIndex:5] floatValue] == 11) {
                
                //second player won ... display pop up result for 2.player 
                secondPlayer.matchOutcome = GKTurnBasedMatchOutcomeWon;
                
                //second player lost
                firstPlayer.matchOutcome = GKTurnBasedMatchOutcomeLost;
                
                
            }
            else
            {
            
                //player 1 must have won
                
                //second player lost
                secondPlayer.matchOutcome = GKTurnBasedMatchOutcomeLost;
                
                //first player won
                firstPlayer.matchOutcome = GKTurnBasedMatchOutcomeWon;
                
                
            }
            
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameInfoArray];
            
            //score update was successful so end game
             
            [currentMatch endMatchInTurnWithMatchData:data 
                                    completionHandler:^(NSError *error) {
                                        if (error) {
                                            NSLog(@"%@", error);
                                        }
                                    }];
            lblYOUResult.text = @"";
            lblHowResult.textColor = [UIColor orangeColor];
            lblHowResult.text = @"";
            lblStatus.text = @"Leaderboard Post was successful";
            btnPostScore.hidden = YES;
        }
    }];
}


-(int)loadLocalSavedScore:(NSString *)Playername{
    
    //look at this code which creates path to plist in documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"LBScore.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableDictionary *scoreDictionary;
    
    //next read data:
    if ([fileManager fileExistsAtPath: path]) 
    {
        // If the file exists, read dictionary from file
        scoreDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        
        
        //check dictionary to see if player has saved previous score on current device
        int score;
        
        if([scoreDictionary objectForKey:Playername] != nil)
        {
            //load from scoreDictionary previously stored LB score for player on current device
        
            score = [[scoreDictionary objectForKey:Playername] intValue];
        }
        else
        {
            //player hasnt stored any leaderboard score on current device yet
            score = 0;
        }
        
    
        return score;
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        scoreDictionary = [[NSMutableDictionary alloc] init];
        
        //no previous games have been won on this device for any player
        return 0;
    }
   
}


-(void)saveScoreLocally:(int)scoreToSave : (NSString *)PlayersID{
    
    //look at this code which creates path to plist in documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"LBScore.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableDictionary *data;
    
    if ([fileManager fileExistsAtPath: path]) 
    {
        // If the file exists, read dictionary from file
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
    //And write data:
    
    //here add elements to data file and write data to file
    int value = scoreToSave;
    
    [data setObject:[NSNumber numberWithInt:value] forKey:PlayersID];
    
    [data writeToFile: path atomically:YES];
    
}


-(void)compareUpdateLBScoreWithLocallyStoredScore:(NSString *)PlayersID: (int) localScore: (int) leaderboardScore{
    
    int newScore;
    int addedScore;
    
    if (playerMe == 1)
    {
        addedScore = [[gameInfoArray objectAtIndex:0] intValue];
    }
    else
    {
        addedScore = [[gameInfoArray objectAtIndex:1] intValue];
    }
    
    
    //if leaderboardscore is -1 then there was an error retreiving current leaderboard score
    
    if (leaderboardScore != -1)
    {
    
            //no data stored yet
        if (leaderboardScore == 0 & localScore == 0)
        {
            //create local score storage and set it to 1
            [self saveScoreLocally:addedScore :PlayersID];
        
            //post localScore as leaderboardScore
            [self reportScore:addedScore forCategory: kLeaderboardID];  
        }
        else if(leaderboardScore == 0)
        {
            //leaderboard hasnt been updated yet. take local score increase by one and post it
            newScore = localScore + addedScore;
            [self reportScore:newScore forCategory:kLeaderboardID];
        
            //submit update for local score
            [self saveScoreLocally:newScore :PlayersID];
        }
        else if(localScore == 0)
        {
            //create local score with current leaderboardNumber
            newScore = leaderboardScore + addedScore;
            [self saveScoreLocally:newScore :PlayersID];
        
            //submit new leaderboard score
            [self reportScore:newScore forCategory:kLeaderboardID];
        }
        else if(localScore == leaderboardScore)
        {
            newScore = localScore + addedScore;
        
            [self reportScore:newScore forCategory:kLeaderboardID];
            [self saveScoreLocally:newScore :PlayersID];
        }
        else if(localScore > leaderboardScore)
        {
            //leaderboardscore hasnt updated yet
            newScore = localScore + addedScore;
        
            [self reportScore:newScore forCategory:kLeaderboardID];
            [self saveScoreLocally:newScore :PlayersID];
        }
        else if(leaderboardScore > localScore)
        {
            //devices were switched so leaderboard score will b more up to date
            newScore = leaderboardScore + addedScore;
        
            [self reportScore:newScore forCategory:kLeaderboardID];
            [self saveScoreLocally:newScore :PlayersID];
        }
    }
    else
    {
        //there was an error retreiving leaderboardscore
        lblYOUResult.text = @"";
        lblHowResult.textColor = [UIColor orangeColor];
        lblHowResult.text = @"Sorry, there was an error trying to update your score, please try again!";
        
        btnPostScore.hidden = NO;
        
    }
                                           
}

-(int)getCurrentLeaderboardScoreAndCompareWithLocal:(NSString *)Category:(NSString *)PlayerID 
{
    
    //NSLog(@"find score for category %@ ", Category);
    if([GKLocalPlayer localPlayer].authenticated) {
        NSArray *arr = [[NSArray alloc] initWithObjects:[GKLocalPlayer localPlayer].playerID, nil];
        GKLeaderboard *board = [[GKLeaderboard alloc] initWithPlayerIDs:arr];
        if(board != nil) {
            board.timeScope = GKLeaderboardTimeScopeAllTime;
            board.range = NSMakeRange(1, 1);
            board.category = Category;
            [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                int lbScore;
                int localScore;
                if (error != nil) {
                    // handle the error.
                    NSLog(@"Error retrieving score.");
                    lbScore = -1;
                    NSLog(@"Current Leaderboard Score: %d",lbScore);
                    localScore = [self loadLocalSavedScore:PlayerID];
                    NSLog(@"Current Local Score: %d",localScore);
                    [self compareUpdateLBScoreWithLocallyStoredScore:PlayerID:localScore:lbScore];
                }
                if (scores != nil) {
                    //leaderboard score
                    lbScore = board.localPlayerScore.value;
                    NSLog(@"Current Leaderboard Score: %d",lbScore);
                    localScore = [self loadLocalSavedScore:PlayerID];
                    NSLog(@"Current Local Score: %d",localScore);
                    [self compareUpdateLBScoreWithLocallyStoredScore:PlayerID:localScore:lbScore];
                }
                else
                {
                    
                    lbScore = 0;
                    NSLog(@"Current Leaderboard Score: %d",lbScore);
                    localScore = [self loadLocalSavedScore:PlayerID];
                    NSLog(@"Current Local Score: %d",localScore);
                    [self compareUpdateLBScoreWithLocallyStoredScore:PlayerID:localScore:lbScore];
                }
                
            }];
        }
        
    }
}

-(void)sendTurn{
    
    if ([self checkInternet] == YES)
    {
    
    
    //increase turnCount by 1
    cArray[5] = [[gameInfoArray objectAtIndex:5] floatValue] + 1;
    [gameInfoArray replaceObjectAtIndex:5 withObject:[NSNumber numberWithDouble:cArray[5]]];
    
    if (playerMe == 1)
    {
        //reset image for next round
        [gameInfoArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithDouble:0]];
        
        lblHowResult.text = @"";
        lblYOUResult.text = @"";
        
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
        
        cArray[2] = [[gameInfoArray objectAtIndex:2] floatValue] + 1;
    [gameInfoArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithDouble:cArray[2]]];
        
        
        [self resultsDisplay:[[gameInfoArray objectAtIndex:4] floatValue] : [[gameInfoArray objectAtIndex:3] floatValue]];
        
    }
    
    
    
    
    
    
    //end of 5 rounds
    if ([[gameInfoArray objectAtIndex:5] floatValue] == 11) {
            
        btnRobot.enabled = NO;
        btnPaper.enabled = NO;
        btnScissors.enabled = NO;
        btnUnicorn.enabled = NO;
        btnRock.enabled = NO;
        btnAdvice.enabled = NO;
        
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
                [self didPresentAlertView:outcomeEventTie];

                
                //setting matchoutcome for firstplayer to tied
                firstPlayer.matchOutcome = GKTurnBasedMatchOutcomeTied;
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameInfoArray]; 
                
                [currentMatch endMatchInTurnWithMatchData:data 
                                        completionHandler:^(NSError *error) {
                                            if (error) {
                                                NSLog(@"%@", error);
                                            }
                                        }];
                lblStatus.text = @"Game has ended";
               
            }
            else if ([[gameInfoArray objectAtIndex:0] floatValue] > [[gameInfoArray objectAtIndex:1] floatValue])
            {
               
                UIAlertView *outcomeEventLost = [[UIAlertView alloc] initWithTitle:nil message:@"YOU LOST :(" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [outcomeEventLost show];
                [self didPresentAlertView:outcomeEventLost];

                
                //increase turncount to 12
                [gameInfoArray replaceObjectAtIndex:5 withObject:[NSNumber numberWithDouble:12]];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameInfoArray]; 
                
                
                
                //send turn to player 1 so that player can update his score via post score button
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
                                                       btnAdvice.enabled = NO;
                                                   }
                                               }];
                
                 
            }
            else if ([[gameInfoArray objectAtIndex:0] floatValue] < [[gameInfoArray objectAtIndex:1] floatValue])
            {
                
                
                UIAlertView *outcomeEventWin = [[UIAlertView alloc] initWithTitle:nil message:@"YOU WIN :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [outcomeEventWin show];
                [self didPresentAlertView:outcomeEventWin];

                
                //check LB and L score for player 2, try posting to leaderboard
                [self getCurrentLeaderboardScoreAndCompareWithLocal:kLeaderboardID:secondPlayer.playerID];
                
            }  
          
        
        
    } else {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameInfoArray]; 
        
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
                                               btnAdvice.enabled = NO;
                                           }
                                       }];
        
        
    }
    }
    
    
}

-(void)setRightNumbers:(int)currentNumber{
    if(playerMe == 1)
    {
        //set player choice
        [gameInfoArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:currentNumber]];
        
        //set numberBeforeLast to last number
        [gameInfoArray replaceObjectAtIndex:10 withObject:[gameInfoArray objectAtIndex:11]];
        
        //set last number to currentNumber
        [gameInfoArray replaceObjectAtIndex:11 withObject:[gameInfoArray objectAtIndex:12]];
        
        //set current number
        [gameInfoArray replaceObjectAtIndex:12 withObject:[NSNumber numberWithInt:currentNumber]];
        
        
    }
    if(playerMe == 2)
    {
        //set player choice[
        [gameInfoArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:currentNumber]];
        
        //set numberBeforelast to last number
        [gameInfoArray replaceObjectAtIndex:13 withObject:[gameInfoArray objectAtIndex:14]];
        
        //set current number to last number for new round
        [gameInfoArray replaceObjectAtIndex:14 withObject:[NSNumber numberWithInt:currentNumber]];
    }
}

- (IBAction)btnPostScore:(id)sender {
    
    if ([self checkInternet] == YES)
    {
    
    GKTurnBasedMatch *currentMatch = 
    [[GCHelper sharedInstance] currentMatch];
    
    GKTurnBasedParticipant *firstPlayer;
    firstPlayer = 
    [currentMatch.participants objectAtIndex:0];
    GKTurnBasedParticipant *secondPlayer;
    secondPlayer = [currentMatch.participants objectAtIndex:1];
    
    if (firstPlayer == currentMatch.currentParticipant)
    {
        [self getCurrentLeaderboardScoreAndCompareWithLocal:kLeaderboardID:firstPlayer.playerID];
    }
    else
    {
        [self getCurrentLeaderboardScoreAndCompareWithLocal:kLeaderboardID:secondPlayer.playerID];
    }
    }
}



- (IBAction)btnPaper:(id)sender {
    
    [self setRightNumbers:2];
    
    [self sendTurn];
        
}

- (IBAction)btnScissors:(id)sender {
    
    [self setRightNumbers:3];
    
    [self sendTurn];
    
}

- (IBAction)btnUnicorn:(id)sender {
    
    [self setRightNumbers:4];
    
    [self sendTurn];
}

- (IBAction)btnRobot:(id)sender {
    
    [self setRightNumbers:5];
    
    [self sendTurn];
}

- (IBAction)btnRock:(id)sender {
    
    [self setRightNumbers:1];
    
    [self sendTurn];
}


- (IBAction)btnAIAdvice:(id)sender {
    
    int numberBeforeLastMatch;
    int lastNumberMatch;
    
    int lastNumberLoadP;
    int numberOfGamesPlayedP;
    
    int lastNumberLoadG;
    int numberOfGamesPlayedG;
    
    //get loaded data
    NSMutableDictionary *playerData;
    NSMutableDictionary *generalPlayerData;
    
    generalPlayerData = [self loadPlayersChoiceData:@"generalPlayer"];
    
    NSLog(@"saved GENERAL data:%@",generalPlayerData);
    
    lastNumberLoadG = [[generalPlayerData objectForKey:@"lastNumber"]intValue];
    numberOfGamesPlayedG = [[generalPlayerData objectForKey:@"numberOfGamesPlayed"]intValue];
    
    numberBeforeLastMatch = [[gameInfoArray objectAtIndex:13]intValue];
    lastNumberMatch = [[gameInfoArray objectAtIndex:14]intValue];
    
    if (playerMe == 1)
    {
        //player data is up to date
        playerData = [self loadPlayersChoiceData:[gameInfoArray objectAtIndex:9]];
        
        NSLog(@"%@ saved data:%@",[gameInfoArray objectAtIndex:9], playerData);
        
        lastNumberLoadP = [[playerData objectForKey:@"lastNumber"]intValue];
        numberOfGamesPlayedP = [[playerData objectForKey:@"numberOfGamesPlayed"]intValue];
        
        
        //predicting next number lina and joanna
        
        //prediction of number only can happen in second round for playerA -> lastnumberMatch always exists
        
        
                if (numberOfGamesPlayedP == 0)
                {
                    //first ever game with playerB
                    
                    //check if generalPlayerData exists
                    
                    if (numberOfGamesPlayedG == 0)
                    {
                        //no general player data exists
                        [self predictNextNumber:lastNumberMatch:playerData];
                    }
                    else 
                    {
                        //general data exists
                        [self predictNextNumber:lastNumberMatch:generalPlayerData];
                    }
                    
                }
                else if (numberOfGamesPlayedP <= 10)
                {
                    //playerData exists but is in early stages ... check if generalData is further along
                    
                    if (numberOfGamesPlayedG > 10)
                    {
                        //general player data is further along than playerData
                        [self predictNextNumber:lastNumberMatch:generalPlayerData];
                    }
                    else
                    {
                        // playerData is similar up to date as generalData
                        [self predictNextNumber:lastNumberMatch:playerData];
                    }
                }
                else
                {
                    [self predictNextNumber:lastNumberMatch:playerData];
                }
            
        
        
    }
    else
    {
        //player data is up to date
        playerData = [self loadPlayersChoiceData:[gameInfoArray objectAtIndex:8]];
        
        NSLog(@"%@ saved data:%@",[gameInfoArray objectAtIndex:8], playerData);
    
        lastNumberLoadP = [[playerData objectForKey:@"lastNumber"]intValue];
        numberOfGamesPlayedP = [[playerData objectForKey:@"numberOfGamesPlayed"]intValue];
        
        
        //predicting next number lina and joanna
        
        //Player2
        
        if (lastNumberMatch == 0)
        {
            // first round of match => no lastnumber exists for prediction
            
            if (lastNumberLoadP == 0)
            {
                //first ever round with playerA
                
                if (lastNumberLoadG == 0)
                {
                    //first ever round EVER => random prediction
                    [self predictNextNumber:lastNumberMatch:playerData];
                }
                else
                {
                    //use lastNumberLoadG for prediction
                    [self predictNextNumber:lastNumberLoadG:generalPlayerData];
                }
            }
            else
            {
                //use lastNumberLoadP for prediction
                
                if (numberOfGamesPlayedP <= 10)
                {
                    //playerData exists but not far along
                    
                    if (numberOfGamesPlayedG <= 10)
                    {
                        //generalData is just up to date as playerData
                        [self predictNextNumber:lastNumberLoadP:playerData];
                    }
                    else
                    {
                        //generalData has more data than playerData
                        [self predictNextNumber:lastNumberLoadP:generalPlayerData];
                    }
                }
                else
                {
                    [self predictNextNumber:lastNumberLoadP:playerData];

                }
                
            }
            
            
        }
        else
        {
            // 2nd, 3rd, 4th, or 5th round of match => lastnumber exists for predicition
            
            if (numberOfGamesPlayedP == 0)
            {
                //no previous playerA data exists
                
                if (numberOfGamesPlayedG == 0)
                {
                    //no general player data exists
                     [self predictNextNumber:lastNumberMatch:playerData];
                }
                else
                {
                    //general player data exists
                     [self predictNextNumber:lastNumberMatch:generalPlayerData];
                }
            }
            else if (numberOfGamesPlayedP <= 10)
            {
                //playerData exists but is in early stages ... check if generalData is further along
                
                if (numberOfGamesPlayedG > 10)
                {
                    //general player data is further along than playerData
                    [self predictNextNumber:lastNumberMatch:generalPlayerData];
                }
                else
                {
                    // playerData is similar up to date as generalData
                    [self predictNextNumber:lastNumberMatch:playerData];
                }
            }
            else
            {
                [self predictNextNumber:lastNumberMatch:playerData];
            }
            

        }
        
    }
    NSString *lina;
    NSString *joanna;
    
    if (linaChoice ==1)
    {
        lina = @"Rock";
    }
    else if (linaChoice == 2)
    {
        lina = @"Paper";
    }
    else if(linaChoice == 3)
    {
        lina = @"Scissors";
    }
    else if(linaChoice == 4)
    {
        lina = @"Unicorn";
    }
    else
    {
        lina = @"Robot";
    }
    
    if (joannaChoice ==1)
    {
        joanna = @"Rock";
    }
    else if (joannaChoice == 2)
    {
        joanna = @"Paper";
    }
    else if(joannaChoice == 3)
    {
        joanna = @"Scissors";
    }
    else if(joannaChoice == 4)
    {
        joanna = @"Unicorn";
    }
    else
    {
        joanna = @"Robot";
    }
    
        
    UIAlertView *eventChoiceNow = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Lina: I suggest %@ \n\n Joanna: I suggest %@",lina, joanna] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [eventChoiceNow show];
    [self didPresentAlertView:eventChoiceNow];

}

- (IBAction)presentGCTurnViewController:(id)sender {
    
    if ([self checkInternet] == YES)
    {
        [[GCHelper sharedInstance] 
         findMatchWithMinPlayers:2 maxPlayers:2 viewController:self];
    }
    
}

-(BOOL)checkIfOtherPlayerQuit:(int)TakeTurn{
    
    //TEMPORARY DELETING PLISTS
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    //NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    //NSString *path = [documentsDirectory stringByAppendingPathComponent:@"LBScore.plist"];
    
    //NSFileManager * fileManager = [NSFileManager defaultManager];
    
    //if ([fileManager isDeletableFileAtPath:path])
    //{
      //NSLog(@"deletable plist");
    //}
    
    //if([fileManager fileExistsAtPath:path]) {
     //if ([fileManager removeItemAtPath:path error:nil])
    //{
      //NSLog(@"file removed");
    //}
    //}
    
    GKTurnBasedMatch *currentMatch = 
    [[GCHelper sharedInstance] currentMatch];
    
    GKTurnBasedParticipant *firstParticipant = 
    [currentMatch.participants objectAtIndex:0];
    
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
            
            if (TakeTurn == 1)
            {
                if (firstParticipant == currentMatch.currentParticipant)
                {
                    if ([[gameInfoArray objectAtIndex:5] floatValue] > 2)
                    {
                        lblPlayerName.text = [gameInfoArray objectAtIndex:7];
                    }
                    else
                    {
                        lblPlayerName.text = @"Other Player";
                    }
                }
                else
                {
                    lblPlayerName.text = [gameInfoArray objectAtIndex:6];
                }
            }
            else
            {
                if ([[gameInfoArray objectAtIndex:8] isEqualToString: [[GKLocalPlayer localPlayer] playerID]])
                {
                    if ([[gameInfoArray objectAtIndex:5] floatValue] > 2)
                    {
                        lblPlayerName.text = [gameInfoArray objectAtIndex:7];
                    }
                    else
                    {
                        lblPlayerName.text = @"Other Player";
                    }
                }
                else
                {
                    lblPlayerName.text = [gameInfoArray objectAtIndex:6];

                }
            }
            
            lblStatus.text = @"Match was canceled, due to a player quitting";
            btnRobot.enabled = NO;
            btnPaper.enabled = NO;
            btnScissors.enabled = NO;
            btnUnicorn.enabled = NO;
            btnRock.enabled = NO;
            btnAdvice.enabled = NO;
            lblOppScore.text = @"";
            lblUserScore.text = @"";
            lblVS.text = @"";
            lblHowResult.text = @"";
            lblYOUResult.text = @"";
            
            currentMatch.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeQuit;
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameInfoArray]; 
            
            [currentMatch endMatchInTurnWithMatchData:data 
                                    completionHandler:^(NSError *error) {
                                        if (error) {
                                            NSLog(@"%@", error);
                                        }
                                    }];
            
            return true;
        }
        else
        {
            lblVS.text = @"VS";
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
    
    if ([self checkIfOtherPlayerQuit:0] == false)
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
            lblHowResult.textColor = [UIColor orangeColor];
            lblHowResult.text = @"You Tied";
        }
        else if (userScoreInt < oppScoreInt)
        {
            lblHowResult.textColor = [UIColor orangeColor];
            lblHowResult.text = @"You Lost";
        }
        else if (userScoreInt > oppScoreInt)
        {
            lblHowResult.textColor = [UIColor orangeColor];
            lblHowResult.text = @"You Won";
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
                
                if ([[gameInfoArray objectAtIndex:5] floatValue] == 12)
                {
                    [self imageChange:@"xrps-wp7-f4-2.png" :1];
                    [self imageChange:@"xrps-wp7-f4-2.png" :2];
                    
                    lblRound.text = @"";
                    
                    statusString = @"Match Ended";
                }
                else
                {
                    //display outcome of previous round
                    [self displayChange: 4:1];
                    [self displayChange:3:2];
                    
                    cArray[2] = [[gameInfoArray objectAtIndex:2] floatValue];
                    
                    //display round
                    int round = cArray[2];
                    lblRound.text = [NSString stringWithFormat:@"Round: %d",round];
                    
                    int playerNum = [match.participants 
                                     indexOfObject:match.currentParticipant] + 1;
                    
                    
                    statusString = [NSString stringWithFormat:
                                    @"Player %d's Turn", playerNum];
                }
            
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
                
                cArray[2] = [[gameInfoArray objectAtIndex:2] floatValue];
                
                //display round
                int round = cArray[2];
                lblRound.text = [NSString stringWithFormat:@"Round: %d",round];
                
                int playerNum = [match.participants 
                                 indexOfObject:match.currentParticipant] + 1;
                
                
                statusString = [NSString stringWithFormat:
                                @"Player %d's Turn", playerNum];
            }
            
          
        }
    
            lblStatus.text = statusString;
    
            btnRobot.enabled = NO;
            btnPaper.enabled = NO;
            btnScissors.enabled = NO;
            btnUnicorn.enabled = NO;
            btnRock.enabled = NO;
            btnAdvice.enabled = NO;
            
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
    }
    
}

-(void)sendNotice:(NSString *)notice forMatch:
(GKTurnBasedMatch *)match {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:
                       @"Another game needs your attention!" message:notice 
                                                delegate:self cancelButtonTitle:@"Sweet!" 
                                       otherButtonTitles:nil];
    [av show];
    [self didPresentAlertView:av];

}



-(void)recieveEndGame:(GKTurnBasedMatch *)match {
    [self layoutMatch:match];
}

#pragma mark - GCTurnBasedMatchHelperDelegate

-(void)enterNewGame:(GKTurnBasedMatch *)match {
    NSLog(@"Entering new game...");
    
    
    // 0= currentScorePlayer1, 1 = currentScorePlayer2, 2= turn, 3 = player1Pick, 4= player2Pick, 5=turnCount, 6=Player1Alias, 7= Player1ID to be replaced with Player2Alias, 8 = Player1PlayerID, 9 = Player1PlayerID to be reaplced with Player2PlayerID, 10 = numberBeforeLast pl1, 11 = lastNumber pl, 12 = currentNumber pl1, 13 = numberBeforeLast pl2, 14 = lastNumber pl2, 
    
     gameInfoArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble:1],
                                   [NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble:0],
                                   [NSNumber numberWithDouble: 1], 
                                   [[GKLocalPlayer localPlayer] alias],
                                    [[GKLocalPlayer localPlayer] playerID],
                                    [[GKLocalPlayer localPlayer] playerID],
                                    [[GKLocalPlayer localPlayer] playerID],
                                    [NSNumber numberWithDouble:0],
                                    [NSNumber numberWithDouble:0],
                                    [NSNumber numberWithDouble:0],
                                    [NSNumber numberWithDouble:0],
                                    [NSNumber numberWithDouble:0],nil];
    
    btnRobot.enabled = YES;
    btnPaper.enabled = YES;
    btnScissors.enabled = YES;
    btnUnicorn.enabled = YES;
    btnRock.enabled = YES;
    btnAdvice.enabled = NO;
    lblOppScore.text = @"000";
    lblUserScore.text = @"000";
    lblStatus.text = @"Please start new game";
    lblRound.text = @"Round:1";
    lblHowResult.text = @"";
    lblYOUResult.text = @"";
    lblVS.text = @"VS";
    playerMe = 1;
    lblPlayerName.text = @"Other Player";
    [self imageChange:@"xrps-wp7-f4-2.png" :1];
    [self imageChange:@"xrps-wp7-f4-2.png" :2];
    
    
}



-(void)takeTurn:(GKTurnBasedMatch *)match {
    
    
    
    int numberBeforeLastMatch;
    int lastNumberMatch;
    
    gameInfoArray = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    
    if ([self checkIfOtherPlayerQuit:1] == false)
    {
        
        //player 2 score failed to update LBscore
    if ([[gameInfoArray objectAtIndex:5] floatValue] == 11)
    {
        playerMe = 2;
        lblPlayerName.text = [gameInfoArray objectAtIndex:6];
        
        
        //display what user picked for round before
        [self displayChange:4 :1];
        //display what opp picked for round before
        [self displayChange:3:2];
        
        btnRobot.enabled = NO;
        btnPaper.enabled = NO;
        btnScissors.enabled = NO;
        btnUnicorn.enabled = NO;
        btnRock.enabled = NO;
        btnPostScore.hidden = NO;
        lblHowResult.textColor = [UIColor orangeColor];
        lblHowResult.text =@"Try to update your leaderboard score again!";
        lblStatus.text = @"Match has ended";
        lblYOUResult.text = @"";
    }
    else if ([[gameInfoArray objectAtIndex:5] floatValue] == 12)
    {
        //player 1 won and needs to update score
        
        playerMe = 1;
        
        UIAlertView *outcomeEventWon = [[UIAlertView alloc] initWithTitle:nil message:@"YOU WIN :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [outcomeEventWon show];
        [self didPresentAlertView:outcomeEventWon];

        
        lblPlayerName.text = [gameInfoArray objectAtIndex:7];
        lblRound.text = @"Round: 5";
        
        //display what user picked for round before
        [self displayChange:3 :1];
        //display what opp picked for round before
        [self displayChange:4:2];
        
        btnRobot.enabled = NO;
        btnPaper.enabled = NO;
        btnScissors.enabled = NO;
        btnUnicorn.enabled = NO;
        btnRock.enabled = NO;
        btnPostScore.hidden = NO;
        lblHowResult.textColor = [UIColor orangeColor];
        lblHowResult.text =@"Please update your leaderboard score!";
        lblStatus.text = @"Match has ended";
        lblYOUResult.text = @"";
        
        int oppScore = [[gameInfoArray objectAtIndex:1] floatValue];
        int userScore = [[gameInfoArray objectAtIndex:0] floatValue];
        lblOppScore.text = [NSString stringWithFormat:@"%d",oppScore];
        lblUserScore.text = [NSString stringWithFormat:@"%d",userScore];
    }
    else 
    {
        NSLog(@"Taking turn for existing game...");
        
        NSMutableDictionary *generalPlayerData;
        
        generalPlayerData = [self loadPlayersChoiceData:@"generalPlayer"];
        
        NSMutableDictionary *playerData;
    
        btnRobot.enabled = YES;
        btnPaper.enabled = YES;
        btnScissors.enabled = YES;
        btnUnicorn.enabled = YES;
        btnRock.enabled = YES;
        btnAdvice.enabled = YES;
        lblStatus.text =@"It's your turn";
        
        GKTurnBasedParticipant *firstParticipant = 
        [match.participants objectAtIndex:0];
        if (firstParticipant == match.currentParticipant)
        {
            playerMe = 1;
        
            playerData = [self loadPlayersChoiceData:[gameInfoArray objectAtIndex:9]];
            
            numberBeforeLastMatch = [[gameInfoArray objectAtIndex:13]intValue];
            lastNumberMatch = [[gameInfoArray objectAtIndex:14]intValue];
            
            //we are already at least in second round and lastNumberMatch must exist already
            
        
            if (lastNumberMatch != 0)
            {
                //game is already further along
                [self updateLocalPlayerData:[gameInfoArray objectAtIndex:9] :numberBeforeLastMatch :lastNumberMatch:playerData];
                
                //updating generalPlayer data on device
                [self updateLocalPlayerData:@"generalPlayer" :numberBeforeLastMatch :lastNumberMatch:generalPlayerData];
            }
        
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
            
            playerData = [self loadPlayersChoiceData:[gameInfoArray objectAtIndex:8]];
            
            
            numberBeforeLastMatch = [[gameInfoArray objectAtIndex:10]intValue];
            lastNumberMatch = [[gameInfoArray objectAtIndex:11]intValue];
            
            if (lastNumberMatch != 0)
            {
                //updating current opponent player data
                [self updateLocalPlayerData:[gameInfoArray objectAtIndex:8] :numberBeforeLastMatch :lastNumberMatch:playerData];
                
                //updating generalPlayer data on device
                [self updateLocalPlayerData:@"generalPlayer" :numberBeforeLastMatch :lastNumberMatch:generalPlayerData];
            }
            
        
            lblPlayerName.text = [gameInfoArray objectAtIndex:6];
        
            int oppScore = [[gameInfoArray objectAtIndex:0] floatValue];
            int userScore = [[gameInfoArray objectAtIndex:1] floatValue];
            lblOppScore.text = [NSString stringWithFormat:@"%d",oppScore];
            lblUserScore.text = [NSString stringWithFormat:@"%d",userScore]; 
        
            [self imageChange:@"xrps-wp7-f4-2.png" :1];
            [self imageChange:@"xrps-wp7-f4-2.png" :2];
        
            lblYOUResult.text = @"";
            lblHowResult.text = @"";
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
    }
    }
    
}



@end
