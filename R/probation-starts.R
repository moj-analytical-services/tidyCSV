#' Convert a Probation Starts CSV to Tidy format data frame
#'
#' @param file Path to the input file (CSV)
#'
#' @return A data frame of the input file in Tidy format
#' @export
probationStarts <- function(file) {

  # Read in the data, specifying the rows and columns to keep and variable names.
  # Skip the first two lines which contain notes on the file.

  data <- read.csv(file,skip=3,stringsAsFactors = FALSE)
  data <- data[1:5]
  names(data) <- c("nps_region","supervision_type","sex","date","value")

  # Convert date format and add extra varaibles describing the value column.

  data <- within(data, {
    start_date <- as.Date(paste0("1-",str_sub(date,1,3),"-",str_sub(date,9,12)),format = "%d-%b-%Y")
    end_date <- as.Date(paste0("1-",str_sub(date,5,7),"-",str_sub(date,9,12)),format = "%d-%b-%Y")
    lubridate::day(end_date) <- lubridate::days_in_month(end_date)
    value_description <- "Offenders starting supervision by the Probation Service"
    value_type <- "count"
  })

  # Use the two lookups stored in data/sysdata.rda to add additional detail.
  # Includes geographic codes and supervision types that are inconsistent between years.

  lookup <- tidyCSV::probation_areas[,3:5]

  data <- merge(data,lookup,by="nps_region")

  lookup <- tidyCSV::supervision_types

  data <- merge(data,lookup,lookup,by.x="supervision_type",by.y="supervision_type_input",
                suffixes=c("_old","_new"))

  # Keep the final variable set.

  data <- dplyr::select(data,start_date,end_date,nps_region,CTRY18CD,CTRY18NM,
                 sex,supervision_type = supervision_type_new,value_description,value_type,value)

  return(data)

}
