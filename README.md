
## Survey
112 districts, 2005-2012 (8 years).

## Basic design
Show respondents a series of X graphs. The prompt will be:

“On this plot of dengue incidence over time, during what period would you declare an epidemic that would trigger a public health response. Please use the sliders to select the start and end date of the epidemic, or indicate that there was no epidemic that occurred during this period”

On the interface, they will see a single time series plot, with sliders below the plot. They will move the sliders to indicate the start and end date. There will also be a tick box where they can indicate if there is no epidemic during this period that they would respond to.


## Open questions 

Option 1: Show all respondents the same set of 10-20 plots
Option 2: Have a large number of plots (100s), that each have a unique identifier. Show respondents different sets of X plots, drawn from the full set, with overlap between respondents so that each plot is shown to at least Y respondents.

## Analysis

For each respondent, we will have a data frame representing their responses. Respondent ID, plotID, epidemic_indicator, selected_start_date, selected_end_date, incidence_selected_start, incidence_selected_end
