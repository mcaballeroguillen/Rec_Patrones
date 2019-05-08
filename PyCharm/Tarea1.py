import numpy as np
from PIL import Image
from numpy import mean,cov,cumsum,dot,linalg,size,flipud
def contruct_name():
    Im_traing = ["-005E-10", "-020E-10", "-070E+45", "+000E+00", "+005E-10", "+020E-10", "+070E+45"]
    Im_test = ["-110E+65", "+110E+65"]
    Traing = []
    Traing_y = []
    for x in range(28):
        for s in Im_traing:
            sujeto = 11 + x
            if (sujeto == 14):
                continue
            img_d = "/home/marco/Base_Patrones/CroppedYale/" + "yaleB" + str(sujeto) + "/yaleB" + str(
                sujeto) + "_P00A" + s + ".pgm"
            Traing.append(img_d)
            Traing_y.append(sujeto)
    Test = []
    Test_y = []
    for x in range(28):
        for s in Im_test:
            sujeto = 11 + x
            if (sujeto == 14):
                continue
            img_d = "/home/marco/Base_Patrones/CroppedYale/" + "yaleB" + str(sujeto) + "/yaleB" + str(
                sujeto) + "_P00A" + s + ".pgm"
            Test.append(img_d)
            Test_y.append(sujeto)
    return Traing, Traing_y, Test ,Test_y

def load_im(Traing,Test):
    im = np.array(Image.open(Traing[0]))
    m, n = im.shape[0:2]
    imnbr = len(Traing)
    Traing_matrix = np.array([np.array(Image.open(Traing[i])).flatten() for i in range(imnbr)])
    imnbr = len(Test)
    Test_matrix = np.array([np.array(Image.open(Test[i])).flatten() for i in range(imnbr)])
    return Traing_matrix, Test_matrix,m,n

def myPCA1(M,k):
    means=mean(M.T,axis=1) #Calcular Imagen Promedio
    M=(M-means).T  # Restar el promedio
    [latent,coeff] = linalg.eig(cov(M))
    return means

Traing, Traing_y, Test ,Test_y = contruct_name()
Traing_matrix, Test_matrix,m,n = load_im(Traing,Test)
means = myPCA1(Traing_matrix,1)

print(Traing_matrix.shape)
