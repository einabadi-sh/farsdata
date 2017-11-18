#' Import CSV into a data frame tbl.
#'
#' This is a simple function that, by default, is useful for reading the fars data
#' the fars is a data set from the US National Highway Traffic Safety Administration's Fatality Analysis
#' Reporting System, which is a nationwide census providing the American public yearly data regarding
#' fatal injuries suffered in motor vehicle traffic crashes
#'
#' @param filename the name of the file which the data are to be read from
#'
#' @return A data frame (tbl) containing a representation of the data in the file.
#'
#' @examples
#' \dontrun{
#' fars_read("accident_2013.csv")
#' }
#'
#' @importFrom "readr" "read_csv"
#'
#' @importFrom "dplyr" "tbl_df"
#'
#' @export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}
#' fars file name creation
#'
#' Making the file name of a fars data according to the year of occurence
#'
#' @param year an integer indicates the year of the fars file
#'
#' @return a string which indicates the file name of the fars data
#'
#' @examples
#' \dontrun{
#' make_filename(2013)
#' }
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}
#' reading fars data according to years
#'
#' This function read the fars data of a specific year and select only month and year of the accident
#'
#' @param years a vector of integer indicates the year of the fars file
#'
#' @return a list of data frame(tibble), each component of the list contains a tibble with two columns
#'    of MONTH and year of the accident
#'
#' @examples
#' \dontrun{
#' fars_read_years(c(2013, 2014))
#' }
#'
#' @importFrom "dplyr" "mutate" "select" "%>%"
#'
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' fars data summary
#'
#' This function read the fars data of a specific year and summarize the data in a tibble,
#'   this data frame has 12 rows for month, and one column for each year. In each cell you can
#'   find the number of the accident in that YEAR, MONTH.
#'
#' @param years a vector of integer indicates the year of the fars file
#'
#' @return a data frame(tibble) with 12 rows and one column for each year
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(c(2013, 2014))
#' }
#'
#' @importFrom "dplyr" "bind_rows" "group_by" "summarize"
#'
#' @importFrom "tidyr" "spread"
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' plotting the location of accidents
#'
#' This function read the fars data of a specific year and state then and then try to plot the
#'   location of the accident in that state and year.
#'
#' @param state.num an integer which indicates one state of US
#' @param year an integer indicates the year of the fars file
#'
#' @return NULL, just plot the points of the fars data accident
#'
#' @importFrom "dplyr" "filter"
#'
#' @importFrom 	"maps" "map"
#'
#' @importFrom "graphics" "points"
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(33 , 2013)
#' }
#'
#' @export

fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
