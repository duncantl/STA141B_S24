z = list.files(pattern = "indiv")

z

substring(z, 6, 7)

paste0("itcont", substring(z, 6, 7), ".txt")

newFileNames = paste0("itcont", substring(z, 6, 7), ".txt")


# We want to loop over the zip files, extract just the itcont.txt file,
# and then rename it.

cmds = sprintf("unzip %s itcont.txt; mv itcont.txt %s",  z, newFileNames)
out = sapply(cmds, system, intern = TRUE)


# Alternatively, extract itcont.txt and rename it from R
# before processing the next zip file.

mapply(function(zip, to) {
    system(paste("unzip ", zip,  "itcont.txt"), intern = TRUE)
    file.rename("itcont.txt", to)
    }, z, newFileNames)


# Or
newFileNames = paste0("itcont", substring(z, 6, 7), "_v2.txt")
cmds = sprintf("unzip -p %s itcont.txt > %s",  z, newFileNames)

mapply(function(zip, to) {
    system(paste("unzip ", zip,  "itcont.txt"), intern = TRUE)
    file.rename("itcont.txt", to)
    }, z, newFileNames)
