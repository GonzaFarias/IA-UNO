from tensorflow import keras
import numpy as np
from sklearn.preprocessing import MinMaxScaler
from tensorflow.python.keras.models import Sequential
from tensorflow.python.keras.layers import Dense
import pandas as pd

#IMPORTAMOS LOS DATOS (MODIFICAR RUTA)
dataset = np.loadtxt("C:\\Users\\ferma\\Downloads\\biopsy.csv", delimiter=";", skiprows=1)

#CREAMOS REFERENCIA A UN NORMALIZAR (MAXIMO MINIMO EN ESTE CASO)
scaler = MinMaxScaler()
#NORMALIZAMOS LOS DATOS
scaled_dataset = scaler.fit_transform(dataset)

#DEFINIMOS LA CANTIDAD DE DATOS PARA EL ENTRENAMIENTO
train_set_size = 500

#GUARDAMOS EL TAMAÑO TOTAL DEL DATASET
set_size = len(scaled_dataset)

#DIVIDIMOS LOS DATOS PARA ENTRENAMIENTO
dataset_train = scaled_dataset[0:train_set_size]

#DIVIDIMOS LOS DATOS PARA COMPROBACIÓN
dataset_test = scaled_dataset[train_set_size:set_size]

#EXTRAEMOS LAS VARIABLES EXPLICATIVAS PARA LA COMPROBACIÓN
vars_explicativas_test = dataset_test[:, 0:9]

#EXTRAEMOS LAS VARIABLES EXPLICADAS PARA LA COMPROBACIÓN
var_explicada_test = dataset_test[:, 9]

#EXTRAEMOS LAS VARIABLES EXPLICATIVAS PARA EL ENTRENAMIENTO
X = dataset_train[:, 0:9]

#EXTRAEMOS LAS VARIABLES EXPLICADAS PARA EL ENTRENAMIENTO
Y = dataset_train[:, 9]
Y = Y[:, np.newaxis]

#CREAMOS REFERENCIA A UN MODELO RNA SECUENCIAL (SE DEFINE CAPA POR CAPA)
model = Sequential()

#CREAMOS LA TOPOLOGIA DE LA RNA CON SUS DISTINTOS PARAMETROS
model.add(Dense(9, input_dim=9, activation='relu'))
model.add(Dense(150, activation='relu'))
model.add(Dense(500, activation='relu'))
model.add(Dense(150, activation='relu'))
model.add(Dense(1, activation='sigmoid'))

#CREAMOS UNA REFERENCIA A UN ALG. DE OPT. GRADIENTE DESCENDIENTE ESTOCASTICO (SGD) CON 
# SU TASA DE APRENDIZAJE
opt = keras.optimizers.SGD(learning_rate=0.05)

#COMPILAMOS EL MODELO CON LA FUNCION ECM DE EVALUACION DE ERROR
model.compile(loss='mean_squared_error', optimizer=opt)

#ENTRENAMOS EL MODELO DANDOLE LAS VARIABLES Y DEMAS PARAMETROS
model.fit(X, Y, epochs=1000, batch_size=10, verbose=0)

#compilacion del modelo
#model.compile(loss='mean_squared_error', optimizer='adam')

#entrenar modelo
#model.fit(X, Y, epochs=1000, batch_size=50, verbose=0)

#EVALUA EL MODELO
scores = model.evaluate(X, Y)

#DADO EL MODELO ENTRENADO Y LAS VARIABLES QUE GUARDAMOS ANTERIORMENTE, PREDECIMOS
predicciones = model.predict(vars_explicativas_test)[:, 0]

#DEFINIMOS LA FUNCION DE ERROR ECM 
ecm_f = lambda Yp, Yr: np.mean((Yp-Yr) ** 2)

#DADA LAS PREDICCIONES Y LOS VALORES REALES, EVALUAMOS EL ERROR REAL DEL MODELO
ecm_real = ecm_f(predicciones, var_explicada_test)

#CREAMOS UNA TABLA PARA IMPRIMIR
d = {'predicciones' : predicciones, 'reales' : var_explicada_test}

#IMPRIMIMOS LA TABLA
display(pd.DataFrame(d))

#IMPRIMIMOS PARAMETROS DE ERROR REAL
print("ECM Real: " + str(ecm_real))
c = np.corrcoef(predicciones,var_explicada_test)
print("Correlación de Pearson: "+str(c))