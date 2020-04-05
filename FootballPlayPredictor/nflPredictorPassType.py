#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 29 22:27:23 2020

@author: noahlefrancois
"""

from sklearn.metrics import accuracy_score
import matplotlib.pyplot as plt
from sklearn import ensemble
import pandas as pd
import numpy as np

plotPie = True
#Load the play data for the desired columns
df = pd.read_csv("pbp-2019.csv")

df = df[['GameId','GameDate','Quarter','Minute','Second','OffenseTeam','DefenseTeam','Down','ToGo','YardLine','Yards','Formation','PlayType','SeriesFirstDown', 'PassType']]
#Compute the time elapsed in the game based on quarter, minute, second data
gameTime = 15*60*df['Quarter'] + 60*df['Minute'] + df['Second']

df['gameTime'] = gameTime

df = df.dropna()

#Separate into training data set (October 2019 games) and testing data set (Remaining 2019 games)
training_df = df[(~df.GameDate.str.contains('2019-10')) & (df.OffenseTeam == 'PIT') & (df.Down.isin(range(1,5))) & (df.PlayType == 'PASS')]

testing_df = df[(df.GameDate.str.contains('2019-10')) & (df.OffenseTeam == 'PIT') & (df.Down.isin(range(1,5))) & (df.PlayType == 'PASS')]

#Find the relative frequency of runs and passes as a baseline to compare our play type prediction to
rel_freq = testing_df['PassType'].value_counts()

if plotPie == True:
    f1=plt.figure()
    plt.pie(rel_freq, autopct='%.2f%%')
    plt.title("Pass Type distribution")
    plt.subplots_adjust(left=0, bottom=0, right=1, top=1, wspace=0, hspace=0)
    plt.show()

"""
#Trying to change 1st play of the drive to down=0
for i in training_df['Down']:
    if ((training_df['Down'][i] == 1) & (training_df['SeriesFirstDown'][i] == 0)):
        training_df['Down'][i] = 0
        
for i in testing_df['Down']:
    if ((testing_df['Down'][i] == 1) & (testing_df['SeriesFirstDown'][i] == 0)):
        testing_df['Down'][i] = 0
"""

#Define the features (input) and label (prediction output)
training_features = training_df[['gameTime','Down','ToGo','YardLine','Formation','SeriesFirstDown']]
#training_features = training_df[['Quarter', 'Minute', 'Second','Down','ToGo','YardLine','Formation','SeriesFirstDown']]

training_label = training_df['PassType']

#testing_features = testing_df[['Quarter', 'Minute', 'Second','Down','ToGo','YardLine','Formation','SeriesFirstDown']]
testing_features = testing_df[['gameTime','Down','ToGo','YardLine','Formation','SeriesFirstDown']]

testing_label = testing_df['PassType']

#Relabel the formation strings to number them so the GBR can read them
formations = training_features['Formation'].unique().tolist()
mapping = dict( zip(formations,range(len(formations))) )
training_features.replace({'Formation': mapping},inplace=True)
testing_features.replace({'Formation': mapping},inplace=True)


#Train a Gradient Boosting Machine on the data
gbr = ensemble.GradientBoostingClassifier(n_estimators = 100, learning_rate = 0.02)

gbr.fit(training_features, training_label)

#Predict the run/pass percentage from our test set and evaluate the prediction accuracy
prediction = gbr.predict(testing_features)

accuracy = accuracy_score(testing_label, prediction)

print("Accuracy: "+"{:.2%}".format(accuracy))

#Determine how strongly each feature affects the outcome
#features = ['Quarter', 'Minute', 'Second','Down','ToGo','YardLine','Formation','SeriesFirstDown'] 
features = ['gameTime','Down','ToGo','YardLine','Formation','SeriesFirstDown'] 

feature_importance = gbr.feature_importances_.tolist()

f2 = plt.figure()
plt.bar(features,feature_importance)
plt.title("gradient boosting classifier: feature importance")
plt.show()

