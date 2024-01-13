#### Data visualisation functions ####

#plot bar function
plot_bars <- function(df, cat_cols){
  options(repr.plot.width = 4, repr.plot.height = 3.5) #set the initial plot area dimensions
  for(col in cat_cols){
    p = ggplot(df, aes_string(col)) +
      geom_bar(alpha = 0.6) +
      theme(axis.text.x = element_text(size = 15, angle = 45, hjust = 1),
            axis.title.x = element_text(size = 15),
            axis.title.y = element_text(size = 15),
            axis.text.y = element_text(size = 15),
            legend.title = element_text(size= 15),
            legend.text = element_text(size = 15))
    print(p)
  }
}

#plot box function
plot_box <- function(df, col_y, cat_cols){
  options(repr.plot.width = 4, repr.plot.height = 3.5) #set the initial plot area dimensions
  for(col in cat_cols){
    p = ggplot(df, aes_string(col, col_y)) +
      geom_boxplot() +
      theme(axis.text.x = element_text(size = 15, angle = 45, hjust = 1),
            axis.title.x = element_text(size = 15),
            axis.title.y = element_text(size = 15),
            axis.text.y = element_text(size = 15),
            legend.title = element_text(size= 15),
            legend.text = element_text(size = 15))
    print(p)
  }
}

#plot violin function
plot_violin <- function(df, col_y, cat_cols, bins = 30){
  options(repr.plot.width = 4, repr.plot.height = 3.5) #set the initial plot area dimensions
  for(col in cat_cols){
    p = ggplot(df, aes_string(col, col_y)) +
      geom_violin() +
      theme(axis.text.x = element_text(size = 15, angle = 45, hjust = 1),
            axis.title.x = element_text(size = 15),
            axis.title.y = element_text(size = 15),
            axis.text.y = element_text(size = 15),
            legend.title = element_text(size= 15),
            legend.text = element_text(size = 15))
    print(p)
  }
}

#plot hist function
plot_hist <- function(df, num_cols, bins = 10){
  options(repr.plot.width = 4, repr.plot.height = 3.5) #set the initial plot area dimensions
  for(col in num_cols){
    bw = (max(df[,col]) - min(df[,col]))/(bins + 1)
    p = ggplot(df, aes_string(col)) +
      geom_histogram(alpha = 0.6, binwidth = bw)
    print(p)
  }
}

#plot kde function
plot_dist <- function(df, num_cols){
  options(repr.plot.width = 4, repr.plot.height = 3.5) #set the initial plot area dimensions
  for(col in num_cols){
    p = ggplot(df, aes_string(col)) +
      geom_density(color= 'blue') +
      geom_rug(na.rm = TRUE)
    print(p)
  }
}

#plot combo kde hist function
plot_hist_dens <- function(df, num_cols, bins = 10){
  options(repr.plot.width = 4, repr.plot.height = 3.5) #set the initial plot area dimensions
  for(col in num_cols){
    bw = (max(df[,col]) - min(df[,col]))/(bins + 1)
    p = ggplot(df, aes_string(col)) +
      geom_histogram(alpha = 0.5, binwidth = bw, aes(y=..density..)) +
      geom_density(aes(y=..density..),color= 'blue') +
      geom_rug()
    print(p)
  }
}

#plot combo kde hist facet function
plot_hist_dens_facet <- function(df, facet, num_cols, bins = 10){
  options(repr.plot.width = 4, repr.plot.height = 3.5) #set the initial plot area dimensions
  for(col in num_cols){
    bw = (max(df[,col]) - min(df[,col]))/(bins + 1)
    p = ggplot(df, aes_string(col)) +
      geom_histogram(alpha = 0.5, binwidth = bw, aes(y=..density..)) +
      geom_density(aes(y=..density..),color= 'blue') +
      geom_rug() +
      facet_grid(. ~df[[facet]])
    print(p)
  }
}

#plot scatter function
plot_scatter <- function(df, col_y, shape, color, num_cols, alpha = 1){
  options(repr.plot.width = 4, repr.plot.height = 3.5) #set the initial plot area dimensions
  for(col in num_cols){
    p = ggplot(df, aes_string(col, col_y)) +
      geom_point(aes(shape = factor(df[[shape]]), color = factor(df[[color]])), alpha = alpha) +
      print(p)
  }
}

#plot scatter grid function
plot_scatter_grid <- function(df, col_y, facet1, facet2, color, num_cols, alpha = 1){
  options(repr.plot.width = 4, repr.plot.height = 3.5) #set the initial plot area dimensions
  for(col in num_cols){
    p = ggplot(df, aes_string(col, col_y)) +
      geom_point(aes(color = factor(df[[color]])), alpha = alpha) +
      facet_grid(df[[facet1]] ~ df[[facet2]])
    print(p)
  }
}

#plot 2D density function
plot_2D_density <- function(df, col_y, shape, color, num_cols, alpha = 1){
  options(repr.plot.width = 4, repr.plot.height = 3.5) #set the initial plot area dimensions
  for(col in num_cols){
    p = ggplot(df, aes_string(col, col_y)) +
      geom_density_2d() +
      geom_point(aes(shape = factor(df[[shape]]), color = factor(df[[color]])), alpha = alpha) +
      print(p)
  }
}

#pair plot function
plot_pair <- function(df, color, num_cols, alpha = 0.1){
  options(repr.plot.width = 6, repr.plot.height = 6) #set the initial plot area dimensions
  p = ggpairs(df, 
              columns = num_cols,
              aes(color = factor(df[[color]]), alpha = alpha),
              lower = list(continuous = 'points'),
              upper = list(continous = wrap(ggally_density,  alignPercent = 1, size = 15))) + 
    theme(text = element_text(size = 15))
  print(p)
}