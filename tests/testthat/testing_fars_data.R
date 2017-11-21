context('reading and summarizing data')

test_that('Simple test', {
  testthat::expect_that(make_filename(2013), equals("accident_2013.csv.bz2"))
})


test_that("import the fars data", {
  olddir <- getwd()
  file="accident_2013.csv.bz2"
  data_file<-system.file("extdata",file, package = "farsdata")
  setwd(dirname(data_file))
  dat<-fars_read(file)
  setwd(olddir)
  expect_that(dat, is_a('tbl_df'))
  expect_equal(nrow(dat), 30202)
})

