//
//  MultiPlayerViewController.h
//  RPSIphoneOnly
//
//  Created by student student on 11/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCHelper.h"

@interface MultiPlayerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
- (IBAction)btnPaper:(id)sender;
- (IBAction)btnScissors:(id)sender;
- (IBAction)btnUnicorn:(id)sender;
- (IBAction)btnRobot:(id)sender;

- (IBAction)btnRock:(id)sender;

- (IBAction)btnAIAdvice:(id)sender;
- (IBAction)presentGCTurnViewController:(id)sender;

@end
