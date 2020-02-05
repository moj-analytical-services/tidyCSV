harmonise <- function(lookup,inputvar,data) {

  # Create the dictionary pairs that will define the harmonisation.

  env<-new.env()
  env[["key"]]<-"value"
  for(i in seq(nrow(lookup)))
  {
    env[[ toString(lookup[i,1]) ]]<- toString(lookup[i,2])
  }

  # Match inputs to harmonised outputs

  renamer <- function(input) {
    output = env[[toString(input)]]
    return(output)
  }

  # Finds the new entries.

  newentries <- dplyr::setdiff(data[[inputvar]],lookup$input)

  # Only harmonises the data if there are no new entries that need to be added to the lookup.
  if(length(newentries)==0){

    #Returns the harmonised data if there are no unrecognised values

    data[[inputvar]] <- lapply(data[[inputvar]], function(x) sapply(x,renamer))
    return(data)
  } else {

    #Print that it couldn't harmonise due to unrecognised values and prints the new entries that exist.

    print("Could not harmonise due to the presence of unknown entries. These are as follows:")
    print(newentries)
  }

}



