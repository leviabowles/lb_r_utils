library(C50)
library(tree)
library(party)
library(rpart)
library(rpart.plot)
library(CHAID) ##chaid is installed from RFORGE install.packages("CHAID", repos="http://R-Forge.R-project.org")

iva = iris[,1:4]
dva = factor(ifelse(iris$Species == "setosa","class1","class2"))


##C50
output = C50::C5.0(iva,dva)
summary(output)
plot(output)


##tree
treeput = tree::tree(dva~., data = iva)
plot(treeput)
text(treeput, pretty = 0)


##rpart
rpa = rpart::rpart(dva~., data = iva)
rpart.plot::rpart.plot(rpa)


#party tree
party_tree = party::ctree(dva~., data = iva)
plot(party_tree)


#chaid  # chaid requires all categorical ivars so maybe we just ignore this.
cha = CHAID::chaid(dva~., data = iva)
