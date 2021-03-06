\name{shift}
\alias{shift}
\alias{lead}
\alias{lag}
\title{Fast lead/lag for vectors and lists}
\description{
  \code{lead} or \code{lag} vectors, lists, data.frames or data.tables. It always returns a list and is implemented in C for speed.

  \code{bit64::integer64} is also supported.
}

\usage{
shift(x, n=1L, fill=NA, type=c("lag", "lead"), give.names=FALSE)
}
\arguments{
  \item{x}{ A vector, list, data.frame or data.table. }
  \item{n}{ Non-negative integer vector providing the periods to lead/lag by. To create multiple lead/lag vectors, provide multiple values to \code{n}. }
  \item{fill}{ Value to pad by. }
  \item{type}{ default is \code{"lag"}. The other possible value is \code{"lead"}. }
  \item{give.names}{default is \code{FALSE} which returns an unnamed list. When \code{TRUE}, names are automatically generated corresponding to \code{type} and \code{n}. }
}
\details{
  \code{shift} accepts vectors, lists, data.frames or data.tables, and always returns a list. This is so that it can be used conveniently within data.table's syntax. For example, \code{DT[, (cols) := shift(.SD, 1L), by=id]} would lag every column of \code{.SD} by 1 period for each group. 

  For the same reason, the argument \code{n} allows multiple values. For example, \code{DT[, (cols) := shift(.SD, 1:2), by=id]} would lag every column of \code{.SD} by \code{1} and \code{2} periods for each group. If \code{.SD} contained four columns, the first two elements of the list would correspond to \code{lag=1} and \code{lag=2} for the first column of \code{.SD}, the next two for second column of \code{.SD} and so on. Please see examples for more.

  \code{shift} is designed mainly for use in data.tables along with \code{:=} or \code{set}. Therefore, it returns an unnamed list by default as assigning names for each group over and over can be quite time consuming with many groups. It may be useful to set names automatically in other cases, which can be done by setting \code{give.names} to \code{TRUE}.
}
\value{
  A list containing the lead/lag of input \code{x}.
}

\examples{
# on vectors
x = 1:5
# lag with period=1 and pad with NA
shift(x, n=1, fill=NA, type="lag")
# lag with period=1 and 2, and pad with 0
shift(x, n=1:2, fill=0, type="lag")

# on data.tables
DT = data.table(year=2010:2014, v1=runif(5), v2=1:5, v3=letters[1:5])
# lag columns 'v1,v2,v3' DT by 1 and fill with 0
cols = c("v1","v2","v3")
anscols = paste("lead", cols, sep="_")
DT[, (anscols) := shift(.SD, 1, 0, "lead"), .SDcols=cols]

# return a new data.table instead of updating
# with names automatically set
DT = data.table(year=2010:2014, v1=runif(5), v2=1:5, v3=letters[1:5])
DT[, shift(.SD, 1:2, NA, "lead", TRUE), .SDcols=2:4]

# lag/lead in the right order
DT = data.table(year=2010:2014, v1=runif(5), v2=1:5, v3=letters[1:5])
DT = DT[sample(nrow(DT))]
# add lag=1 for columns 'v1,v2,v3' in increasing order of 'year'
cols = c("v1","v2","v3")
anscols = paste("lag", cols, sep="_")
DT[order(year), (cols) := shift(.SD, 1, type="lag"), .SDcols=cols]
DT[order(year)]

# while grouping
DT = data.table(year=rep(2010:2011, each=3), v1=1:6)
DT[, c("lag1", "lag2") := shift(.SD, 1:2), by=year]

# on lists
ll = list(1:3, letters[4:1], runif(2))
shift(ll, 1, type="lead")
shift(ll, 1, type="lead", give.names=TRUE)
shift(ll, 1:2, type="lead")

}
\seealso{
  \code{\link{data.table}}
}
\keyword{ data }

