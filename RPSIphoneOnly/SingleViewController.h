//
//  SingleViewController.h
//  RPSIphoneOnly
//
//  Created by student student on 03/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleViewController : UIViewController
{
    NSTimer *time;
    int counter;
}

@property (weak, nonatomic) IBOutlet UILabel *txtAIMode;
@property (weak, nonatomic) IBOutlet UILabel *testlabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserDisplay;
@property (weak, nonatomic) IBOutlet UIImageView *imgComputerDisplay;
@property (weak, nonatomic) IBOutlet UILabel *txtWinLoss;
@property (weak, nonatomic) IBOutlet UILabel *txtResult;
@property (weak, nonatomic) IBOutlet UILabel *txtUserScore;
@property (weak, nonatomic) IBOutlet UILabel *txtComputerScore;
@property (weak, nonatomic) IBOutlet UILabel *txtVS;
@property (weak, nonatomic) IBOutlet UILabel *txtBestConWins;
@property (weak, nonatomic) IBOutlet UILabel *txtUserBestConsWin;
@property (weak, nonatomic) IBOutlet UILabel *txtComputerBestConsWin;


- (IBAction)testAlert:(id)sender;

- (IBAction)btnRock:(id)sender;
- (IBAction)btnPaper:(id)sender;
- (IBAction)btnScissors:(id)sender;
- (IBAction)btnUnicorn:(id)sender;
- (IBAction)btnRobot:(id)sender;
- (IBAction)btnReset:(id)sender;
- (IBAction)btnHome:(id)sender;

-(void)imageChange:(NSString*) image:(int)number;
-(void)displayORHide:(int) variable;
-(void)gameComplete;
-(void)computerDisplay:(double) computerPick:(bool) finalImage;
-(void)resultsDisplay:(double)userpick:(double)computerpick;
-(void)tie;
-(void)win;
-(void)lose;
-(void)resetThings;



@end
