#' Convert a Probation Caseload CSV to Tidy format data frame
#'
#' @param file Path to the input file (CSV)
#'
#' @return A data frame of the input file in Tidy format
#' @export
probationCaseload <- function(file) {

  # Read in the data, specifying the rows and columns to keep and variable names.
  # Skip the first two lines which contain notes on the file.

  data <- read.csv(file,skip=2,stringsAsFactors = FALSE)
  data <- data[1:5]
  names(data) <- c("probation_area","supervision_type","sex","date","value")

  # Convert date format and add extra varaibles describing the value column.

  data <- within(data, {
    start_date <- as.Date(date,"%d/%m/%Y")
    end_date <- as.Date(date,"%d/%m/%Y")
    value_description <- "Offenders supervised by the Probation Service"
    value_type <- "count"
  })

  # Hard code some typos found in published data.

  data$probation_area <- stringr::str_replace(data$probation_area,"SouthYorkshire CRC","South Yorkshire CRC")
  data$probation_area <- stringr::str_replace(data$probation_area,"Kent, Surrey and Sussex CRC DATA CaseloadQ2","Kent, Surrey and Sussex CRC")
  data$probation_area <- stringr::str_replace(data$probation_area,"Gloucetsershire, Avon and Somerset and Wiltshire CRC","Gloucestershire, Avon and Somerset and Wiltshire CRC")
  data$probation_area <- stringr::str_replace(data$probation_area,"Northamptonshire, Bedfordshire, Hertfordshire and Cambridgshire CRC","Northamptonshire, Bedfordshire, Hertfordshire and Cambridgeshire CRC")

  # Use the two lookups stored in data/sysdata.rda to add additional detail.
  # Includes geographic codes and supervision types that are inconsistent between years.

  lookup <- tidyCSV::probation_areas

  data <- merge(data,lookup,by="probation_area")

  lookup <- tidyCSV::supervision_types

  data <- merge(data,lookup,lookup,by.x="supervision_type",by.y="supervision_type_input",
                suffixes=c("_old","_new"))

  # Keep the final variable set.

  data <- dplyr::select(data,start_date,end_date,probation_area,nps_crc,nps_region,CTRY18CD,CTRY18NM,
                 sex,supervision_type = supervision_type_new,value_description,value_type,value)

  return(data)

}
