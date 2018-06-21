\name{ex_field_data}
\alias{ex_field_data}
\docType{data}
\title{
ex_field_data
}
\description{
Example object representing an hypothetical data record of field behavior observations of dyadic social interactions.
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
9 subjects are considered for this hypothetical example: s1, s2, ..., s9. Action entries (in column "act") are records of their behavior towards others. Actions are described by a reference to the interaction partner [partner id] (one element of the set of subjects except the self) and the behavior observed [behavior]. When [partner id] appears before [behavior], the former is the target and the later the sender, otherwise the symmetric is true. In this example there are two possible types of [behavior], namely a positive behavior "+" and a negative behavior "-". The behavior separation character [bsep], in this case the character ".", is use to separate behaviors from ids. In some observations multiple actions where recorded in the same action entry (multiple dyadic interactions by the same subject in the same time interval). In these cases an action separation character [asep] is needed. In this example, a ";" is used. Action entries are equal to "x" or "0" when subjects are missing or no ocurrences are observed. The third variable indicates the observer of a particular observation. In this hypothetical investigation, two  observers did the job.}
\source{
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{
%%  ~~ possibly secondary sources and usages ~~
}
\examples{

}
\keyword{datasets}
