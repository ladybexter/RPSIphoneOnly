//
//  AiFunction.m
//  RPSIphoneOnly
//
//  Created by student student on 04/02/2012.
//  Copyright (c) 2012 UoP. All rights reserved.
//

#import "AiFunction.h"
#import "math.h"
#import "stdlib.h"

@implementation AiFunction

void updatingConditionalArray(int numberBeforeLast, int lastNumber, double conditionalArray[])
{
    //update conditionalArray .. which element does the user pick after ...  
    if (numberBeforeLast > 0)
    {
        int positionUpdate = 5* (numberBeforeLast - 1) + (lastNumber - 1);
        conditionalArray[positionUpdate] = conditionalArray[positionUpdate] + 1.0;
    }
}

void actionLookUp(int lastNumber, double actionArray[])
{
        //actionArray basically gives the elements that can beat the element the user picks most more "power"
        if (lastNumber == 1)
        {
            updatingActionArray(1, 4, 2, 3, actionArray);
        }
        else if (lastNumber == 2)
        {
            updatingActionArray(2,3,0,4, actionArray);
        }
        else if (lastNumber == 3)
        {
            updatingActionArray(0,3,1,4, actionArray);
        }
        else if (lastNumber == 4) 
        {
            updatingActionArray(0, 4, 1, 2, actionArray);
        }
        else if (lastNumber == 5)
        {
            updatingActionArray(1, 2, 0, 3, actionArray);
        }
    
}

void updatingActionArray(int beatObject1, int beatObject2, int looseObject1, int looseObject2, double actionArray[])
{
    actionArray[beatObject1] = actionArray[beatObject1] * 1.1;
    actionArray[beatObject2] = actionArray[beatObject2]* 1.1;
    actionArray[looseObject1] = actionArray[looseObject1] * 0.9;
    actionArray[looseObject2] = actionArray[looseObject2] * 0.9;
    
    int u;
    double sum = 0;
    for (u=0; u<5; u++)
    {
        sum+= actionArray[u];
    }
    int i;
    for (i = 0; i < 5; i++)
    {
        actionArray[i] = actionArray[i]/sum;
    }
}

void updateWeightsConActionArray(int lastNumber, double weightsCondActionArray[], double bothPrevPredictedNum[], double numberOfGamesPlayed)
{
    if (numberOfGamesPlayed > 1.0)
    {
        double b = 1.0 - sqrt(1.0/numberOfGamesPlayed);
        double newWeightCond;
        if (lastNumber != bothPrevPredictedNum[0])
        {
            newWeightCond = (weightsCondActionArray[0] *b);
        }
        else
        {
            newWeightCond = weightsCondActionArray[0];
        }
        
        double newWeightAction;
        if (lastNumber != bothPrevPredictedNum[1])
        {
            newWeightAction = (weightsCondActionArray[1] *b);
        }
        else
        {
            newWeightAction = weightsCondActionArray[1];
        }
        
        weightsCondActionArray[0] = (newWeightCond/(newWeightCond + newWeightAction));
        weightsCondActionArray[1] = (newWeightAction/(newWeightCond + newWeightAction));
    }
    else
    {
        weightsCondActionArray[0] = 0.5;
        weightsCondActionArray[1] = 0.5;
    }
}

int findingNextNumberAction(double randomNumber, double predictedPercentage[])
{
    return findingNextNumber(randomNumber, predictedPercentage[0], predictedPercentage[1], predictedPercentage[2], predictedPercentage[3]);
}

