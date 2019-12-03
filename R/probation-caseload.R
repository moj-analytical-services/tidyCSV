#' Convert a Probation Caseload CSV to Tidy format
#'
#' @param file Path to the input file (CSV)
#'
#' @return A data frame of the input file in Tidy format
#' @export
probationCaseload <- function(file) {

  data <- read.csv(file,skip=2,stringsAsFactors = FALSE)
  data <- data[1:5]
  names(data) <- c("probation_area","supervision_type","sex","date","value")

  data <- within(data, {
    start_date <- as.Date(date,"%d/%m/%Y")
    end_date <- as.Date(date,"%d/%m/%Y")
    value_description <- "Offenders supervised by the Probation Service"
    value_type <- "count"
  })

  lookup <- tidyCSV::probation_areas

  data <- merge(data,lookup,by="probation_area")

  lookup <- tidyCSV::supervision_types

  data <- merge(data,lookup,lookup,by.x="supervision_type",by.y="supervision_type_input",
                suffixes=c("_old","_new"))

  data <- dplyr::select(data,start_date,end_date,probation_area,nps_crc,nps_region,CTRY18CD,CTRY18NM,
                 sex,supervision_type = supervision_type_new,value_description,value_type,value)

  return(data)

}
