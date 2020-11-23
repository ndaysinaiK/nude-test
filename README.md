# NudeNet_Flutter

This is an example of how to use the NudeNet model in a flutter app. 

The pre-trained model can be found here https://github.com/notAI-tech/NudeNet


Steps

----

1. Install flutter ( flutter channel stable): https://flutter.dev/docs/get-started/install?gclid=CjwKCAiAtej9BRAvEiwA0UAWXsbdQkuR73-UtVp58l50mlCbb38_dR7qlTUazhnaSgmNuL82lsF2xBoCRcoQAvD_BwE&gclsrc=aw.ds 



2. Fork or download this project 



3. cd into the folder and run `flutter run`



Test it using nude photos and decent photos on your smartphone or in the emulator.



Note: - The model is not 100% accurate, sometimes it detects a banana as an unsafe picture. I tested it on android device only





How did I make it run on the device from scratch?

-------------------------------------------------

0. Create a new flutter project: https://flutter.dev/docs/get-started/codelab#step-1-create-the-starter-flutter-app

1. Download the classifier.tflite file from https://github.com/notAI-tech/NudeNet/releases 

2. Create a folder "assets" in the root of your project directory

3. Create labels.txt file under assets/ and add these lines :  

   ` 0 safe`

    `1 unsafe`

4. Copy classifier.tflite into the assets folder

5. Go to pubspec.yaml file and add these dependencies :

   tflite: any

   image_picker: ^0.6.2+3



6.Run: `flutter pub get`

7. Go to android\app\build.gradle and add theses lines below `release {}`:

   `aaptOptions{`

     ` noCompress 'tflite'`

     ` noCompress 'lite'`

  ` }`

8. In the same file (android\app\build.gradle) check if the minSdkVersion in `defaultConfig{}` is 19, if not set it to 19 (`minSdkVersion 19`)

9. Restart your IDE (vscode, android studio, etc)

10. Delete all the code in lib/main.dart and paste the lib/main.dart into your main.dart

11. Launch the app: `flutter run` 





Good luck!!!

The demo ? email me at kabulo_nday@kookimn.ac.kr 

Credit : https://github.com/notAI-tech/NudeNet 
