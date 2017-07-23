## get packages ----
library(randomNames)
library(dplyr)
library(tidyr)
library(ggplot2)
library(magrittr)
library(stringr)
#' Simulated data
#'
#' Produces simulated data for two approximately equal sized groups
#'
#' @param n number of males and females
#' @return data frame of simulated data
#' @author Jonathan Tuke <simon.tuke@@adelaide.edu.au>
#' @export
#' @note 2015-08-10
#' @examples
#' simTransport(10)
simTransport <- function(n){
  # Gender
  genders <- c("female", "male")
  df <- data.frame(gender = sample(genders, size = n, replace = TRUE))
  # names
  df$name <- randomNames(gender=df$gender, ethnicity = 'white', which.names = 'first')
  
  # transport: Set women as 1:2 for car:bike & the reverse for men
  transport <- c("car", "bike")
  df <- split(df, f = df$gender)
  df$female$transport <- sample(transport, nrow(df$female), replace = TRUE, prob = c(1, 2)/3)
  df$male$transport <- sample(transport, nrow(df$male), replace = TRUE, prob = c(2, 1)/3)
  df %<>% bind_rows()
  
  # weight: Cyclists should be 4% lighter
  weightMeans <- if_else(df$gender == "female", 65, 80)
  weightMeans[df$transport == "bike"] <- 0.96*weightMeans[df$transport == "bike"]
  weightSds <- if_else(df$gender == "female", 5, 7)
  df$weight <- rnorm(n, weightMeans, weightSds)
  
  # height
  df = df %>% 
    mutate(height = 123.7055 + 
             1*(gender=="Male") + 
             (0.6617 + 0.1*(gender=="Male"))*weight + 
             rnorm(n))
  # Make the car drivers 3% shorter
  df$height[df$transport == "car"] <- 0.98*df$height[df$transport == "car"]
  
  # Randomise
  df <- sample_n(df, size = n)

  return(df)
}
