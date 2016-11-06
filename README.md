# dreamo-project
Repository for "Dreamo" project |
_Polytechnic of Turin_ |
_Summer 2016_ |
*__Francesco Cretti, Nicola Ruffino, Giovanni Bologni, Luciano Prono__*.




Generic description of the classes of the program:


- PARTICELLA is the core visual-object class, from which a great number of different classes can be inherited (particles, stars, bubbles, squares...).

- The SCENE includes the background, passed by reference, and an array with the addresses of the active particles, thus allowing the share of the particles between more then one scene; this is useful for the scene transitions. 

- SCHERMO is the class that manages the drawing. It includes the address of the scene to be showed. 
 
- A scene transition happens if a certain time has elapsed (class TIMELINE), or if there're particular biomedic input (class INPUT SENSORIALI) or if something happens on the audio input (class ELABORAZIONE AUDIO).
 These 3 classes are also useful to inform the current scene of any input variation.

- DATA is the class which contains the arrays of every kind of particle, where "particle" is a visual object; DATA also includes pointers to the backgrounds and the scenes.
 










