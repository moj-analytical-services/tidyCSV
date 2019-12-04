#' Convert a Probation Starts CSV to Tidy format
#'
#' @param file Path to the input file (CSV)
#'
#' @return A data frame of the input file in Tidy format
#' @export
probationStarts <- function(file) {

  data <- read.csv(file,skip=3,stringsAsFactors = FALSE)
  data <- data[1:5]
  names(data) <- c("nps_region","supervision_type","sex","date","value")

  data <- within(data, {
    start_date <- as.Date(date,"%d/%m/%Y")
    end_date <- as.Date(date,"%d/%m/%Y")
    value_description <- "Offenders starting supervision by the Probation Service"
    value_type <- "count"
  })

  lookup <- tidyCSV::probation_areas[,3:5]

  data <- merge(data,lookup,by="nps_region")

  lookup <- tidyCSV::supervision_types

  data <- merge(data,lookup,lookup,by.x="supervision_type",by.y="supervision_type_input",
                suffixes=c("_old","_new"))

  data <- dplyr::select(data,start_date,end_date,nps_region,CTRY18CD,CTRY18NM,
                 sex,supervision_type = supervision_type_new,value_description,value_type,value)

  return(data)

}
