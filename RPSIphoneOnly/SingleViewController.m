//
//  SingleViewController.m
//  RPSIphoneOnly
//
//  Created by student student on 03/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import "SingleViewController.h"
#import "AiFunction.h"
#import "AppDelegate.h"


@implementation SingleViewController

@synthesize txtAIMode;
@synthesize testlabel;
@synthesize imgUserDisplay;
@synthesize imgComputerDisplay;
@synthesize txtWinLoss;
@synthesize txtResult;
@synthesize txtUserScore;
@synthesize txtComputerScore;
@synthesize txtVS;
@synthesize txtBestConWins;
@synthesize txtUserBestConsWin;
@synthesize txtComputerBestConsWin;

int timerCount = 0;
int lastNumber = 0;
int numberBeforeLast = 0;
double numberOfGamesPlayed = 0;
NSString *modeChoice;

int userScore = 0;
int userChoice;
int computerScore = 0;
int computerChoice;
NSNumber *computerChoiceNS;
double computerPick;
int scoreDifference;

int consecutiveWinsComputer = 0;
int consecutiveWinsUser = 0;
int bestConsectuiveWinsComputer = 0;
int bestConsecutiveWinsUser = 0;
int consecutiveScoreDifference;

double conditionalArray[25] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
double actionArray[5] = { 0.2, 0.2, 0.2, 0.2, 0.2 };
double weightsConditionActionArray[2] = { 0.5, 0.5 };
int bothPrevPredictedNum[2] = { 0, 0 };
double results[2] ={ 1, 1};
double predictedNum[2] ={4,4};




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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XRPSInterfacebackground2" ofType:@"png" inDirectory:@""];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:path]]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    modeChoice = [appDelegate mode];
    
    testlabel.text = modeChoice;
    
    int m;
    
    m = [modeChoice intValue];
    
    //easy mode
    if (m == 1)
    {
        txtAIMode.text = @"Lina";
        testlabel.text = @"Mode: easy";
    }
    else // intense mode 
    {
        txtAIMode.text = @"Joanna";
        testlabel.text = @"Mode: intense";
        
    }
     
}

