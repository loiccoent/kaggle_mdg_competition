# data manipulation and modeling
import numpy as np
import pandas as pd
import statsmodels.api as sm

# graphix
import matplotlib.pyplot as plt
import prettyplotlib as pplt
import seaborn as sns
import statsmodels.graphics.tsaplots as tsaplots

# utility
import os

# notebook parameters
pd.set_option('display.max_columns', 40) # number of columns in training set
plt.rcParams['figure.figsize'] = (14.0, 8.0)

# DIGGING INTO THE DATA

training_data = pd.read_csv("data/TrainingSet.csv", index_col=0)
submission_labels = pd.read_csv("data/SubmissionRows.csv", index_col=0)

training_data.head()
submission_labels.head()

training_data.loc[559]

prediction_rows = training_data.loc[submission_labels.index]
prediction_rows = prediction_rows[generate_year_list(1972, 2007)]

prediction_rows.head()

# grab a random sample of 10 of the timeseries
np.random.seed(896)
rand_rows = np.random.choice(prediction_rows.index.values, size=10)

# plot the randoms rows selected
plot_rows(prediction_rows, ids=rand_rows)

# MAKING A SIMPLE MODEL

def simple_model(series):
    point_2007 = series.iloc[-1]
    point_2006 = series.iloc[-2]
    
    # if just one point, status quo
    if np.isnan(point_2006):
        predictions = np.array([point_2007, point_2007])
    else:
        slope = point_2007 - point_2006
        # one year
        pred_2008 = point_2007 + slope
        # five years
        pred_2012 = point_2007 + 5*slope
        # both years
        predictions = np.array([pred_2008, pred_2012])

    ix = pd.Index(generate_year_list([2008, 2012]))
    return pd.Series(data=predictions, index=ix)
        
# let's try just these predictions on the first five rows
test_data = prediction_rows.head()
test_predictions = test_data.apply(simple_model, axis=1)

# combine the data and the predictions 
test_predictions = test_data.join(test_predictions)

# let's take a look at 2006, 2007, and our predictions
test_predictions[generate_year_list([2006, 2007, 2008, 2012])]

# make the predictions
predictions = prediction_rows.loc[rand_rows].apply(simple_model, axis=1)

# plot the data
plot_rows(prediction_rows, ids=rand_rows)

# plot the predictions
plot_rows(predictions, linestyle="--", legend=False)
    
simple_predictions = prediction_rows.apply(simple_model, axis=1)
write_submission_file(simple_predictions, "Getting Started Benchmark.csv")

# STARTING TO THINK ABOUT CORRELATIONS

kenya_data = training_data[training_data["Country Name"] == 'Kenya']
kenya_values = kenya_data[generate_year_list(1972, 2007)].values

# get the total number of time series we have for Kenya
nseries = kenya_values.shape[0]

# -1 as default
lag_corr_mat = np.ones([nseries, nseries], dtype=np.float64)*-1

# create a matrix to hold our lagged correlations
for i in range(nseries):
    for j in range(nseries):
        # skip comparing a series with itself
        if i!=j:
            # get original (1972-2006) and shifted (1973-2007)
            original = kenya_values[i,1:]
            shifted = kenya_values[j,:-1]

            # for just the indices where neither is nan
            non_nan_mask = (~np.isnan(original) & ~np.isnan(shifted))

            # if we have at least 2 data points
            if non_nan_mask.sum() >= 2:
                lag_corr_mat[i,j] = np.correlate(original[non_nan_mask], shifted[non_nan_mask])
                
# let's look at one of the indicators we are suppoed to predict
to_predict_ix = 131042 

# first, we get the index of that row in the correlation matrix
i = np.where(kenya_data.index.values == to_predict_ix)[0][0]

# then, we see which value in the matrix is the largest for that row
j_max = np.argmax(lag_corr_mat[i,:])

# finally, let's see what these correspond to
max_corr_ix = kenya_data.index.values[j_max]

# now write out what we've found
fmt_string = "In Kenya, the progress of '{}' is most correlated with a change in '{}' during the year before."
    
fmt_string.format(kenya_data["Series Name"][to_predict_ix], kenya_data["Series Name"][max_corr_ix])
