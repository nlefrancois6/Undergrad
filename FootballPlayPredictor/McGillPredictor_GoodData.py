#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 29 22:27:23 2020

@author: Noah LeFrancois
@email: noah.lefrancois@mail.mcgill.ca

Using data for each play in Con U's 2019 season (obtained from Hudl), we want to predict 
their play selection (run/pass, play type, zones targeted) on the next play given input info 
such as clock, field position, personnel, down&distance, defensive personnel, etc. 

Here we use the first 4 games of their season to train the model, and test its predictions in
the final game of their season.
"""

from sklearn.metrics import accuracy_score
import matplotlib.pyplot as plt
from sklearn import ensemble
import pandas as pd
import numpy as np
#import sys

plotPie = True
plotImportance = True
#Allowed Outputs: 'PLAY CATEGORY','PLAY TYPE'
Out = 'PLAY CATEGORY'
#Load the play data for the desired columns into a dataframe
#Currently the data is ordered by field zone so when i split into testing&training sets it's not
#randomly sampled. Need to either shuffle the csv entries or randomly sample from the df
df = pd.read_csv("CONUv1.csv")

#Get the variables we care about from the dataframe
df = df[['QTR','SCORE DIFF. (O)','SITUATION (O)','DRIVE #','DRIVE PLAY #','1ST DN #','D&D','Field Zone','HASH','OFF TEAM','PERS','OFF FORM','BACKF SET','PLAY CATEGORY','PLAY TYPE','DEF TEAM','DEF PERSONNEL', 'DEF FRONT']]

#Handle empty entries
#df = df.replace(np.nan, 'REG', regex=True)
df['SITUATION (O)'].fillna('REG', inplace=True)

#Relabel the feature strings to number them so the GBR can read them
formations = df['OFF FORM'].unique().tolist()
formationmapping = dict( zip(formations,range(len(formations))) )
df.replace({'OFF FORM': formationmapping},inplace=True)

situation = df['SITUATION (O)'].unique().tolist()
situationmapping = dict( zip(situation,range(len(situation))) )
df.replace({'SITUATION (O)': situationmapping},inplace=True)

defenseTeams = df['DEF TEAM'].unique().tolist()
defenseTeamMap = dict( zip(defenseTeams,range(len(defenseTeams))) )
df.replace({'DEF TEAM': defenseTeamMap},inplace=True)

DD = df['D&D'].unique().tolist()
DDmapping = dict( zip(DD,range(len(DD))) )
df.replace({'D&D': DDmapping},inplace=True)

FieldZone = df['Field Zone'].unique().tolist()
FieldZonemapping = dict( zip(FieldZone,range(len(FieldZone))) )
df.replace({'Field Zone': FieldZonemapping},inplace=True)

HASH = df['HASH'].unique().tolist()
HASHmapping = dict( zip(HASH,range(len(HASH))) )
df.replace({'HASH': HASHmapping},inplace=True)

OFFTEAM = df['OFF TEAM'].unique().tolist()
OFFTEAMmapping = dict( zip(OFFTEAM,range(len(OFFTEAM))) )
df.replace({'OFF TEAM': OFFTEAMmapping},inplace=True)

PERS = df['PERS'].unique().tolist()
PERSmapping = dict( zip(PERS,range(len(PERS))) )
df.replace({'PERS': PERSmapping},inplace=True)

BACKFSET = df['BACKF SET'].unique().tolist()
BACKFSETmapping = dict( zip(BACKFSET,range(len(BACKFSET))) )
df.replace({'BACKF SET': BACKFSETmapping},inplace=True)

DEFPERSONNEL = df['DEF PERSONNEL'].unique().tolist()
DEFPERSONNELmapping = dict( zip(DEFPERSONNEL,range(len(DEFPERSONNEL))) )
df.replace({'DEF PERSONNEL': DEFPERSONNELmapping},inplace=True)

#DEFFRONT = df['DEF FRONT'].unique().tolist()
#DEFFRONTmapping = dict( zip(DEFFRONT,range(len(DEFFRONT))) )
#df.replace({'DEF FRONT': DEFFRONTmapping},inplace=True)

#I'd like to compute the yards gained, play type, and result from the previous play and add them as an input for the current play
#df['prevYards'] = prevYards
#df['prevPlayType'] = prevPlayType
#df['prevPlayResult'] = prevPlayResult

#Separate into training data set (Con U 2019 Games 1-7) and testing data set (Con U 2019 Game 8)
training_df = df.sample(frac=0.9, random_state=1)
indlist=list(training_df.index.values)

testing_df = df.copy().drop(index=indlist)

#Shouldn't need to filter only run, pass like w/NFL data since we can select only offensive plays (no K or D). Need to make sure we're either excluding or handling dead plays though.


#Find the relative frequency of runs and passes as a baseline to compare our play type prediction to

if Out == 'PLAY TYPE':
    rel_freq = testing_df['PLAY TYPE'].value_counts()
    if plotPie == True:
        f1=plt.figure()
        #need to edit the labels to match the categories in our data
        plt.pie(rel_freq, labels = ('Pass','Run'), autopct='%.2f%%')
        plt.title("Concordia 2019 play-type distribution")
        plt.subplots_adjust(left=0, bottom=0, right=1, top=1, wspace=0, hspace=0)
        plt.show()
elif Out == 'PLAY CATEGORY':
    rel_freq = testing_df['PLAY CATEGORY'].value_counts()
    if plotPie == True:
        f1=plt.figure()
        #need to edit the labels to match the categories in our data
        plt.pie(rel_freq, labels = ('RPO','DROPBACK','RUN','PA POCKET','QUICK','SCREEN/DRAW'), autopct='%.2f%%')
        plt.title("Concordia 2019 play-type distribution")
        plt.subplots_adjust(left=0, bottom=0, right=1, top=1, wspace=0, hspace=0)
        plt.show()
else:
    print(Out + ' is not a supported output')
    #sys.exit(['end'])



#Define the features (input) and label (prediction output) for training set
training_features = training_df[['QTR','SCORE DIFF. (O)','SITUATION (O)','DRIVE #','DRIVE PLAY #','1ST DN #','D&D','Field Zone','HASH','OFF TEAM','PERS','DEF TEAM','DEF PERSONNEL']]
#'QTR','SCORE DIFF. (O)','SITUATION (O)','DRIVE #','DRIVE PLAY #','1ST DN #','D&D','Field Zone','HASH','OFF TEAM','PERS','OFF FORM','BACKF SET','DEF TEAM','DEF PERSONNEL'


if Out == 'PLAY TYPE':
    training_label = training_df['PLAY TYPE']
elif Out == 'PLAY CATEGORY':
    training_label = training_df['PLAY CATEGORY']


#Define features and label for testing set
testing_features = testing_df[['QTR','SCORE DIFF. (O)','SITUATION (O)','DRIVE #','DRIVE PLAY #','1ST DN #','D&D','Field Zone','HASH','OFF TEAM','PERS','DEF TEAM','DEF PERSONNEL']]

if Out == 'PLAY TYPE':
    testing_label = testing_df['PLAY TYPE']
elif Out == 'PLAY CATEGORY':
    testing_label = testing_df['PLAY CATEGORY']



#Train a Gradient Boosting Machine on the data
#Using 500 for category, 200 for type roughly maximizes accuracy so far
gbr = ensemble.GradientBoostingClassifier(n_estimators = 500, learning_rate = 0.02)

gbr.fit(training_features, training_label)

#Predict the run/pass percentage from our test set and evaluate the prediction accuracy
prediction = gbr.predict(testing_features)

accuracy = accuracy_score(testing_label, prediction)
print("Accuracy: "+"{:.2%}".format(accuracy))

#Determine how strongly each feature affects the outcome
features = ['QTR','SCORE DIFF. (O)','SITUATION (O)','DRIVE #','DRIVE PLAY #','1ST DN #','D&D','Field Zone','HASH','OFF TEAM','PERS','DEF TEAM','DEF PERSONNEL'] 

feature_importance = gbr.feature_importances_.tolist()

if plotImportance == True:
    f2=plt.figure()
    plt.bar(features,feature_importance)
    plt.title("gradient boosting classifier: feature importance")
    plt.xticks(rotation='vertical')
    plt.show()

predict = gbr.predict(testing_features)
print(predict)