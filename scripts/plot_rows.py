def plot_rows(data, ids=None, linestyle="-", legend=True):
    # get some colors for the lines
    bmap = pplt.brewer2mpl.get_map('Set3','Qualitative', 10)
    colors = bmap.mpl_colors
    
    if not ids is None:
        get_rows = lambda: enumerate(ids)
    else:
        get_rows = lambda: enumerate(data.index.values)
    
    for i, r in get_rows():
        # get the time series values
        time_data = data.loc[r]

        # create an x axis to plot along
        just_years = [y[:4] for y in data.columns]
        X = pd.DatetimeIndex(just_years)

        # get time series info for labeling
        country, descrip = training_data[["Country Name", "Series Name"]].loc[r]

        # plot the series
        plt.plot(X, 
                 time_data, 
                 c=colors[i],
                 label="{} - {}".format(country, descrip), 
                 ls=linestyle)
        plt.scatter(X, 
                    time_data, 
                    alpha=0.8,
                    label=None,
                    c=colors[i])

    if legend:
        plt.legend(loc=0)
    plt.title("Progress Towards Subset of MDGs")