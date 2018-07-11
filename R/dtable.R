#' dtable
#'
#' dtable takes a data frame containing raw focal observations' data and
#' transforms it into another data frame more suitable for further data
#' analysis.
#'
#' @param x data frame containing raw focal observations' data, referring to
#'   dyadic social interactions. This data frame should contain one focal
#'   observation per row and 3 columns. The first column should refer to focal's
#'   subject identification code; the second, to the recorded dyadic social
#'   interactions; and the third, to observer's identification code. See
#'   ex_field_data for further details on the structure of this data frame.
#'
#' @param bset A vector specifying the codes of the recorded social
#'   interactions.
#'
#' @param bsep The separation character used in the second column of x to
#'   separate subject's id code from social interactions code. Default is ".".
#'
#' @param asep The separation character used in the second column of x to
#'   separate different social interactions recorded within the same focal
#'   sample. Default is ";".
#'
#' @param missing A character, used in the second column of x, to identify focal
#'   observations where the focal subject was unavailable for observation.
#'   Default is "x".
#'
#' @param noc A character, used in the second column of x, to identify focal
#'   observations where no social interactions were recorded. Default is "0".
#'
#' @return dtable returns a data frame with 7 columns: "id1" identifies the
#'   focal subject's; "sender_id1" identifies whether the focal's subject (id1)
#'   was the initiator of the dyadic social interaction (coded 1), or the target
#'   of the social interaction (coded 0; in this case the initiator is the
#'   subject referred in the column "id2"); "behavior" identifies the social
#'   interaction observed; if no social interactions were recorded in a focal
#'   sample, "no_occurrence" and "missing" columns specify whether the focal
#'   subject was observed but did not interact, or was unavailable for
#'   observation, respectively; "observer" columns indentifies the observer.
#'
#' @export
#'
#' @examples
#' ## convert raw focal observations' data in ex_field_data
#' ## see ?ex_field_data for further details
#' ## bsep, asep, missing and noc arguments take default values (".", ";", "x", "0" respectively)
#' b <- c("+","-")
#' data <- dtable(ex_field_data, bset = b)
#' head(data)

dtable <- function(x, bset, bsep = ".", asep = ";", missing = "x", noc = "0"){

# lower case all characters and remove white spaces
  x <- apply(x, 2 , function(x) tolower(x))
  x <- as.data.frame(apply(x, 2,
                           function(x) gsub(' ', '', x)),
                     stringsAsFactors = FALSE)
# names x columns
  names(x) <- c("id", "act", "obs")
# empty act entries are coded to missing (i.e., focal subject unavailable for observation)
  x$act[is.na(x$act)] <- missing
# retrieve subjects identfication codes
  ids <- sort(unique(x$id))
# prevent special regex characters in bsep and asep arguments
# to be used as such by adding a preceding '\\'
  bsep <- paste("\\",bsep, sep="")
  asep <- paste("\\",asep, sep="")

# while loop to break focal samples with more than one social interaction recorded,
# into different rows (i.e., one row per social interaction)
  i <- 1
  size <- dim(x)[1]
  while (i <= size) {
    act <- x$act[i]
  # check if more than one social interaction was recorded in the same focal sample
  # if asep separation character is present in data$act i row,
  # grepl returns TRUE
    if (grepl(asep, act)){
    # isolate first social interaction from the rest
    # regexpr() identifies the position of the first match of asep in act
    # regmatches() with invert = TRUE selects everthing but the character in the position previously identified
    # acts[1] being the first isolated social interaction and
    # acts[2] everything after the first match of asep
      acts <- unlist(
        regmatches(act, regexpr(asep, act), invert = TRUE)
        )
    # fill the present row i act entry with acts[1]
      x$act[i] <- acts[1]
    # adds a new row to x after i with acts[2] for the same id and obs
      x <-rbind(x[1:i,],
                c(x$id[i], acts[2], x$obs[i]),
                x[-(1:i),]
                )
    # update x data frame size
      size <- size + 1
    }
    i = i + 1
  }

# creates an empy data frame, dt, with 7 columns,
# and with the same number of rows as x data frame
  dt <- setNames(data.frame(matrix(ncol = 7, nrow = size)),
                 c("id1","id2","sender_id1","behavior","no_occurrence","missing","observer"))

# for cycle to fill dt data frame
  for (i in 1:size) {
    dt$id1[i] <- x$id[i]
    act <- x$act[i]
  # if statement evaluates to TRUE,
  # if act contains bsep separator character
    if (grepl(bsep, act)){
    # breaks act string in two substrings using bsep
    # one of them must indicate the behavior and the other the interaction partner id2
      act <- unlist(
        strsplit(act, bsep)
        )
    # identify behavior, sender and id2:
    # for each element in act, match() returns the numeric index
    # of the matching element in bset, or NA in the case no match
    # na.omit() removes the only NA value in the vector of matches
    # therefore, the behavior is determined by bset[na.omit(match(act, bset))]
    # !is.na() returns a logical vector indicating numerical values in the vector act,
    # therefore, TRUE indicates the position of the bset element in act
    # if TRUE is at the first position in act, id1 is the sender/initiator, that is,
    # sender_id1 = 1, and in that case, id2 is indicated by the second position in act,
    # indexed by sender_id1 + 1 = 2. if TRUE is at the second position, then id2
    # is the sender, that is, sender_id1 = 0, and in that case, id2 is indicated
    # by the first position in act, indexed by sender_id1 + 1 = 1.
      dt$behavior[i] <- bset[na.omit(match(act, bset))]
      dt$sender_id1[i] = c(1,0)[!is.na(match(act, bset))]
      dt$id2[i] <- act[dt$sender_id1[i] + 1]
    }
    # any entries which refer to missing values or no occorrences are identified with 1,
    # in their respective positions in the output data frame,
    # using noc and missing arguments
    if (x$act[i] == noc) {dt$no_occurrence[i] = 1}
    if (x$act[i] == missing) {dt$missing[i] = 1}
    dt$observer[i] <- x$obs[i]
  }
  dt
}
