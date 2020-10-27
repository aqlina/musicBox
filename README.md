
# musicBox

<!-- badges: start -->
<!-- badges: end -->

The goal of musicBox package is to provide the User with easy-to-run Shiny App. The App contains 2 tabs per one functionality each: add own values to Postgres "musicianbox-db" database connected to the App (reactive update of the changed table) and show relations between musicians and bands. Postgres database containes 3 tables 'musicians', 'bands' and 'events' and one view 'prepared_events'. The tables are connected with each other with their primary key (*id* column). Database main assumption: all tables have unique naming (there are no two musicians with the same full name).

## Installation and Running

You can install the released version of musicBox from [GitHub](https://github.com/) with:

``` r
remotes::install_github('aqlina/musicBox@master', dependencies = 'Imports')

```

Or you can use Docker for setting up containers with Postgres database and Shiny App for you.
For doing so you have to:
- download 'Docker_settings' folder
- change directory to that folder location
- build an image and run containers by writing *'docker-compose up'* in the command prompt/Docker
- wait till environment will be set up
- go to your browser **'http://0.0.0.0:9999'**
- enjoy the App :)

## Example

This is a basic example:

```{r example}
library(musicBox)
musicBox::launch_app()
```
Please notice, launch_app() uses specified host and ports values. What's more, you need to set up Postgres database and pass environmental variables (DB_HOST, DB_PORT, DB_DATABSE, etc) by your own if you want to launch the app inside an R. 
**The better and much easier way is to use Docker (see instructions above).**

## Justifying used technologies

1. **R/Shiny**: they are both very powerful tools for creating applications, especially, the App using statistics or analytics behind.
2. **Docker:** helps to set up environment easily; it creates isolated container and environment for the App, therefore, makes the App compatible with all other operating systems and no conflicts are possible.
3. **Git:** allows to control any change in the code; prevents a developer from loosing the code, even if the local machine will crash; makes the work on the code with the team members much easier; allows to always have a working/production version of the App and continue working on new functionalities.
4. **Postgres DB:** Database is the best way to store the data: it controls the uniqueness of records; prevents form deleting tables which are connected to other; prevents from adding data of wrong type; speed up extraction the data, therefore, the  processing the data.
5. **tidyr, dplyr:** the most convenient way of preparing the data (combining string naming within usual naming); helps with better readability of the R code.
6. **stringr, stringi:** very useful and intuitive libraries for working with string in R.
7. **devtools**: this is the best way of creating package because it builds all the files needed, controls test checks, controls imported libraries, controls documentation completeness with the human-friendly communicates.
8. **roxygen2:** helps to create very nice documentation with all necessary sections, translates R codes to .md format, so a developer doesn't need to switch R with other format.
9. **package:** package is the best way for sharing the codes and documentation, therefore, make the maintenance of the codes much easier. Even, if you share it with the future you :)
10. **testhat:** great and intuitve tool for writing automated tests for the package or an App and it is fully compatible with devtools.
11. **Visual Code Studio:** great tool for using R and git simultaneously; makes it easy to see the changes made and selective commiting.


## The sky is a limit

Some of the future App development options:

- While creating this App I mostly focused on implementing functionalities, so the App's appearance is ordinary. It is possible to use theme from *shinythemes* library for lazy design or CSS for cooler, custom App designs if time allows.

- The tests I implemented are covering only some of the functionality: 1. the correctness of data input; 2. the most important function (~ only 30% of functionality). For sure, it is not enough when it comes to real-life projects where much more tests must be implemented. Moreover, the tests must also cover UI part (optionally with *golem* library which helps to control html output). As an option, more advanced testing can be applied for that purpose using *RSelenium* library, the library which behaves as a user scrolling the webpage.

- When it comes to checking User's input and giving the User tips for providing data correctly, only fundamental checks were implemented. There are still some ways the User can destroy the App :) For example, inputting numbers in the names/surnames will not cause an error, but will look unappropriately.
