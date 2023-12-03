# AAMAS24_98
This folder contains the codes for the paper "Evaluating District-based Election Surveys with Synthetic Dirichlet Likelihood" submitted to AAMAS 2024

The data used for this work is provided in the file electiondata.xlsx

We need to install the 'fastfit' package by Tom Minka, available at:  https://github.com/tminka/fastfit/tree/master

The functions PCM.m and SPM.m are used to run the Partywise Concentration Model and the Seatwise Polarization Model. They need to be provided with the total number of voters, number of seats, overall vote share of the parties and concentration parameters, based on which they will simulate the complete election results (seatwise).

survey.m implements our survey model. It takes as input a complete election result and the survey extent, and it provides a projection of the number of seats that each party may win and total number of votes that each party can get.

dir_posterior_SPM.m and dir_posterior_PCM.m are used to generate candidate outcomes, and estimate their Synthetic Dirichlet posterior likelihood, given the surveys, extent of surveys and Dirichlet Prior Parameters. Extent of surveys include fraction of districts covered and fraction of persons surveyed in each district.

party_performance_dist.m is used to create distributions over possible performance by each party, in terms of vote and seat share, conditioned on the surveys

survey_evaluation_genuine.mat, survey_evaluation_fake.mat and survey_evaluation_malicious.mat are used to estimate the average likelihood ratio of genuine, fake and malicious surveys, conditioned on the actual complete election results.


