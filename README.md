# MEG Data Classification for Dementia Diagnosis

## Project Overview

This project aims to diagnose dementia at its early stages using magnetoencephalography (MEG) data. Given the chronic and progressive nature of dementia and the limited effectiveness of pharmacological treatments, early diagnosis is crucial for effective intervention and slowing the disease's progression. MEG, being a non-invasive and quick clinical examination tool, offers a promising avenue for early detection through the analysis of brain activity.

More info about this project on the [challenge page](https://biomag2020.org/awards/data-analysis-competitions/)

### Objective

The goal is to classify MEG datasets into one of three classes: control (healthy), mild cognitive impairment (MCI), and dementia. The classification leverages MEG data recorded from individuals across these three groups.

## Dataset

- You can download the dataset [here](https://app.box.com/s/x8bbn3267hr5kl70bv8vvemdc8s0x0og). Make sure you place `training' and `test` folders in the root directory of the project.
  The dataset includes MEG data from two different sites, recorded with a 160-channel gradiometer system at a sampling rate of 1000Hz for Site A and 2000Hz for Site B. Each data set includes age and gender information, and for training data, the Mini-Mental State Exam (MMSE) score is provided.

## Feature Extraction

Feature extraction is performed through a MATLAB script, `extract_features.m`, which applies band-pass filtering and computes the spectral power within the specified frequency bands. The extracted features, along with demographic information, are saved in a two CSV files `train_extracted_features.csv` and `test_extraced_features.csv`.

Spectral power is computed for the following frequency bands:

- Delta (1-4 Hz)
- Theta (4-8 Hz)
- Alpha (8-13 Hz)
- Beta (13-30 Hz)
- Gamma (30-40 Hz)

## Machine Learning Model

A Random Forest classifier is employed for the task, with hyperparameter tuning performed via GridSearchCV within a KFold cross-validation scheme. The process aims to optimize the model's performance given the small and imbalanced nature of the dataset.

## Usage

### Feature Extraction

1. Place the MEG data in the respective directories (`./training/mci`, `./training/control`, `./training/dementia`).
2. Run the `extract_features.m` script in MATLAB to generate the features CSV file.

### Consolidate Data

Run the `build_df.ipynb` notebook to consolidate the features CSV file with the demographic information from `hokuto_profile.xlsx`

### Model Training

Run the random_forest_prediction.ipynb notebook to train the model and make predictions on the test set.

## Dependencies

run `pip install -r requirements.txt` to install the required packages.
