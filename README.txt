%%
Some functions (tACSChallenge_AnalyseData.m and functions in the zipped function folder) were originally written by Benedikt Zoefel, CNRS Toulouse, in October 2021.
Part of the functions was adapted by Yifan Shen, in July and August 2025.

To run the anlaysis, please firstly unzip the function folder and add it into Matlab Path,
   
The introduction of the function:       

function [paf,psd,f] = IAF_estimate(data_path,labnum,subnum)

Input: data_path: the path where we store the Data, e.g.,'Z:\Data'
       labnum: ID of the lab, must be numeric
       subnum: ID of the subject, must be numeric

Output: paf: peak alpha frequency
           where paf(1) is the PAF of pre eyes-closed EEG recording
                 paf(2) is the PAF of pre eyes-open EEG recording
                 paf(3) is the PAF of post eyes-closed EEG recording
                 paf(4) is the PAF of post eyes-open EEG recording


        psd: Power spectral density 
           psd(1,:) is the PSD of pre eyes-closed EEG recording
           psd(2,:) is the PSD of pre eyes-open EEG recording
           ...
           psd(4,:) is the PSD of of post eyes-open EEG recording             

        f: frequencies corresponding to PSD 


The function primarily uses another function named 'restingIAF' (from Corcoran, 2018, Psychophysiology) to estimate IAFs,
so please add 'restingIAF-master' (and 'eeglab') to the matlab path first.

 
-------------------------------------------------------------------------------------------------------------------------

There is also a script called analysis_pipeline in this folder that performs nearly the entire analysis process.

Importantly, analysis_pipeline generates summary tables that are well-suited for mixed-effects model fitting. Specifically, it outputs:

  1. Meta_summary.csv – A summary of metadata for each participant.

  2. trial_summary.csv – Trial-level data including hit/miss outcomes, reaction times (RT), IAF, condition sequence, and other relevant variables.

  3. regression_summary.csv – Regression coefficients for each participant under each condition, along with IAF, condition sequence, and other relevant variables.










