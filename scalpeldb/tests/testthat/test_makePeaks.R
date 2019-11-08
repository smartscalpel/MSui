context("makePeaks")

mz<-rep(c(100,500,800),times=3)
int<-rnorm(9,mean=1e5,sd=1e3)
sc<-rep(1:3,each=3)
snr<-rnorm(9,mean=5,sd=3)
dt<-data.table::data.table(mz=mz,intensity=int,scan=sc)
md<-data.frame(scan=1:3,md=runif(3),sf=rnorm(3))

test_that('peaks made from dt only',{
  pl<-makeMassPeak(dt)
  expect_is(pl,'list')
  expect_equal(length(pl),3)
  expect_is(pl[[1]],'MassPeaks')
  expect_identical(mass(pl[[1]]),c(100,500,800))
  expect_identical(intensity(pl[[1]]),int[1:3])
  expect_true(all(is.na(snr(pl[[1]]))))
  expect_equal(length(metaData(pl[[1]])),0)
})

test_that('peaks made from dt with snr',{
  dts<-dt
  dts$snr<-snr
  pl<-makeMassPeak(dts)
  expect_is(pl,'list')
  expect_equal(length(pl),3)
  expect_is(pl[[1]],'MassPeaks')
  expect_identical(mass(pl[[1]]),c(100,500,800))
  expect_identical(intensity(pl[[1]]),int[1:3])
  expect_false(any(is.na(snr(pl[[1]]))))
  #cat(snr[1:3],'\n',snr(pl[[1]]),'\n')
  expect_identical(snr(pl[[1]]),snr[1:3])
  expect_equal(length(metaData(pl[[1]])),0)
})

test_that('peaks made from dt with metadata',{
  pl<-makeMassPeak(dt,metadata = md)
  expect_is(pl,'list')
  expect_equal(length(pl),3)
  expect_is(pl[[1]],'MassPeaks')
  expect_identical(mass(pl[[1]]),c(100,500,800))
  expect_identical(intensity(pl[[1]]),int[1:3])
  expect_true(all(is.na(snr(pl[[1]]))))
  expect_equal(length(metaData(pl[[1]])),3)
})

