*ECONOMIA APLICADA PROBLEM SET 3
*QUISPE, CASCIANO, SAMBRANA, RIGIROZZI


************PUNTO 1***************
****AUMENTAMOS EL TAMAÑO MUESTRAL PARA VER QUE SUCEDE CON LOS ERRORES STANDARD
*Primero seteamos el modelo de base mostrado en clases.
clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

*notar la correlacion entre educacion e inteligencia.

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u


reg wage education intelligence a b



**Definimos un nuevo tamanio muestral mayor, de 1000
clear
set obs 1000
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)


gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u

reg wage education intelligence a b
*Lo que se observa con este mayor tamanio muestral es que se da una reduccion en el valor de los correspondientes errores estandar. Adicionalmente, vemos que se estima mejor los coeficientes, puntualmente el de educacion se aproxima aun mas a su verdadero valor, 0. 

********************************************************************************
************PUNTO 2***************
***AUMENTAMOS LA VARIANZA DEL TERMINO DE ERROR

*Seteamos nuevamente el modelo original:
clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

*notar la correlacion entre educacion e inteligencia.

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u


reg wage education intelligence a b

*Luego proponemos la modificacion en la varianza del termino de error
clear all

set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

gen education=int(intelligence/10+invnormal(uniform())*1)


gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*30+7)
gen wage=3*intelligence+a+2*b+u

reg wage education intelligence a b

*Con este aumento en la varianza del termino de error, vemos claramente que los valores de los errores estandar aumentan de forma significativa. Otra consecuencia es que se estima los coeficientes de manera muy sesgada con respecto a su verdadero valor.

****************************************************************************
************PUNTO 3*******************

*Ahora tomamos un modelo que solo considere a la variable inteligencia como regreso
* Con varianza de X=20

clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

*notar la correlacion entre educacion e inteligencia.

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u


reg wage education intelligence a b

*************************************
*CON VARIANZA X=50


clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*50+100)

*notar la correlacion entre educacion e inteligencia.

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u


reg wage education intelligence a b

*Vemos que los errores estandar del regresor intelligence se reducen significativamente al contar con mayor variabilidad. Esto se explica, en parte porque al tener mayor variabilidad en el regresor,se puede medir su efecto sobre y de una manera mas precisa.
*******************************************************************************
******PUNTO 4**********
clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

*notar la correlacion entre educacion e inteligencia.

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u


reg wage education intelligence a b

predict residuals, res
tabstat residuals, s (sum)

****veamos la suma de residuos con mayor variabilidad del regresor intelligence

clear

set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*50+100)

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u


reg wage education intelligence a b


predict residuals, res
tabstat residuals, s (sum)
*Lo que observamos es que, al aumentar la variabilidad en el regresor, al mismo tiempo se reduce la suma de los residuos.
********************************************************************************
******PUNTO 5**********

clear all

set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

/* We set the standard error of this variable so the correlation between education and intelligence is high (0.90 approximate).*/

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*30+7)
gen wage=3*intelligence+a+2*b+u

reg wage education intelligence a b


predict residuals, res
tabstat residuals, s (sum)

corr residuals intelligence a b education
*Vemos la ortogonalidad via la correlacion de los errores con cada uno de los regresores. Efectivamente, al ser 0 para cada uno, se da ortogonalidad.

*******************************************************************************
******PUNTO 6**********

*probemos predecir sin la variable que genera multicolinealidad y con ella.
clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)


gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u


reg wage intelligence a b
predict y_hat_1

reg wage education intelligence a b
predict y_hat_2 
corr y_hat_1 y_hat_2  
*Como la correlacion entre los y estimados es perfecta, la introduccion de un regresor altamente correlacionado con otro, no produce problemas al momento de estimar y.


********************************************************************************
******PUNTO 7**********
clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

/* We set the standard error of this variable so the correlation between education and intelligence is high (0.90 approximate).*/

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u



* Include education that is not in the Data Generating Process and it is highly correlated with intelligence. Note that coefficients and SE for a and b do not change, but the SE for the coefficient of intelligence changes, and a lot.
reg wage education intelligence a b

*planteamos el modelo en el que tenemos un regresor, inteligencia, con un error de medicion no aleatorio.

clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100) 
gen intelligencemed=int(invnormal(uniform())*20+100) + 4
/* We set the standard error of this variable so the correlation between education and intelligence is high (0.90 approximate).*/

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u


reg wage education intelligencemed a b

*Vemos un sesgo extremadamente grande para la variable inteligencia, que se contagia a la variable educacion, que tambien esta exageradamente sesgada, al estar altamente correlacionada.



*planteamos el modelo en el que tenemos un regresor, inteligencia, con un error de medicion aleatorio.

clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100) 
gen intelligencemed=int(invnormal(uniform())*20+100) + int(invnormal(uniform())*1+2)
/* We set the standard error of this variable so the correlation between education and intelligence is high (0.90 approximate).*/

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u


reg wage education intelligencemed a b
*Vemos un sesgo extremadamente grande para la variable inteligencia(aunque mayor que con un error no aleatorio), que se contagia a la variable educacion, que tambien esta exageradamente sesgada, al estar altamente correlacionada.


********************************************************************************
******PUNTO 8**********
clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

/* We set the standard error of this variable so the correlation between education and intelligence is high (0.90 approximate).*/

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u


reg wage education intelligence a b


*suest ols11 ols12, robust
predict residuals
tabstat residuals,s(v mean)



*******************************
*errores en Y (no aleatorio)

clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

/* We set the standard error of this variable so the correlation between education and intelligence is high (0.90 approximate).*/

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u
gen wagemed=3*intelligence+a+2*b+u + 8


reg wagemed education intelligence a b

predict residuals
tabstat residuals,s(v mean)

************************************

*errores en Y (aleatorio)
clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)


gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u
gen wagemed=3*intelligence+a+2*b+u + int(uniform()*4+100)


reg wagemed education intelligence a b

predict residuals
tabstat residuals,s(v mean)

*Notar el aumento en la media de los residuos.























