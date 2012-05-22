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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XRPSInterfacebackground3" ofType:@"png" inDirectory:@""];
    
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
        [actionArrayNS addObject:[NSString stringWithFormat:@"%d", 0.2]];       
    }
    
    NSMutableArray *predictedNumNS = [NSMutableArray arrayWithCapacity:2];
    
    [predictedNumNS addObject:[NSNumber numberWithInt:4]];
    [predictedNumNS addObject:[NSNumber numberWithInt:4]];
   
    
    NSMutableArray *weightsConditionActionArrayNS = [NSMutableArray arrayWithCapacity:2];
    
    [weightsConditionActionArrayNS addObject:[NSString stringWithFormat:@"%d", 0.5]];
    [weightsConditionActionArrayNS addObject:[NSString stringWithFormat:@"%d", 0.5]];
    
    [playerData setObject:conditionalArrayNS forKey:@"conditionalArray"];
    [playerData setObject:actionArrayNS forKey:@"actionArray"];
    [playerData setObject:predictedNumNS forKey:@"predictedNum"];
    [playerData setObject:weightsConditionActionArrayNS forKey:@"weightsConditionActionArray"];
    [playerData setObject:[NSNumber numberWithInt:0] forKey:@"lastNumber"];
    [playerData setObject:[NSNumber numberWithInt:0] forKey:@"numberBeforeLast"];
    [playerData setObject:[NSNumber numberWithInt:0] forKey:@"numberOfGamesPlayed"];
    
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
            [nsArray replaceObjectAtIndex:x withObject:[NSString stringWithFormat:@"%d", originalArray[x]]];
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
    
    //And write data:
    
    
    [data setObject:playerData forKey:PlayersID];
    
    [data writeToFile: path atomically:YES];
    
}