- (void)viewDidUnload
{
    [self setImgUserDisplay:nil];
    [self setImgComputerDisplay:nil];
    [self setTxtWinLoss:nil];
    [self setTxtResult:nil];
    [self setTxtUserScore:nil];
    [self setTxtComputerScore:nil];
    [self setTxtVS:nil];
    [self setTxtBestConWins:nil];
    [self setTxtUserBestConsWin:nil];
    [self setTxtComputerBestConsWin:nil];
    [self setTestlabel:nil];
    [self setTxtAIMode:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
        
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


-(void) gameComplete{
    
    //if no games have been played then no data will be available for the computer to make an estimate from
    // for the first game the computer will make a random estimation
    // for the rest of the time the computer will take users past choices to prect the next action
    if (numberBeforeLast == 0)
    {
        int r = (arc4random()%5) + 1;
        computerChoice = r;
    }
    else
    {
        updatingConditionalArray(numberBeforeLast, lastNumber, conditionalArray);
          
        actionLookUp(numberBeforeLast, lastNumber, actionArray);
        
        updateWeightsConActionArray(lastNumber, weightsConditionActionArray, predictedNum , numberOfGamesPlayed);
        
        nextNumberPrediction(lastNumber, numberBeforeLast, conditionalArray, actionArray, weightsConditionActionArray, numberOfGamesPlayed, predictedNum, results);
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        modeChoice = [appDelegate mode];
        int m;
        
        m = [modeChoice intValue];
        
        //easy mode
        if (m == 1)
        {
            computerChoice = (int)results[0];
        }
        else // intense mode 
        {
            computerChoice = (int)results[1];
            
        }
        
        
        
        predictedNum[0] = results[0];
        predictedNum[1] = results[1];        
    }
    
    numberOfGamesPlayed = ((int) numberOfGamesPlayed + 1)%50;
    
    // start Timer
    counter = 0;
    
    computerChoiceNS = [NSNumber numberWithInt:computerChoice];

    
    time = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(action:)  userInfo:computerChoiceNS repeats:YES];
    
    //[self computerDisplay:computerChoice :true];
    
    
}


-(void)action:(NSTimer *)timer {
    computerPick = [computerChoiceNS doubleValue];
	if(counter < 15){
        counter++;
        int random = (arc4random()%5) + 1;
        [self computerDisplay:random: false];        
    }else{
        [time invalidate];
        [self computerDisplay:computerPick: true];        
    }
}

-(void)tie
{
    txtResult.textColor =[UIColor blueColor];
    txtWinLoss.textColor = [UIColor blueColor];
    txtWinLoss.text = @"YOU TIE";
    txtResult.text = @"No Win, No Lose";
    consecutiveWinsComputer = 0;
    consecutiveWinsUser = 0;
    [self displayORHide:3];  
    
}

-(void)win
{
    txtResult.textColor =[UIColor greenColor];
    txtWinLoss.textColor = [UIColor greenColor];
    txtWinLoss.text = @"YOU WIN";
    userScore = userScore + 1;
    consecutiveWinsUser = consecutiveWinsUser + 1;
    consecutiveWinsComputer = 0;
    [self displayORHide:3];  
}

-(void)lose
{
    txtResult.textColor =[UIColor redColor];
    txtWinLoss.textColor = [UIColor redColor];
    txtWinLoss.text =@"YOU LOSE";
    computerScore = computerScore + 1;
    consecutiveWinsComputer = consecutiveWinsComputer + 1;
    consecutiveWinsUser = 0;
    [self displayORHide:3];  
}

-(void)computerDisplay:(double)computerPick :(_Bool)finalImage
{
    if(computerPick == 1)
    {
        [self imageChange:@"rock5._finalise-android(78x78)nobg.png":2];
    }
    else if(computerPick == 2)
    {
        [self imageChange:@"paper2_finalise-android(78x78)nobg.png":2];
    }
    else if(computerPick == 3)
    {
        [self imageChange:@"scissors4_finalise-android(78x78)nobg.png":2];    
    }
    else if(computerPick == 4)
    {
        [self imageChange:@"unicorn3_finalise-android(78x78)nobg.png":2];    
    }
    else
    {
        [self imageChange:@"robot4_finalise-android(78x78)nobg.png":2];    
    }
    
    if(finalImage == true)
    {
        [self resultsDisplay:userChoice : computerChoice];
    }
}

-(void)resultsDisplay:(double)userpick :(double)computerpick
{
    
    if (userpick == 1)
    {
        if (computerpick == 1)
        {
            [self tie];
        }
        else if (computerpick == 2)
        {
            txtResult.text = @"Paper 'wraps' around Rock";
            [self lose];
            
        }
        else if (computerpick == 3)
        {
            txtResult.text = @"Rock 'breaks' Scissors";
            [self win];
            
        }
        else if (computerpick == 4)
        {
            txtResult.text = @"Rock 'knocks' out Unicorn";
            [self win];
        }
        else
        {
            txtResult.text = @"Robot 'smashes' Rock";
            [self lose];
        }
    }
    else if (userpick == 2)
    {
        if (computerpick == 1)
        {
            txtResult.text = @"Paper 'wraps' around Rock";
            [self win ];
        }
        else if (computerpick == 2)
        {
            [self tie ];
        }
        else if (computerpick == 3)
        {
            txtResult.text = @"Scissors 'cut' Paper";
            [self lose ];
        }
        else if (computerpick == 4)
        {
            txtResult.text = @"Unicorn 'pokes' hole in Paper";
            [self lose ];
        }
        else
        {
            txtResult.text = @"Paper 'blinds' Robot vision";
            [self win ];
        }
    }
    else if (userpick == 3)
    {
        if (computerpick == 1)
        {
            txtResult.text = @"Rock 'breaks' Scissors";
            [self lose ];
        }
        else if (computerpick == 2)
        {
            txtResult.text = @"Scissors 'cut' Paper";
            [self win ];
        }
        else if (computerpick == 3)
        {
            [self tie ];
        }
        else if (computerpick == 4)
        {
            txtResult.text = @"Unicorn 'stomps' on Scissors";
            [self lose ];
        }
        else
        {
            txtResult.text = @"Scissors 'cut' Robot wires";
            [self win ];
        }
    }
    else if (userpick == 4)
    {
        if (computerpick == 1)
        {
            txtResult.text = @"Rock 'knocks out' Unicorn";
            [self lose ];
        }
        else if (computerpick == 2)
        {
            txtResult.text = @"Unicorn 'pokes' hole in Paper";
            [self win ];
        }
        else if (computerpick == 3)
        {
            txtResult.text = @"Unicorn 'stomps' on Scissors";
            [self win ];
        }
        else if (computerpick == 4)
        {
            [self tie ];
        }
        else
        {
            txtResult.text = @"Robot laser 'shoots' Unicorn";
            [self lose ];
        }
    }
    else
    {
        if (computerpick == 1)
        {
            txtResult.text = @"Robot 'smashes' Rock";
            [self win ];
        }
        else if (computerpick == 2)
        {
            txtResult.text = @"Paper 'blinds' Robot vision";
            [self lose ];
        }
        else if (computerpick == 3)
        {
            txtResult.text = @"Scissors 'cut' Robot wires";
            [self lose ];
        }
        else if (computerpick == 4)
        {
            txtResult.text = @"Robot laser 'shoots' Unicorn";
            [self win ];
        }
        else
        {
            [self tie ];
        }
    }
    
    if (consecutiveWinsUser > bestConsecutiveWinsUser)
    {
        bestConsecutiveWinsUser = consecutiveWinsUser;
    }
    
    if (consecutiveWinsComputer > bestConsectuiveWinsComputer)
    {
        bestConsectuiveWinsComputer = consecutiveWinsComputer;
    }
    
    txtUserBestConsWin.text = [NSString stringWithFormat:@"%d",bestConsecutiveWinsUser];
    txtComputerBestConsWin.text = [NSString stringWithFormat:@"%d",bestConsectuiveWinsComputer];
    txtComputerScore.text = [NSString stringWithFormat:@"%d",computerScore];
    txtUserScore.text = [NSString stringWithFormat:@"%d",userScore];    
    
}




-(void)imageChange:(NSString*) image:(int) number{
    if(number == 1)
    {
        imgUserDisplay.image = [UIImage imageNamed:(image)];
    }
    else
    {
        imgComputerDisplay.image = [UIImage imageNamed:(image)];
    }
}

-(void)displayORHide:(int) variable{
    
    txtWinLoss.hidden = variable;  
    txtResult.hidden = variable; 
    
    if(variable == 3)
    {
        txtBestConWins.hidden = 0;
        txtComputerBestConsWin.hidden = 0;
        txtComputerScore.hidden = 0;
        txtUserBestConsWin.hidden = 0;
        txtUserScore.hidden = 0;
        txtVS.hidden = 0;
        txtWinLoss.hidden = 0;
        txtResult.hidden = 0;
    }
}


-(void)resetThings
{
    lastNumber = 0;
    numberBeforeLast = 0;
    numberOfGamesPlayed = 0;
    
    txtUserScore.text = @"0";
    userScore = 0;
    txtComputerScore.text = @"0";
    computerScore = 0;
    
    
    consecutiveWinsComputer = 0;
    consecutiveWinsUser = 0;
    txtComputerBestConsWin.text = @"0";
    bestConsectuiveWinsComputer = 0;
    txtUserBestConsWin.text = @"0";
    bestConsecutiveWinsUser = 0;
    
    int ctr=0;
    while (ctr < 25)
    {
        conditionalArray[ctr] = 1;
        ctr++;
    }    
    
    int t=0;
    while (t < 5)
    {
        actionArray[t] = 0.2;
        t++;
    }
    
    
    weightsConditionActionArray[0] = 0.5;   
    weightsConditionActionArray[1] = 0.5;
    bothPrevPredictedNum[0] = 0;
    bothPrevPredictedNum[1] = 0;
    results[0] = 1;
    results[1] = 1;
    predictedNum[0] = 4;
    predictedNum[1] = 4;
    
    [self imageChange:@"rock5._finalise-android(78x78)nobg.png":1];
    [self displayORHide:1];  
}


- (IBAction)btnRock:(id)sender {    
    
       
    numberBeforeLast = lastNumber;
    lastNumber = 1;
    userChoice = 1;
    
    
    [self imageChange:@"rock5._finalise-android(78x78)nobg.png":1];
    
    [self displayORHide:1];  
    
    [self gameComplete];
    
    
}

- (IBAction)btnPaper:(id)sender {
    
    numberBeforeLast = lastNumber;
    lastNumber = 2;
    userChoice = 2;    
    
    [self imageChange:@"paper2_finalise-android(78x78)nobg.png":1];
    [self displayORHide:1];  
    
    [self gameComplete];
}

- (IBAction)btnScissors:(id)sender {
    
    numberBeforeLast = lastNumber;
    lastNumber = 3;
    userChoice = 3;
    
    [self imageChange:@"scissors4_finalise-android(78x78)nobg.png":1];
    [self displayORHide:1];     
    
    [self gameComplete];
}

- (IBAction)btnUnicorn:(id)sender {
    
    numberBeforeLast = lastNumber;
    lastNumber = 4;
    userChoice = 4;
    
    [self imageChange:@"unicorn3_finalise-android(78x78)nobg.png":1];
    [self displayORHide:1];  
    
    [self gameComplete];
}

- (IBAction)btnRobot:(id)sender {
    
    numberBeforeLast = lastNumber;
    lastNumber = 5;
    userChoice = 5;
    
    [self imageChange:@"robot4_finalise-android(78x78)nobg.png":1];
    [self displayORHide:1];      
    
    [self gameComplete];
}

- (IBAction)btnReset:(id)sender {
    [self resetThings];
    
       }

- (IBAction)btnHome:(id)sender {
    [self resetThings];
}

@end
