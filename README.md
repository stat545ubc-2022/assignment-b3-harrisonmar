# Assignment B3 Harrison Mar

## Assignment Information

Option A: Modifying BCL Shiny App started in class

## Updates to BCL App

I made a number of changes to the basic version of the BCL app which include the following:

- **Shiny Dashboard** : changed the layout/appearance of the initial shiny app to a shiny dashboard containing a Dashboard/Homepage tab, Charts tab, and Table tab
- **Aesthetics** : changed the colour pallet of the shiny dashboard from the default colour scheme
- **Title and Image** : Added a title to the dashboard page which is clickable and takes users to the BCL website. Also included a small image in the header/title as well
- **Dropdown Menu** : Added a dropdown widget feature to the control panel in the Charts tab which allows users to filter for country on top of the initial price and beverage type filters
- **Interactive Data Table** : Used the DT package to create an interactive data table located in the Table tab which allows users to use keyword search and order columns in ascending or descending order

The running instance of the Shiny App can be found here:

https://harrisonmar.shinyapps.io/assignment-b3-harrisonmar/

The original data for this app can be found here:

https://github.com/daattali/shiny-server/tree/master/bcl

## Repository Files

- **README** : overview of app and repository contents
- **app.R** : code for operational shiny app
- **bcl-data.csv** : original data file 
- **www** : contains image used in dashboard title header
- **rsconnect** : file for deploying app on shinyapps.io
- **.gitignore** : indicates which files git should ignore when committing and pushing
- **.Rproj** : details the project settings and is a shortcut for opening the project directly from the filesystem