int chooseNumberAfterUserPrediction(double randomNumber, int predictedUserChoice)
{
    if (predictedUserChoice ==1)
    {
        if (randomNumber <= 0.5)
        {
            return 2;
        }
        else
        {
            return 5;
        }
    }
    else if (predictedUserChoice == 2)
    {
        if (randomNumber <= 0.5)
        {
            return 3;
        }
        else
        {
            return 4;
        }
    }
    else if (predictedUserChoice == 3)
    {
        if (randomNumber <= 0.5)
        {
            return 4;
        }
        else
        {
            return 1;
        }
    }
    else if (predictedUserChoice == 4)
    {
        if (randomNumber <= 0.5)
        {
            return 5;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (randomNumber <= 0.5)
        {
            return 2;
        }
        else
        {
            return 3;
        }
    }
}

int findingNextNumberConditional(double randomNumber, double predictedPercentage[])
{
    double rangeWidth1 = predictedPercentage[0];
    double rangeWidth2 = predictedPercentage[1];
    double rangeWidth3 = predictedPercentage[2];
    double rangeWidth4 = predictedPercentage[3];
    
    int predictedUserChoice = findingNextNumber(randomNumber, rangeWidth1, rangeWidth2, rangeWidth3, rangeWidth4);
    
    return chooseNumberAfterUserPrediction(randomNumber, predictedUserChoice);
    
    
}

int findingNextNumber(double randomNumber, double rangeWidth1, double rangeWidth2, double rangeWidth3,double rangeWidth4)
{
    double sectionEnd1 = rangeWidth1;
    double sectionEnd2 = rangeWidth1 + rangeWidth2;
    double sectionEnd3 = sectionEnd2 + rangeWidth3;
    double sectionEnd4 = sectionEnd3 + rangeWidth4;
    
    int nextNumber;
    if (randomNumber <= sectionEnd1)
    {
        nextNumber = 1;
    }
    else if (randomNumber <= sectionEnd2)
    {
        nextNumber = 2;
    }
    else if (randomNumber <= sectionEnd3)
    {
        nextNumber = 3;
    }
    else if (randomNumber <= sectionEnd4)
    {
        nextNumber = 4;
    }
    else
    {
        nextNumber = 5;
    }
    
    return nextNumber;
}

void findPercentages(double row[], double predictedPercentageConditional[])
{
    double totalrow = 0;
    int u;
    for (u=0; u <5;u++)
    {
        totalrow+=row[u];
    }
    
    int ctr=0;
    while (ctr < 5)
    {
        predictedPercentageConditional[ctr] = row[ctr]/totalrow;
        ctr++;
    }
}

int findingNumberToBeatPrediction(double randomNumber, int beatObject1, int beatObject2)
{
    if (randomNumber < 0.5)
    {
        return beatObject1;
    }
    else
    {
        return beatObject2;
    }
}

void partOfConditionalArray(double args[], int startPoint, double partConditional[])
{
    partConditional[0] = args[startPoint];
    partConditional[1] = args[startPoint + 1];
    partConditional[2] = args[startPoint + 2];
    partConditional[3] = args[startPoint + 3];
    partConditional[4] = args[startPoint + 4];
}

double drand (double low, double high)
{
    return ((double)rand() * (high - low))/(double)RAND_MAX + low;
}

void nextNumberPrediction(int lastNumber, double conditionalArray[], double actionArray[], double results[])
{
    double partConditional[5];
    
    //finding the percentage for the row of the numberBeforeLast
    double predictedPercentageConditional[5] = {0.2,0.2,0.2,0.2,0.2};
    if(lastNumber ==1)
    {
        partOfConditionalArray(conditionalArray, 0, partConditional);
        findPercentages(partConditional, predictedPercentageConditional);
    }
    else if(lastNumber == 2)
    {
        partOfConditionalArray(conditionalArray, 5, partConditional);
        findPercentages(partConditional, predictedPercentageConditional);    
    }
    else if(lastNumber == 3)
    {
        partOfConditionalArray(conditionalArray, 10, partConditional);
        findPercentages(partConditional, predictedPercentageConditional);    
    }
    else if(lastNumber == 4) 
    {
        partOfConditionalArray(conditionalArray, 15, partConditional);
        findPercentages(partConditional, predictedPercentageConditional);    
    }
    else if(lastNumber == 5) 
    {
        partOfConditionalArray(conditionalArray, 20, partConditional);
        findPercentages(partConditional, predictedPercentageConditional);    
    }
    
    //conditional gets the number opponents most likely to pick (using random number as well) and then uses random number as well to pick which element to pick that will beat it.
    results[0] = findingNextNumberConditional(drand(0,1), predictedPercentageConditional);
    
    //finding next number action gets the number that is most likely gonna beat the element the user will pick
    results[1] = findingNextNumberAction(drand(0,1), actionArray);
}

@end
