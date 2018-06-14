#' dtable
#'
#' dtable takes an object representing the data record of field behavior observations of dyadic social interactions and returns a data frame of the same data organized in a way suitable for further statistical analysis.
#'
#' @param x Behavior observation field record. An object with one row per observation and 3 columns: id of the subject under observation, the action observed and the observer id. Action entries may refer to the interaction partner and the behavior observed: [behavior][bsep][partner id] if partner is the target or [partner id][bsep][behavior] if subject is the target.
#' @param bset A vector specifying the set of behaviors observed.
#' @param bsep A separation character for bset elements and id's. Default is ".".
#' @param asep A separation character for multiple actions in just one entry. Default is ";".
#' @param missing A character specifying missing subjects. Default is "x".
#' @param noc A character specifying no ocorrences. Default is "0".
#'
#' @return dtable returns a data frame with 7 columns: "id1" indicates the subject under observation and "id2" it's interaction partner. "sender_id1" takes the values 1 or 0 whether id1 is the sender or not. If not, id2 is the sender. "behavior" indicates the behavior observed. If no ocurrences or misses where observed, "no_ocurrence" and "missing" take the value 1. All entries of multiple actions are separated in consecutive rows. All characters are changed to lower case and any white spaces are removed.
#' @export
#'
#' @examples
#'
#' ## converting the field raw data of behavior observations to suitable form useful for further statistical analysis
#' bset <- c("+","-")
#' data <- dtable(ex_field_data, bset)

dtable <- function(x, bset, bsep = ".", asep = ";", missing = "x", noc = "0"){

# lower case all characters and remove white space characters
  x <- apply(x, 2 , function(x) tolower(x))
  x <- as.data.frame(apply(x, 2 , function(x) gsub(' ', '', x)), stringsAsFactors = FALSE)
# names x columns
  names(x) <- c("id", "act", "obs")
# empty action entries are considered missing
  x$act[is.na(x$act)] <- missing
# determine subjects identfication codes
  ids <- sort(unique(x$id))
# prevent special regex characters in bsep and asep to be used as such by adding a preceding '\\'
  bsep <- paste("\\",bsep, sep="")
  asep <- paste("\\",asep, sep="")

# while loop to break observations with more than one action recorded
  i <- 1
  size <- dim(x)[1]
  while (i <= size) {
    act <- x$act[i]
  # check if more than one action was scored in the same observation
  # if asep separation character is present in data$act i row,
  # grepl returns TRUE
    if (grepl(asep, act)){
    # isolate first action from the rest
    # regexpr() identifies the position of the first match of asep in act
    # regmatches() with invert = TRUE selects everthing but the character in the position previously identified
    # acts[1] being the first isolated action and
    # acts[2] everything after the first match of asep
      acts <- unlist(
        regmatches(act, regexpr(asep, act), invert = TRUE)
        )
    # fill the present row i action entry with acts[1]
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

# creates an empy data frame, dt, with seven columns,
# and with the same number of rows as x data frame
  dt <- setNames(data.frame(matrix(ncol = 7, nrow = size)),
                 c("id1","id2","sender_id1","behavior","no_ocurrence","missing","observer"))

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
        strsplit(act,bsep)
        )
    # identify behavior, sender and id2:
    # for each element in act, match() returns the numeric index
    # of the matching element in bset, or NA in the case no match
    # na.omit() removes the only NA value in the vector of matches
    # therefore, the behavior is determined by bset[na.omit(match(act,bset))]
    # !is.na() returns a logical vector indicating numerical values in the vector act,
    # therefore, TRUE indicates the position of the bset element in act
    # if TRUE is at the first position in act, id1 is the sender, that is,
    # sender_id1 = 1, and in that case, id2 is indicated by the second position in act,
    # indexed by sender_id1 + 1 = 2. if TRUE is at the second position, then id2
    # is the sender, that is, sender_id1 = 0, and in that case, id2 is indicated
    # by the first position in act, indexed by sender_id1 + 1 = 1.
      dt$behavior[i] <- bset[na.omit(match(act,bset))]
      dt$sender_id1[i] = c(1,0)[!is.na(match(act,bset))]
      dt$id2[i] <- act[dt$sender_id1[i] + 1]
    }
    # any entries which refer to missing values or no occorrences are identified with 1
    # in their respective positions in the output data frame
    if (x$act[i] == noc) {dt$no_ocurrence[i] = 1}
    if (x$act[i] == missing) {dt$missing[i] = 1}
    dt$observer[i] <- x$obs[i]
  }
  dt
}
