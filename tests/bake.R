### test of reproducibility utilities

library(pomp)

set.seed(5499)
w1 <- runif(2)
freeze({runif(5)},seed=499586)
w2 <- runif(2)
freeze(runif(5),seed=499586)
set.seed(5499)
w3 <- runif(4)
stopifnot(all.equal(c(w1,w2),w3))

set.seed(32765883)
x1 <- bake({runif(4)},file=file.path(tempdir(),"bake1.rds"))
x2 <- bake({runif(4)},file=file.path(tempdir(),"bake2.rds"),seed=32765883)
x3 <- bake({runif(4)},file=file.path(tempdir(),"bake1.rds"))
stopifnot(all.equal(as.numeric(x1),as.numeric(x2)))
stopifnot(all.equal(as.numeric(x1),as.numeric(x3)))

set.seed(113848)
stew({y1 <- runif(4)},file=file.path(tempdir(),"stew1.rds"))
stew({y2 <- runif(4)},file=file.path(tempdir(),"stew2.rds"),seed=113848)
print(stew({y3 <- runif(4)},file=file.path(tempdir(),"stew1.rds")))
stopifnot(all.equal(y1,y2))
stopifnot(!exists("y3"))

pompExample(gillespie.sir)
simulate(gillespie.sir,seed=1347484107L) -> x
freeze(simulate(gillespie.sir),seed=1347484107L) -> y
attr(y,"system.time") <- NULL
attr(y,"seed") <- NULL
attr(y,"kind") <- NULL
attr(y,"normal.kind") <- NULL
stopifnot(identical(x,y))

invisible(freeze({rnorm(5); NULL},seed=3494995))
invisible(bake({rnorm(5); NULL},seed=3494995,
               file=file.path(tempdir(),"bake3.rds")))

detach("package:pomp", unload=TRUE)
