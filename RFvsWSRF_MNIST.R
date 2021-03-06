#  RECONOCIMIENTO DE DÍGITOS (BASE DE DATOS MNIST) USANDO
#  RANDOM FOREST TRADICIONAL VS RANDOM FOREST PONDERADO
#  Alumnos: Marco Caballero (DCC), Loreta Bernucci (MIM)
#  Profesor: Mauricio Cerda

rm(list=ls())

#  Carga de archivos con datos de entrenamiento y prueba
train <- read.csv("train.csv",header=TRUE) 
test <- read.csv("test.csv",header=TRUE)

#  Corrección conveniente de labels de archivos de datos 
labels_train <- as.factor(train[,1])
labels_test <- as.factor(test[,1])
nn_labels <- 0:784
nn_labels <- as.character(nn_labels)
names(train) <- nn_labels
names(test) <- nn_labels

#  Archivos de datos corregidos, excluyendo primera columna correspondiente a label
train.vars <- train[,-1]
test.vars <- test[,-1]

#  RANDOM FOREST TRADICIONAL

#  Utilizamos la librería randomForest, que implementa el algoritmo original de Breiman
library(randomForest)

#  Random Forest con 784 características (28x28 pixeles de imagen centrada de un dígito manuscrito)
rf.breiman <- randomForest(train.vars, labels_train, xtest=test.vars, ntree=100)
rf.breiman
rf.predicted <- rf.breiman$test$predicted
rf.actual <- test[, 1]
(accuracy.rf <- mean(rf.predicted == rf.actual, na.rm=TRUE))

#  Random Forest con 50 caracteristicas (fifty.fts)
#  50 caracteristicas obtenidas de http://staff.cs.utu.fi/~aatapa/software/RLScore/tutorial_fselection.html
fifty.fts <- c(70,101,104,151,154,190,211,214,220,237,260,267,277,290,296,298,301,320,343,346,350,352,355,376,386,401,406,409,427,439,459,461,464,512,515,518,523,538,542,549,573,580,583,596,651,657,709,712,715,718)
fifty.fts <- as.character(fifty.fts)
rf.breiman.fifty <- randomForest(train.vars[,fifty.fts], labels_train, xtest=test.vars[,fifty.fts], ntree=100)
rf.breiman.fifty
rf.predicted.fifty <- rf.breiman.fifty$test$predicted
rf.actual.fifty <- test[, 1]
(accuracy.rf.fifty <- mean(rf.predicted.fifty == rf.actual.fifty, na.rm=TRUE))

#  RANDOM FOREST PONDERADO (WSRF)

#  Utilizamos la librería wsrf, que implementa un algoritmo de ponderación de variables usando 
#  la razón de ganancia de información (ver texto de informe)
library("wsrf")

target <- "0" #librería wsrf llama nombre de columna, randomForest llama número de columna
vars <- names(train)
train[target] <- as.factor(train[[target]])
(form <- as.formula(paste(target, "~ .")))  #  formula para ponderar pesos: "~ ."

#  WSRF con 784 características
model.wsrf.mnist <- wsrf(form, data=train, ntree=100, weights=TRUE, parallel=FALSE)
wsrf.predicted <- predict(model.wsrf.mnist, newdata=test, type="class")$class
wsrf.actual <- test[, target]
(accuracy.wsrf.mnist <- mean(wsrf.predicted == wsrf.actual, na.rm=TRUE))
print(model.wsrf.mnist)


#  WSRF con 50 características
fifty.fts.cero <- c("0", fifty.fts)
model.wsrf.mnist.fifty<- wsrf(form, data=train[, fifty.fts.cero], ntree=100, weights=TRUE, parallel=FALSE)
wsrf.predicted.fifty <- predict(model.wsrf.mnist.fifty,newdata=test[, fifty.fts.cero], type="class")$class
wsrf.actual.fifty <- test[, target]
(accuracy.wsrf.mnist.fifty <- mean(wsrf.predicted.fifty == wsrf.actual.fifty, na.rm=TRUE))
print(model.wsrf.mnist.fifty)



