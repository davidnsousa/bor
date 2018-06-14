#' countb
#'
#' countb takes a data frame of field behavior observations of dyadic social interactions and returns interaction countings for each dyad x behavior x observer.
#'
#' @param x A data frame with 7 columns: the 1st column indicating the subject under observation and the 2nd the interaction partner (if a partner exists, otherwise NA), the 3rd indicating the sender (with 1 refering to id1 and 0 to id2), the 4th the behavior observed, the 5th no ocurrences (taking the value 1 or NA otherwise), the 6th missing subjects (taking the value 1 or NA otherwise) and 7th the observer id.
#'
#' @return countb returns a list of observers, each with a list of behaviors, each with a data frame with interaction countings for each dyad, with row subjects indicating senders and column subjects indicating receivers. All characters are changed to lower case and any white spaces are removed.
#' @export
#'
#' @examples
#'
#'  ## Considering ex_field_data, count the number of positive and negative interactions between the various subjects S1, s2, ..., s9 observed by observers 1 and 2. But first converting the raw data to suitable form of input for countb()
#'  bset <- c("+","-")
#'  input <- dtable(ex_field_data, bset)
#'  observations <- countb(input)

countb <- function(x){

# lower case all characters and remove white space characters
  x <- apply(x, 2 , function(x) tolower(x))
  x <- as.data.frame(apply(x, 2 , function(x) gsub(' ', '', x)), stringsAsFactors = FALSE)
  x <- setNames(x,c("id1","id2","sender_id1","behavior","no_ocurrence","missing","observer"))
# determine subjects identfication codes
  ids <- sort(union(unique(x$id1),unique(x$id2)))
# determine observers identfication codes
  obs <- sort(unique(x$observer))
# determine set of behaviors
  bset <- sort(unique(x$behavior))
# determine the number of subjects
  l <- length(ids)
# initialize empty list to fill with nested lists, one for each observer,
# containing a set of data frames corresponding to the various behaviors observed
  outL <- list()
# observers cycle
  for (o in obs){
  # subset data for the current observer
    dto <- subset(x, observer == o)
  # initialize list for the current observer
    obsL <- list()
  # behaviors cycle
    for (b in bset){
    # subset data for the current behavior
      dtob <- subset(dto, behavior == b)
    # initialize matrix for the current behavior
      m <- matrix(0, nrow = l, ncol = l, dimnames = list(ids, ids))
    # for cycle over data subset dtob
      for (i in 1:dim(dtob)[1]){
      # evalute who is sender and who is receiver based on sender_id1
      # if sender_id1 = 1, id1 is the sender and id2 the receiver
      # if sender_id1 = 0, id2 is the sender and id1 the receiver
        if (dtob$sender_id1[i] == 1){
          sender <- dtob$id1[i]
          receiver <- dtob$id2[i]
        }
        else {
          sender <- dtob$id2[i]
          receiver <- dtob$id1[i]
        }
      # count
        m[sender, receiver] <- m[sender, receiver] + 1
      }
    # store data frame of current behavior countings
      obsL[[b]] <- as.data.frame(m)
    }
  # store list of data frames of current observer
    outL[[o]] <- obsL
  }
  outL
}

