#' countb
#'
#' countb takes a data frame with dyadic social interactions' data (akin to that
#' returned by dtable function) and returns a list of asymetric data matrices-
#' one for each observer and type of social interaction. Each matrix cell
#' provides counts on the number of times a specific type of social interaction
#' was initiated by the row subject and directed to the column subject.
#'
#' @param x A data frame with 7 columns: the 1st column should refer to the
#'   focal subject's identification code (e.g., column named "id1" as in the
#'   output of dtable function); the 2nd column should refer to the
#'   identification code of the interaction partner (e.g., "id2"); the
#'   3rd column (e.g., "sender_id1") should refer whether the focal subject was
#'   the initiator (coded 1) or the target of the social interaction (coded 0);
#'   the 4th column should refer to the type/code of social interaction
#'   recorded; the 5th column (e.g., "no_occurrence") should refer whether no
#'   social interactions were recorded (coded as 1; NA's otherwise); the 6th
#'   column (e.g., "missing") should refer whether the focal subject was
#'   unavailable for observation (coded as 1; NA's otherwise); the 7th columns
#'   (e.g., "observer") should refer to the observer's identification code.
#'
#' @return countb returns a list with asymmetric matrices, one for each observer
#'   and type of social interaction recorded. Matrix cells provide counts on the
#'   number of times social interactions were initiated by the row subjects and
#'   directed to the column subjects.
#'
#' @export
#'
#' @examples
#' ## create list of asymmetric matrices (data2) from data object
#' ## data object is obtained by converting raw focal observations' data in ex_field_data with
#' ## dtable function
#'  b <- c("+","-")
#'  data <- dtable(ex_field_data, bset = b)
#'  data2 <- countb(data)
#'  data2

countb <- function(x){

  observer <- NULL
  behavior <- NULL
# lower case all characters and remove white space characters
  x <- apply(x, 2 , function(x) tolower(x))
  x <- as.data.frame(apply(x, 2, function(x) gsub(' ', '', x)), stringsAsFactors = FALSE)
  x <- stats::setNames(x,c("id1", "id2", "sender_id1", "behavior", "no_occurrence", "missing", "observer"))
# get subjects' identfication codes
  ids <- sort(union(unique(x$id1),unique(x$id2)))
# get observers' identfication codes
  obs <- sort(unique(x$observer))
# identify different types of social interactions recorded
  bset <- sort(unique(x$behavior))
# determine the number of subjects
  l <- length(ids)
# initialize empty list to fill with nested lists, one for each observer,
# containing a set of data frames corresponding to the different types of social interactions recorded
  outL <- list()
# observers cycle
  for (o in obs){
  # subset data for the current observer
    dto <- subset(x, observer == o)
  # initialize list for the current observer
    obsL <- list()
  # behaviors cycle
    for (b in bset){
    # subset data for the current social interaction
      dtob <- subset(dto, behavior == b)
    # initialize matrix for the current social interaction
      m <- matrix(0, nrow = l, ncol = l, dimnames = list(ids, ids))
    # for cycle over data subset dtob
      for (i in 1:dim(dtob)[1]){
      # evalute who is sender/initiatior and who is receiver/target based on sender_id1
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

