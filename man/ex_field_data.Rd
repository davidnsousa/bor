\name{ex_field_data}
\alias{ex_field_data}
\docType{data}
\title{
ex_field_data
}
\description{
Examplar object representing an hypothetical data record of field behavior observations of dyadic social interactions.
}
\usage{ex_field_data}
\format{
  A data frame with 100 observations on the following 3 variables.
  \describe{
    \item{\code{id1}}{id of the subject under observation.}
    \item{\code{act}}{Action observed.}
    \item{\code{obs}}{Observer id}
  }
}
\details{
This example was randomly generated. 9 subjects are considered for the first variable and their behavior towards others are registered as action entries for the second variable. Subjects are referred as s1, s2, ..., s9. And actions are described by a reference to the interaction partner [partner id] (one element of the set of subjects except the self) and the behavior observed [behavior]. When [partner id] appears before [behavior] in the action record, then the former is the target and the later the sender, otherwise the symmetric is true. In this example there are two possible types of [behavior], namely a positive behavior "+" and a negative behavior "-", which are separated from [partner id] by a ".", the behavior separation character [bsep] in this example. In some observations multiple actions where observed in simultaneous. In these cases an action separation character [asep] is needed. In this example, a ";" is used. Action entries are equal to "x" or "0" when subjects are missing or no ocurrences are observed. The third variable indicates the observer of a particular observation. In this hypothetical investigation, two  observers did the job.}
\source{
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{
%%  ~~ possibly secondary sources and usages ~~
}
\examples{

}
\keyword{datasets}
