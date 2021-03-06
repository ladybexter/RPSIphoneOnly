//
//  MultiPlayerViewController.h
//  RPSIphoneOnly
//
//  Created by student student on 11/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCHelper.h"


@interface MultiPlayerViewController : UIViewController <UITextFieldDelegate,  
GCTurnBasedMatchHelperDelegate>{
    
    NSMutableArray *gameInfoArray;
}

@property (weak, nonatomic) IBOutlet UILabel *lblLBScore;
@property (weak, nonatomic) IBOutlet UIButton *btnPostScore;

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgOppPick;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPick;
@property (weak, nonatomic) IBOutlet UILabel *lblRound;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayerName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserScore;
@property (weak, nonatomic) IBOutlet UILabel *lblOppScore;
@property (weak, nonatomic) IBOutlet UILabel *lblYOUResult;
@property (weak, nonatomic) IBOutlet UILabel *lblHowResult;
@property (weak, nonatomic) IBOutlet UILabel *lblVS;

@property (weak, nonatomic) IBOutlet UIButton *btnRock;
@property (weak, nonatomic) IBOutlet UIButton *btnPaper;
@property (weak, nonatomic) IBOutlet UIButton *btnScissors;
@property (weak, nonatomic) IBOutlet UIButton *btnUnicorn;
@property (weak, nonatomic) IBOutlet UIButton *btnRobot;
@property (weak, nonatomic) IBOutlet UIButton *btnAdvice;


- (IBAction)btnPostScore:(id)sender;

- (IBAction)btnPaper:(id)sender;
- (IBAction)btnScissors:(id)sender;
- (IBAction)btnUnicorn:(id)sender;
- (IBAction)btnRobot:(id)sender;
- (IBAction)btnRock:(id)sender;

- (IBAction)btnAIAdvice:(id)sender;
- (IBAction)presentGCTurnViewController:(id)sender;

@end
