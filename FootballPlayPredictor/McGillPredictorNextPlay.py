#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 29 22:27:23 2020

@author: Noah LeFrancois
@email: noah.lefrancois@mail.mcgill.ca

Will update changes made to McGillPredictorEx here once validated, want to keep this file 
clean since it will be the end-product

Using data for each play in Con U's 2019 season (obtained from Hudl), we want to predict 
their play selection (run/pass, play type, zones targeted) on the next play given input info 
such as clock, field position, personnel, down&distance, defensive formation, etc. 

Here we use the first 7 games of their season to train the model, and test its predictions in
the final game of their season. Eventually, I'd like to update our model with each new play. 

We're going to take user input for the features of the upcoming play and predict the next play

"""

from sklearn.metrics import accuracy_score
import matplotlib.pyplot as plt
from sklearn import ensemble
import pandas as pd
import numpy as np

plotPie = False
#Load the play data for the desired columns into a dataframe
df = pd.read_csv("pbp-2019.csv")

#Get the variables we care about from the dataframe

#PlayType is (run, dropback, play-action, etc), PlayZone is target location of pass or run (str Flats, wk off-tackle, etc)
df = df[['GameId','GameDate','Quarter','Score','Situation','OffenseTeam','DefenseTeam','Down','ToGo','YardLine','SeriesFirstDown','Personnel','Formation','Yards','PlayType','PlayZone']]

df = df.dropna()

#I'd like to compute the yards gained, play type, and result from the previous play and add them as an input for the current play
#df['prevYards'] = prevYards
#df['prevPlayType'] = prevPlayType
#df['prevPlayResult'] = prevPlayResult

#Select the training data set (Con U 2019 Games 1-7)
training_df = df[(~df.GameId.str.contains('Game 8')) & (df.OffenseTeam == 'ConU') & (df.Down.isin(range(1,4)))]

#Define the features (input) and label (prediction output) for training set
#Formation could be an input or output
training_features = training_df[['Quarter','Situation','Score','Down','ToGo','YardLine','SeriesPlays','Personnel','Formation']]

#Could predict any of these outputs:
#'Formation','Yards','PlayType','PlayZone'
training_label = training_df['PlayType']

#Relabel the formation strings to number them so the GBR can read them
formations = training_features['Formation'].unique().tolist()
mapping = dict( zip(formations,range(len(formations))) )
training_features.replace({'Formation': mapping},inplace=True)

#Train a Gradient Boosting Machine on the data
gbr = ensemble.GradientBoostingClassifier(n_estimators = 100, learning_rate = 0.02)

gbr.fit(training_features, training_label)

#Give a set of features for the next play and predict the outcome
#We probably want to take user input to fill out nextPlayFeatures
nextPlayFeatures = [4,'2Min','-7','2','mid','43','6','15','32']
#Relabel the feature strings with a numerical mapping
nextPlayFeatures.replace({'Formation': mapping},inplace=True)

#Output the prediction
predNextPlay = gbr.predict(nextPlayFeatures)
print("Most likely next play:" + predNextPlay)


#Determine how strongly each feature affects the outcome and graph it

features = ['Quarter','Situation','Score','Down','ToGo','YardLine','SeriesPlays','Personnel','Formation'] 
feature_importance = gbr.feature_importances_.tolist()

plt.bar(features,feature_importance)
plt.title("Relative Feature Importance")
plt.show()

