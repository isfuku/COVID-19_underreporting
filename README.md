# Estimating COVID-19 underreporting 


I use a GLM of the Poisson family to model the number of hospitalizations due to SARS. The model is fit using data previous to the start of the coronavirus pandemic in Brazil. 
I account for seasonality. As a covariate, I use the number of SARS hospitalizations due to Flu. This has great correlation with the number of hospitalization, so it works as
a good counterfactual!

The model is used to make predictions about the number of SARS hospitalizations post-pandemic. The difference between the number of hospitalizations and the prediction is an 
estimate for the number of seveare COVID-19 cases, as shown in the plot below:

<img src="ts_plot.png" alt="impact_plot"/>

This analysis indicates a great underreporting. The analysis is also made disagreggated by state. The results are summarised
in my [Kaggle Notebook](https://www.kaggle.com/ianfukushima/estimate-covid-19-based-on-sars-hospitalizations).
