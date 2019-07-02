Requerimientos: 
 - Paquete de wsrf para r. Instrucciones Para instalar en : https://cran.r-project.org/web/packages/wsrf/vignettes/wsrf-guide.html
 - Paquete de Random Forest para r.
 - Python 3.6 
 - Notebook de Jupyter 


Reproducir Parte de las Pruebas:

Se adjunta el archivo RFvsWSRF_MNIST.R, con el cual se pueden realizar las pruebas de rendimeinto de los dos métodos, aplicado a todos los píxeles, y a fifty.fts. 

Si desea reproducir las Pruebas de los histogramas de frecuencia, se debe usar el archivo Extraer_Características.ipynb, el cual hace los calculos(sumas y PCA) de las imagenes  y guarda dos archivos xdata.csv y ydata.csv el cual pueden ser de los siguetes tamaños:

- xdata : n x 28  Si es alguna de las sumas, donde x es el número de imagenes a las que se le aplicó la reducción.
          n x v   Si es la proyección de "n" imagenes usando "v" vectores principales en PCA.    
 
- ydata : n x 1   En todos los casos, ya que por cada imagen  solo existe un valor objetivo.
 
Luego de hacer la reducción, cargar los dataset(xdata.csv,ydata.csv) en r y aplicar los dos métodos ejemplo :

-------Cargar_Datos----------------------------------
datos <- read.csv("/home/marco/Gits/Patrones/xdata0.csv", header = FALSE)
ydatos <- read.csv("/home/marco/Gits/Patrones/ydata.csv", header = FALSE)

------Colocar un nombre a la columna y hacerlo factor------------------------------
colnames(ydatos)[1]<-"num"
ydatos$num= factor(ydatos$num)
-------------Unir en un solo dataframe------------------------
union <- cbind(datos,ydatos)
-----Configurar fórmula para de los clasifcadores, y determinar variables-----------
union <- cbind(datos,ydatos)
target <- "num"
form <- as.formula(paste(target, "~ ."))
vars <- names(union)
---------------------------Dividir el data frame en train a test-------------------
train <- sample(nrow(union), 0.7*nrow(union))
test  <- setdiff(seq_len(nrow(union)), train)
---------------------Random Forest ponderado-----------------------------------
library("wsrf")
model.wsrf <- wsrf(form, data=union[train, vars], parallel=FALSE)
> print(model.wsrf)
A Weighted Subspace Random Forest model with 500 trees.

  No. of variables tried at each split: 4
        Minimum size of terminal nodes: 2
                 Out-of-Bag Error Rate: 0.13
                              Strength: 0.60
                           Correlation: 0.17

Confusion matrix:
    0   1   2   3   4   5   6   7   8   9 class.error
0 632   1   5   5   1  27   9   0   5   0        0.08
1   0 650   4   3   0   7   2   1   0   2        0.03
2   9   2 623  16  11   8  14   9  15   1        0.12
3   6   6  19 598   4  27   4   4  48  10        0.18
4   1   6  11   4 607   2  11   8   8  76        0.17
5  22   4   5  24   7 583  11   9  13  11        0.15
6  13   6  16   0   6  12 645   0   4   1        0.08
7   2   6   9   0  13   3   1 661   5  20        0.08
8   6  12  18  44   6  24   7   9 521  19        0.22
9   3   4   1   8  77   8   6  35  11 547        0.22

------------------------Calcular presición------------------------------------------
actual <- union[test, target]
(accuracy.wsrf <- mean(res$response==actual))

------------------------------Random Forest Normal------------------------------------
library(randomForest)
model2 <- randomForest(form, data = union[train,vars], ntree = 500, mtry = 5, importance = TRUE)

> print(model2)

Call:
 randomForest(formula = form, data = union[train, vars], ntree = 500,      mtry = 5, importance = TRUE) 
               Type of random forest: classification
                     Number of trees: 500
No. of variables tried at each split: 5

        OOB estimate of  error rate: 11.91%
Confusion matrix:
    0   1   2   3   4   5   6   7   8   9 class.error
0 639   1   3   5   0  24  10   0   3   0  0.06715328
1   0 652   4   2   0   4   4   0   1   2  0.02541106
2   8   2 637  12  10   3  11   6  18   1  0.10028249
3   3   2  16 619   2  22   3   5  43  11  0.14738292
4   1   5  10   2 602   5  14   6   2  87  0.17983651
5  12   3   2  27   6 594  11   6  11  17  0.13788099
6   8   5  14   2   1  10 659   0   3   1  0.06258890
7   4  10   7   1   9   1   0 661   5  22  0.08194444
8   1   8  18  42   5  25   4   5 535  23  0.19669670
9   1   4   2   8  63  10   2  32  10 568  0.18857143
-------------------------------------Calcular Presición-----------------------
res.norm <- predict(model2, newdata=union[test, vars], type=c("response", "waprob"))

(accuracy.norm <- mean(res.norm==actual))
