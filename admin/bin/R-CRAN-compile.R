
# Global option to not test before loading.  We might get a few broken pkgs but
# we also get some packages that build OK but for some reason fail a test.  We
# can look into these if users complain.

options(INSTALL_opts = "--no-test-load")
options(download.file.method = "wget")

args = commandArgs()
base = "/home/software/apps/local/lib/R/"
plib = paste(base, args[9], sep = "")

## CRAN repo options( repos = 'ftp://mirror.hmdc.harvard.edu/CRAN' )
options(repos = "http://cran.stat.auckland.ac.nz")
# Get new modules
plist <- new.packages(lib.loc = plib)
sapply(plist, function(x) {
  try(install.packages(x, lib = plib))
})
# Get updated modules
ulist <- old.packages(lib.loc = plib)
sapply(ulist, function(x) {
  try(install.packages(x, lib = plib))
})
# Add useful tools from non-CRAN repo
library("devtools")
devtools::install_github("hadley/multidplyr", lib = plib)
devtools::install_github("IRkernel/IRkernel", lib = plib)
# IRkernel::installspec() # to register the kernel in the current R installation
#Add biocLite packages and other tools
plib = paste(base, "biocLite/3.7", sep = "")
.libPaths(plib)
source("http://www.bioconductor.org/biocLite.R")
biocLite()
pkglist <- as.list(scan("/home/software/vuwrc/admin/bin/R-biocLite.pkgs", sep = "", what = ""))
for (i in pkglist) {
  biocLite(i)
}
install.packages("/home/software/src/poRe-0.24.tgz", lib=plib, repos=NULL, type="source")

# Save any warnings
cat(file = "warnings.rinstall")
warnings(file = "warnings.rinstall", append = TRUE)

q()
