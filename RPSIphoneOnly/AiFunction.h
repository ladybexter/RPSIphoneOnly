//
//  AiFunction.h
//  RPSIphoneOnly
//
//  Created by student student on 04/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AiFunction : NSObject

void updatingConditionalArray(int numberBeforeLast, int lastNumber, double conditionalArray[]);

void actionLookUp(int numberBeforeLast, int lastNumber, double actionArray[]);

void updatingActionArray(int beatObject1, int beatObject2, int looseObject1, int looseObject2, double actionArray[]);

void updateWeightsConActionArray(int lastNumber, double weightsCondActionArray[], double bothPrevPredictedNum[], double numberOfGamesPlayed);

int findingNextNumberAction(double randomNumber, double predictedPercentage[]);

int findingNextNumberConditional(double randomNumber, double predictedPercentage[]);

int findingNextNumber(double randomNumber, double rangeWidth1, double rangeWidth2, double rangeWidth3,double rangeWidth4);

void findPercentages(double row[], double predictedPercentageConditional[]);

void partOfConditionalArray(double args[], int startPoint, double partConditional[]);

double drand (double low, double high);

int findingNumberToBeatPrediction(double randomNumber, int beatObject1, int beatObject2);

void nextNumberPrediction(int lastNumber, int numberBeforeLast, double conditionalArray[], double actionArray[], double weightsCondActionArray[], double numberOfGamesPlayed, double bothPrevPredictedNum[], double results[]);

@end
