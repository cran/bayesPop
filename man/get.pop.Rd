\name{pop.trajectories}
\alias{get.pop}
\alias{get.pop.ex}
\alias{get.pop.exba}
\alias{pop.trajectories}
\alias{get.trajectory.indices}
\alias{extract.trajectories.eq}
\alias{extract.trajectories.ge}
\alias{extract.trajectories.le}
\title{
Accessing Trajectories
}
\description{
Obtain projection trajectories of population and vital events/rates. \code{get.pop} allows to access trajectories using a basic component of an expression. \code{get.pop.ex} and \code{get.pop.exba} returns results of an expression defined \dQuote{by time} and \dQuote{by age}, respectively. \code{get.trajectory.indices} creates a link to the probabilistic components of the projection by providing indices to the trajectories of TFR, e0 and migration. \code{extract.trajectories.eq} returns trajectories (of population or expression) and their indices that are closest to given values or a quantile. Similarly, functions \code{extract.trajectories.ge} and \code{extract.trajectories.le} return trajectories and their indices that are greater equal and less equal, respectively, to the given values or a quantile.
}
\usage{
pop.trajectories(pop.pred, country, sex = c("both", "male", "female"), 
    age = "all", ...)

get.pop(object, pop.pred, aggregation = NULL, observed = FALSE, ...)

get.pop.ex(expression, pop.pred, observed = FALSE, as.dt = FALSE, ...)

get.pop.exba(expression, pop.pred, observed = FALSE, as.dt = FALSE, ...)

get.trajectory.indices(pop.pred, country, 
    what = c("TFR", "e0M", "e0F", "migM", "migF"))

extract.trajectories.eq(pop.pred, country = NULL, expression = NULL, 
    quant = 0.5, values = NULL, nr.traj = 1, ...)
    
extract.trajectories.ge(pop.pred, country = NULL, expression = NULL, 
    quant = 0.5, values = NULL, all = TRUE, ...)
    
extract.trajectories.le(pop.pred, country = NULL, expression = NULL, 
    quant = 0.5, values = NULL, all = TRUE, ...)
}
\arguments{
  \item{pop.pred}{Object of class \code{\link{bayesPop.prediction}}.}
  \item{country}{Name or numerical code of a country.}
  \item{sex}{One of \dQuote{both}  (default), \dQuote{male} or \dQuote{female}. By default the male and female projections are summed up.}
  \item{age}{Either a character string \dQuote{all} (default) or an integer vector of age indices. In a 5x5 simulation, value 1 corresponds to age 0-4, value 2 corresponds to age 5-9 etc. Last age goup \eqn{130+} corresponds to index 27. In a 1x1 simulation, value 1 corresponds to age 0, value 2 to age 1 etc, up to 131 corresponding to the last age group. Results is summed over the given age categories.}
  \item{object}{Character string giving a basic component of an expression (see \link{pop.expressions}).}  
  \item{aggregation}{If the basic component is to be evaluated on an aggregated prediction object, this argument gives the name of the aggregation (corresponds argument \code{name} in \code{\link{pop.aggregate}}). By default, the function searches for available aggregations and gives priority to the one called \dQuote{country}.}
  \item{observed}{Logical. Determines if the evaluation uses observed data (\code{TRUE}) or predictions (\code{FALSE}).}
  \item{expression}{Expression defining the trajectories measure. For syntax see \code{\link{pop.expressions}}. It must be define by age (i.e. contain curly braces) if used in \code{get.pop.exba}, and the opposite applies to \code{get.pop.ex}.}
  \item{as.dt}{Logical indicating if the result should be returned as a \code{data.table} object in long format. This can be useful especially if results for all countries are requested.}
  \item{what}{A character string that defines to which component should the indices link to. Allowable options are \dQuote{TFR}, \dQuote{e0M} (male life expectancy), \dQuote{e0F} (female life expectancy), \dQuote{migM} (male migration), \dQuote{migF} (female migration).}
  \item{quant}{Quantile used to select the closest trajectories to.}
  \item{values}{Vector of values used to select the closest trajectories to. If it is not of length 1, it has to be of the same length as the number of projected time periods. If it is not given, \code{quant} is used.}
  \item{nr.traj}{Number of trajectories to return. This argument can be passed to any of the functions that contains \dots.}
  \item{all}{Logical indicating if the corresponding condition should apply to all time periods of a trajectory. If it is \code{FALSE}, a trajectory is extracted if the condition is fulfilled in at least one time period.}
  \item{\dots}{Additional argument passed to the underlying functions. In case of \code{get.pop}, \code{get.pop.ex} and  \code{get.pop.exba}, this is only used for \code{observed=FALSE}. It can be either \code{nr.traj} giving the number of trajectories or logical \code{typical.trajectory}.}
}

