## RedLab UC

>Aplicación desarrollada en `Ruby on Rails 6.2.1` con `postgreSQL`

Plataforma para el registro y administración de la asistencia a laboratorios de fabricación de la Pontificia Universidad Católica de Chile. 



## Tabla de contenidos
1. [Acerca de](#acerca-de)
2. [Cómo Funciona](#Cómofunciona)
    * [Totem](#totem)
    * [Plataforma](#plataforma)
    * [API UC](#api-uc)
3. [Categorías de usuarios](#caterogías-de-usuarios)
4. [Registros](#Registros)


## Acerca de:

Este proyecto nace de la necesidad de hacer un levantamiento de datos respecto al uso de los Laboratorios de fabricación en la universidad.

Busca automatizar y simplificar el proceso de registro de asistencia por medio de la Tarjeta UC (TUC) y brindarle control al administrador por medio de señales visuales y sonoras para saber la [categoría de usuario](#categorías-de-usuario) que entra.


### Cómo funciona
EL sistema consta de tres actores.
* Totem
* Plataforma de administración
* API UC

El siguiente diagrama representa la comunicación entre los actores.

![](public/diagram.png#center)

### Totem
`Para ingresar a la documentación específica del totem `[click aquí](http://google.com)


Aparato físico dispuesto en la entrada de los laboratorios que tiene la finalidad de recabar la información desde la TUC. Se constituye de una pantalla touch la que permite interactuar con el usuario. 

El totem, diseñado en `python 3.x` envía una request HTTP a la [plataforma](#plataforma) con la información del usuario que ingresa. 

Las respuestas que puede recibir dicha request son:

* [Usuario nuevo](#categorías-de-usuario)
* [Usuario Registrado - No autorizado](#categorías-de-usuario)
* [Usuario Registrado - Autorizado](#categorías-de-usuario)

De acuerdo al tipo de respuesta, el totem entragará información visual y sonara para que el administrador del laboratorio conozca el usuario que acaba de ingresar. Además de generar un [registro en la plataforma](#registros)

### Plataforma
La plataforma se encarga de llevar los [registros](#registros) de ingreso y salida a los laboratorios. 

Permite a los administradores: 
* Autorizar (y cambiar a [usuario autorizado](#categorías-de-usuarios)) una vez que el usuario cumpla los requisitos del laboratorio. 
* Manejar la capacidad del laboratorio teniendo conocimiento de la cantidad de personas están haciendo uso del recinto. 
* Mantener información completa de los usuarios de manera fácil y directa.
* Inscribir de manera manual a usuarios no pertenecientes a la comunidad UC.

### API UC
La universidad dispuso para esta iniciativa una API con datos de las TUC y de las Personas UC. 
La API es consultada solo cuando el usuario que ingresa es [usuario nuevo](#categorías-de-usuarios) y pertenece a la comunidad UC, luego los datos son almacenados en la [plataforma](#plataforma)

### Categorías de usuarios
### Registros
