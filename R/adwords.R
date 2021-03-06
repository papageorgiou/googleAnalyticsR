#' Get AdWords Link meta data
#'
#' @param accountId Account Id
#' @param webPropertyId Web Property Id
#' @param webPropertyAdWordsLinkId AdWords Link Id
#'
#' @return AdWords Meta data
#' @importFrom googleAuthR gar_api_generator
#' @family managementAPI functions
#' @export
ga_adwords <- function(accountId,
                       webPropertyId,
                       webPropertyAdWordsLinkId){
  
  url <- "https://www.googleapis.com/analytics/v3/management/"
  adwords <- gar_api_generator(url,
                               "GET",
                               path_args = list(
                                 accounts = accountId,
                                 webproperties = webPropertyId,
                                 entityAdWordsLinks = webPropertyAdWordsLinkId
                               ),
                               data_parse_function = function(x) x)
  
  adwords()
  
}

#' List AdWords
#'
#' @param accountId Account Id
#' @param webPropertyId Web Property Id
#'
#' @return AdWords Links
#' @importFrom googleAuthR gar_api_generator
#' @family managementAPI functions
#' @export
ga_adwords_list <- function(accountId,
                            webPropertyId){
  
  url <- "https://www.googleapis.com/analytics/v3/management/"
  adwords <- gar_api_generator(url,
                               "GET",
                               path_args = list(
                                 accounts = accountId,
                                 webproperties = webPropertyId,
                                 entityAdWordsLinks = ""
                               ),
                               data_parse_function = parse_ga_adwords_list)
  
  pages <- gar_api_page(adwords, page_f = get_attr_nextLink)
  
  Reduce(bind_rows, pages)
  
}

#' @noRd
#' @import assertthat
#' @importFrom dplyr bind_rows select
parse_ga_adwords_list <- function(x){
  
  aaa <- Reduce(bind_rows, x$items$adWordsAccounts)
  o <- x %>% 
    management_api_parsing("analytics#entityAdWordsLinks") %>% 
    cbind(aaa) %>% 
    select(-adWordsAccounts, -entity.webPropertyRef.kind, -entity.webPropertyRef.href, -kind)
  
  if(is.null(o)){
    return(data.frame())
  }
  
  o

}
