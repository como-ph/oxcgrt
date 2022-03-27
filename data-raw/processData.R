## Libraries
library(xml)
library(dplyr)
library(rvest)
library(stringr)
library(tibble)

## Codebook
codebook <- xml2::read_html("https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md") %>%
  rvest::html_nodes(css = ".markdown-body table") %>%
  rvest::html_table() %>%
  dplyr::bind_rows() %>%
  dplyr::mutate(`Policy Group` = c(rep("Containment and closure policies", 15),
                                   rep("Economic policies", 5),
                                   rep("Health system policies", 12),
                                   rep("Vaccination policies", 14),
                                   "Miscellaneous policies"),
                ID = stringr::str_split(string = Name, pattern = "_", simplify = TRUE)[ , 1],
                Coding = stringr::str_replace_all(string = Coding, pattern = " 0", replacement = "; 0" ),
                Coding = stringr::str_replace_all(string = Coding, pattern = " 1", replacement = "; 1" ),
                Coding = stringr::str_replace_all(string = Coding, pattern = " 2", replacement = "; 2" ),
                Coding = stringr::str_replace_all(string = Coding, pattern = " 3", replacement = "; 3" ),
                Coding = stringr::str_replace_all(string = Coding, pattern = " 4", replacement = "; 4" ),
                Coding = stringr::str_replace_all(string = Coding, pattern = " Blank", replacement = "; Blank")) %>%
  tibble::tibble()

usethis::use_data(codebook, overwrite = TRUE, compress = "xz")

## Example data
x <- xml2::read_html("https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/index_methodology.md") %>%
  rvest::html_elements(css = ".markdown-body table") %>%
  rvest::html_table()

indicatorData <- x[[3]][1:16, ]
names(indicatorData) <- c("indicator", "value", "flag_value", "", "max_value", "flag", "", "score")

indicatorData <- indicatorData %>%
  dplyr::select(indicator:flag_value, max_value:flag, score) %>%
  dplyr::mutate(flag = stringr::str_extract_all(string = flag, pattern = "[0-9]"),
                value = as.integer(value),
                flag_value = as.integer(flag_value),
                flag = as.integer(flag)) %>%
  tibble::tibble()

usethis::use_data(indicatorData, overwrite = TRUE, compress = "xz")