\details{
	Function \code{pop.trajectories} returns an array of population trajectories for given sex and age. 
	
	Function \code{get.pop} evaluates a basic component of an expression and results in a four-dimensional array. Internally, this function is used for evaluation after an expression is decomposed into basic components. It can be useful for example for debugging purposes, to obtain results from parts of an expression. In addition, while  \code{pop.trajectories} works only for population counts, \code{get.pop} can be used for obtaining trajectories of vital events and rates. Note that the wildcard \dQuote{XXX} in the expression cannot be used in \code{get.pop}; use \code{get.pop.ex} or \code{get.pop.exba} instead.
	
	Functions \code{get.pop.ex} and \code{get.pop.exba} evaluate a whole expression and the dimensions of the resulting array is collapsed depending on the specific expression. Use \code{get.pop.ex} if the expected result of the expression does not contain the age dimension, i.e. it uses no brackets or square brackets. If it is not the case, i.e. the expression is defined using curly braces in order to include the age dimension, the  \code{get.pop.exba} function is to be used. Argument \code{nr.traj} can be used to restrict the number of trajectories returned. Use one of those functions if results for all countries (i.e. if using \dQuote{XXX}) is desired. 
	
	Function \code{get.trajectory.indices} returns an array of indices that link back to the given probabilistic component. It is of the same length as number of trajectories in the prediction object. For example, an array of \code{c(10, 15, 20)} (for a prediction with three trajectories) obtained with \code{what="TFR"} means that the 1st, 2nd and 3rd population trajectory, respectively, were generated with the 10th, 15th and 20th TFR trajectory, respectively. If the input TFR and e0 were generated using \code{\link[bayesTFR:bayesTFR-package]{bayesTFR}} and \code{\link[bayesLife:bayesLife-package]{bayesLife}}, functions \code{\link[bayesTFR]{get.tfr.trajectories}} and \code{\link[bayesLife]{get.e0.trajectories}} can be used to extract the corresponding TFR and e0 trajectories.
	
	Function \code{extract.trajectories.eq} can be used to select a given number of trajectories of any population quantity, including vital events, that are close to either specific values or to a given quantile. For example the default seting with \code{quant=0.5} and \code{nr.traj=1} returns the one trajectory that is \dQuote{closest} to the median projection. As a measure of \dQuote{closeness} the sum of absolute differences (across all time periods) is used. 
	
	Similarly, function \code{extract.trajectories.ge} (\code{extract.trajectories.le}) selects all trajectories that are greater (less) equal to the specific values or a given quantile. The argument \code{all} specifies, if the greater/less condition should be valid for all time periods of the selected trajectories or at least one time period. 
}

\value{
	Function \code{pop.trajectories} returns a two-dimensional array (time x trajectory).
	
	Function \code{get.pop} returns an array of four dimensions (country x age x time x trajectory). See \link{pop.expressions} for more details.
	
	Functions \code{get.pop.ex} and \code{get.pop.exba} return an array of trajectories. Its dimensions depend on the expression and whether it is evaluated on observed data or projections. If \code{as.dt} is \code{TRUE} these functions return \code{data.table} objects in long format.
	
	Function \code{get.trajectory.indices} returns a 1-d array of indices. If the given component is deterministic, it returns \code{NULL}. 
	
	Functions \code{extract.trajectories.eq}, \code{extract.trajectories.ge}, \code{extract.trajectories.le} return a list with two components. \code{trajectories}: 2-d array of trajectories; \code{index}: indices of the selected trajectories relative to the whole set of available trajectories.  
}

\author{
Hana Sevcikova
}

\seealso{
\link{pop.expressions}
}
\examples{
sim.dir <- file.path(find.package("bayesPop"), "ex-data", "Pop")
pred <- get.pop.prediction(sim.dir, write.to.cache=FALSE)

# observed female of Netherlands by age; 1x21x15x1 array
popFNL <- get.pop("PNL_F{}", pred, observed=TRUE)

# observed population for all countries in the prediction object,
# here 2 countries; 2x1x15x1 array
popAll <- get.pop("PXXX", pred, observed=TRUE)

# future migration for all countries in the prediction object,
# here 2 countries; 2x17 array
migAll <- get.pop.ex("GXXX", pred)

# projection population for Ecuador with 3 trajectories; 
# 1x1x17x3 array
popEcu <- get.pop("P218", pred, observed=FALSE)

# the above is equivalent to 
popEcu2 <- pop.trajectories(pred, "Ecuador")

# Expression "PNL_F{} / PNL_M{}" evaluated on projections
# is internally replaced by
FtoM <- get.pop("PNL_F{}", pred) / get.pop("PNL_M{}", pred)
# should return the same result as
FtoMa <- get.pop.exba("PNL_F{} / PNL_M{}", pred)

# the same expression by time (summed over ages) 
FtoMt <- get.pop.ex("PNL_F / PNL_M", pred)

# the example simulation was generated with 3 TFR trajectories ...
get.trajectory.indices(pred, "Netherlands", what="TFR")
# ... and 1 e0 trajectory 
get.trajectory.indices(pred, "Netherlands", what="e0M")

# The three trajectories of the population ratio of Ecuador to Netherlands
get.pop.ex("PEC/PNL", pred)
# Returns the trajectory closest to the upper 80\% bound, including the corresponding index
extract.trajectories.eq(pred, expression="PEC/PNL", quant=0.9)
# Returns the median trajectory and the high variant, including the corresponding index
extract.trajectories.ge(pred, expression="PEC/PNL", quant=0.45)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

\keyword{ manip }

