# app_a01643374

Aplicación móvil para Android que permite contar células en imágenes de microscopio de forma automática utilizando un modelo entrenado de Inteligencia Artificial.

## Getting Started

La aplicación analiza imágenes de células bajo el microscopio, y detecta en el grado de ajuste del modelo, el número de células presentes en ellas. El usuario puede cargar una 
imagen desde la galería de su celular o tomarla directamente con la cámara, y la app devuelve el conteo en segundos.

El flujo de funcionamiento es el siguiente:

1- El usuario selecciona o toma una foto del microscopio.
2- La imagen es convertida a base64.
3- La imagen se envía a una API externa en Roboflow, de donde se obtuvo el modelo entrenado para identificar células.
4- El modelo analiza la/las imágenes y detecta las células.
5- Se imprime el número de células detectadas en la aplicación de Android.

## Notas
El URL del modelo de IA obtenido de RoboFlow es el siguiente:
https://serverless.roboflow.com/cells-itbmk/8

La API es la siguiente:
UzgZ82Wnlt92F2to1Za3

y los parámetros para el modelos usados en este caso fueron:
confidence=70
max_detections=1000


## Archivos importantes del proyecto:

- screens/home_screen.dart
Esta es la pantalla principal de la app, en su código, se encuentran las funciones necesarias para que el usuario pueda abrir el menú y su galería y elegir una imagen, así como para que se pueda abrir la cámara y tomar una foto. Además está la función _analyzeImage(), que hace la conversión de la imagen a base64, la redirecciona a la API de Roboflow y procesa la respuesta con el conteo de células.

- widgets/image_preview.dart
Es un widget que muestra la imagen seleccionada o capturada en la app. De no haber seleccionado ninguna, aparecerá un texto con instrucciones de que hacer. Una vez cargada la imagen, aparece un texto que menciona que la imagen está lista para ser analizada.

- widgets/result_card.dart
Presenta el resultado dado por el análisis de la imagen y lo presenta con cierto diseño.

- android/app/src/main/AndroidManifest.xml
Contiene los permisos necesarios para que la app funcione correctamente en el dispositivo.

## Requisitos

- Android 6.0 o superior
- Conexión a internet
- Permiso de cámara y galería

## Hecho por
Luis Jorge Lizárraga Mardueño - A01643374