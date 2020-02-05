#' Convert an Adjudications CSV to Tidy format data frame
#'
#' @param file Path to the input file (CSV), year
#'
#' @return A data frame of the input file in Tidy format
#' @export

tidy <- function(file,year){

  # Load required libraries



  # Load external functions

  source("harmoniseFunc.R")

  # Import files based on whether they are in csv or xlsx format

  if(stringr::str_detect(file, ".csv")) {
    data <- read.csv(file, stringsAsFactors = FALSE)
  } else if(stringr::str_detect(file, ".xlsx")) {
    data <- openxlsx::read.xlsx(file)
  }

  # Read in lookup files to convert values

  sex <- read.csv("Sex.csv", stringsAsFactors = FALSE)
  ethnicity <- read.csv("ethnicity_lookup.csv", stringsAsFactors = FALSE)
  prison <- read.csv("prison_lookup.csv", stringsAsFactors = FALSE)
  ethnicity <- read.csv("ethnicity_lookup.csv", stringsAsFactors = FALSE)
  ethnic_group_broad <- read.csv("ethnic_group_broad_lookup.csv", stringsAsFactors = FALSE)
  prison_code <- read.csv("prison_code_lookup.csv", stringsAsFactors = FALSE)
  start_date <- read.csv("start_date.csv", stringsAsFactors = FALSE)
  end_date <- read.csv("end_date.csv", stringsAsFactors = FALSE)

  # Convert date format to consistent format (some files only include quarter 'Q1', others also include year 'Q12019')

  data$Date <- paste0(data$Date,year)
  data$Date <- stringr::str_sub(data$Date, 1,6)

  # Run harmonise function on each lookup in turn

  harmonised_data <- harmoniseFunc::harmonise(sex,"Sex",data)
  colnames(harmonised_data)[which(names(harmonised_data) == "Sex")] <- "sex"

  harmonised_data <- harmoniseFunc::harmonise(ethnicity,"Ethnicity",harmonised_data)
  colnames(harmonised_data)[which(names(harmonised_data) == "Ethnicity")] <- "ethnic_group"

  harmonised_data <- harmoniseFunc::harmonise(prison,"Establishment",harmonised_data)
  colnames(harmonised_data)[which(names(harmonised_data) == "Establishment")] <- "prison_name"

  harmonised_data$prison_code <- harmonised_data$prison_name
  harmonised_data <- harmoniseFunc::harmonise(prison_code, "prison_code", harmonised_data)

  harmonised_data$start_date <- harmonised_data$Date
  harmonised_data <- harmoniseFunc::harmonise(start_date,"start_date", harmonised_data)

  harmonised_data$end_date <- harmonised_data$Date
  harmonised_data <- harmoniseFunc::harmonise(end_date,"end_date", harmonised_data)

  harmonised_data$ethnic_group_broad <- harmonised_data$ethnic_group
  harmonised_data <- harmoniseFunc::harmonise(ethnic_group_broad,"ethnic_group_broad", harmonised_data)

  # Convert file names

  colnames(harmonised_data) <- stringr::str_to_lower(colnames(harmonised_data))
  names(harmonised_data) <- gsub('\\.', '_', colnames(harmonised_data))

  # Convert harmonisation output to data frame

  harmonised_data <- apply(harmonised_data,2,as.character) %>%
    as.data.frame()

  harmonised_data <- dplyr::select(harmonised_data, -date)

  list <- colnames(harmonised_data)

  if("religion" %in% list){
    column_order <- c("start_date", "end_date", "outcomes", "predominant_function_of_establishment", "prison_name","prison_code", "adjudicator", "sex", "age_group", "ethnic_group","ethnic_group_broad","religion","offence", "detailed_offence", "count")
    harmonised_data$religion <- stringr::str_trim(harmonised_data$religion)
  }
  else {
    column_order <- c("start_date", "end_date", "outcomes", "predominant_function_of_establishment", "prison_name","prison_code", "adjudicator", "sex", "age_group", "ethnic_group","ethnic_group_broad","offence", "count")
  }

  harmonised_data <- harmonised_data[, column_order]

  harmonised_data[] <- lapply(harmonised_data, as.character)
  harmonised_data$count <- as.numeric(harmonised_data$count)

  return(harmonised_data)
}