-(void)convertUpdateconvert:(NSString *)Playername
{
    int linaChoice;
    int joannaChoice;
    int numberBeforeLast;
    int lastNumber;
    int numberOfGamesPlayed;
    
    
    //initialize normal arrays for update later
    double conditionalArray[25] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
    double actionArray[5] = { 0.2, 0.2, 0.2, 0.2, 0.2 };
    double weightsConditionActionArray[2] = { 0.5, 0.5 };
    double results[2] ={ 1, 1};
    double predictedNum[2] ={4,4};
    
    //get loaded data
     NSMutableDictionary *loadedPlayerData;
    loadedPlayerData = [self loadPlayersChoiceData:Playername];
    
    
    NSMutableArray *conditionalArrayNS1 = [NSMutableArray arrayWithCapacity:25]; 
    conditionalArrayNS1 = [loadedPlayerData objectForKey:@"conditionalArray"];
    NSMutableArray *actionArrayNS1 = [NSMutableArray arrayWithCapacity:5]; 
    actionArrayNS1 = [loadedPlayerData objectForKey:@"actionArray"];
    NSMutableArray *predictedNumNS1 = [NSMutableArray arrayWithCapacity:2];
    predictedNumNS1 = [loadedPlayerData objectForKey:@"predictedNum" ];
    NSMutableArray *weightsConditionActionArrayNS1 = [NSMutableArray arrayWithCapacity:2];
    weightsConditionActionArrayNS1 = [loadedPlayerData objectForKey:@"weightsConditionActionArray"];
    
   
    //update normal arrays with loaded player data
    [self convertNSMutableArrayToArray:conditionalArrayNS1:conditionalArray];
    [self convertNSMutableArrayToArray:actionArrayNS1:actionArray]; 
    [self convertNSMutableArrayToArray:weightsConditionActionArrayNS1:weightsConditionActionArray]; 
    [self convertNSMutableArrayToArray:predictedNumNS1:predictedNum];
     

    numberBeforeLast = [[loadedPlayerData objectForKey:@"numberBeforeLast"]intValue];
    lastNumber = [[loadedPlayerData objectForKey:@"lastNumber"]intValue];
    numberOfGamesPlayed = [[loadedPlayerData objectForKey:@"numberOfGamesPlayed"]intValue];
    
    
    //if no games have been played then no data will be available for the computer to make an estimate from
    // for the first game the computer will make a random estimation
    // for the rest of the time the computer will take users past choices to prect the next action
    if (numberBeforeLast == 0)
    {
        int r = (arc4random()%5) + 1;
        linaChoice = r;
        joannaChoice = r;
        
    }
    else
    {
        
        //updating player data using normal arrays and previously loaded data
        updatingConditionalArray(numberBeforeLast, lastNumber, conditionalArray);
        
        actionLookUp(numberBeforeLast, lastNumber, actionArray);
        
        updateWeightsConActionArray(lastNumber, weightsConditionActionArray, predictedNum , numberOfGamesPlayed);
        
        nextNumberPrediction(lastNumber, numberBeforeLast, conditionalArray, actionArray, weightsConditionActionArray, numberOfGamesPlayed, predictedNum, results);
        
        
        linaChoice = (int)results[0];
        
        joannaChoice = (int)results[1];
         
        predictedNum[0] = results[0];
        predictedNum[1] = results[1];        
    }
    
    //update numberOfGamesPlayed
    numberOfGamesPlayed = ((int) numberOfGamesPlayed + 1)%50;
    
    
    //update the nsarrays with updated normal arrays
    [self convertArrayToNSMutableArray:conditionalArrayNS1 :conditionalArray :FALSE];
    [self convertArrayToNSMutableArray:actionArrayNS1 :actionArray :TRUE];
    [self convertArrayToNSMutableArray:weightsConditionActionArrayNS1 :weightsConditionActionArray :TRUE];
    [self convertArrayToNSMutableArray:predictedNumNS1 :predictedNum :FALSE];
    
    //use NSArrays and make new playerdata dictionary to be saved
     NSMutableDictionary *updatedPlayerData;
    
    [updatedPlayerData setObject:conditionalArrayNS1 forKey:@"conditionalArray"];
    [updatedPlayerData setObject:actionArrayNS1 forKey:@"actionArray"];
    [updatedPlayerData setObject:predictedNumNS1 forKey:@"predictedNum"];
    [updatedPlayerData setObject:weightsConditionActionArrayNS1 forKey:@"weightsConditionActionArray"];
    [updatedPlayerData setObject:[NSNumber numberWithInt:lastNumber] forKey:@"lastNumber"];
    [updatedPlayerData setObject:[NSNumber numberWithInt:numberBeforeLast] forKey:@"numberBeforeLast"];
    [updatedPlayerData setObject:[NSNumber numberWithInt:numberOfGamesPlayed] forKey:@"numberOfGamesPlayed"];
    
    [self savePlayerDataLocally:updatedPlayerData :Playername];
    
    
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
    
    //if leaderboardscore is -1 then there was an error retreiving current leaderboard score
    
    if (leaderboardScore != -1)
    {
    
            //no data stored yet
        if (leaderboardScore == 0 & localScore == 0)
        {
            //create local score storage and set it to 1
            [self saveScoreLocally:1 :PlayersID];
        
            //post localScore as leaderboardScore
            [self reportScore:1 forCategory: kLeaderboardID];  
        }
        else if(leaderboardScore == 0)
        {
            //leaderboard hasnt been updated yet. take local score increase by one and post it
            newScore = localScore + 1;
            [self reportScore:newScore forCategory:kLeaderboardID];
        
            //submit update for local score
            [self saveScoreLocally:newScore :PlayersID];
        }
        else if(localScore == 0)
        {
            //create local score with current leaderboardNumber
            newScore = leaderboardScore + 1;
            [self saveScoreLocally:newScore :PlayersID];
        
            //submit new leaderboard score
            [self reportScore:newScore forCategory:kLeaderboardID];
        }
        else if(localScore == leaderboardScore)
        {
            newScore = localScore + 1;
        
            [self reportScore:newScore forCategory:kLeaderboardID];
            [self saveScoreLocally:newScore :PlayersID];
        }
        else if(localScore > leaderboardScore)
        {
            //leaderboardscore hasnt updated yet
            newScore = localScore + 1;
        
            [self reportScore:newScore forCategory:kLeaderboardID];
            [self saveScoreLocally:newScore :PlayersID];
        }
        else if(leaderboardScore > localScore)
        {
            //devices were switched so leaderboard score will b more up to date
            newScore = leaderboardScore + 1;
        
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
                                           }
                                       }];
        
        
    }
    }
    
    
}

- (IBAction)btnPostScore:(id)sender {
    
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
    lblHowResult.text = @"";
    lblYOUResult.text = @"";
    lblVS.text = @"VS";
    playerMe = 1;
    lblPlayerName.text = @"Other Player";
    [self imageChange:@"xrps-wp7-f4-2.png" :1];
    [self imageChange:@"xrps-wp7-f4-2.png" :2];
    
    
}



-(void)takeTurn:(GKTurnBasedMatch *)match {
    
    
    
    gameInfoArray = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    
    if ([self checkIfOtherPlayerQuit:1] == false)
    {
        
        //player 2 score failed to update LBscore
    if ([[gameInfoArray objectAtIndex:5] floatValue] == 11)
    {
        
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
        lblHowResult.text =@"Try to update your leaderboard score again!";
        lblStatus.text = @"Match has ended";
        lblYOUResult.text = @"";
    }
    else if ([[gameInfoArray objectAtIndex:5] floatValue] == 12)
    {
        //player 1 won and needs to update score
        
        UIAlertView *outcomeEventLost = [[UIAlertView alloc] initWithTitle:nil message:@"YOU WIN :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [outcomeEventLost show];
        [self didPresentAlertView:outcomeEventLost];

        
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
