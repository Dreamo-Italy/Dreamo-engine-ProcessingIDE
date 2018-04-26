# Dreamo
Dreamo is a real-time, biosensor and music driven video generator. We designed it to be deeply customizable, but still approachable using the default configuration.

Visit [dreamo-italy.io](https://dreamo-italy.github.io/dreamo/) to learn more.

Follow [Dreamo](https://www.facebook.com/dreamoItaly/) on Facebook for important announcements.

Repository for "Dreamo" project | _Polytechnic of Turin_ |.

Current team *Francesco Cretti, Giovanni Bologni, Nicola Ruffino, Andrea Gambedotti, Lorenzo de Luca*.


## Installing

### Prerequisites
- [Processing 3 or higher] (https://processing.org/download/)
- "Minim" library installed on Processing ( Processing -> Sketch -> Import Library... -> Add Library... -> Search for "Minim" )
- "ControlP5" library installed on Processing (same way as Minim)
- "Grafica" library installed on Processing (same way as Minim)
- [Java 8 or higher](https://www.java.com/it/)

### Windows
Download the latest unstable [Dreamo release](https://github.com/Dreamo-Italy/Dreamo-engine/tree/develop), with "*Clone or Download*"->"*Download ZIP*"


## Documentation
If you want to know more about using Dreamo or developing code for Dreamo, keep reading this readme.

### Video plotting
Here follows a generic description of the classes of the program:

- *Particle* is the core visual-object class, from which a great number of different classes can be inherited (particles, stars, bubbles, squares...).

- *Scene* includes an array of particles and manages their update and drawing on screen.

- *Stage* includes an array of scenes and manages the passage from one scene to another.

### Audio Managing
- *DSP* is a static class containing digital signal processing methods
- *AudioManager* manages the input stream properties
- *AudioProcessor* manages the samples buffer and does common calculations (FFT, xcorr,...)
- *FeaturesExtractor* is a superclass with utilities methods for features extractors
- actual features extractor are inherited from FeaturesExtractor and contain the actual computational methods (ex: Dynamic, Timbre...)
- *Audio Decisor* calculates the "status" of audio and extract parameters useful for graphic generation

By participating, you are expected to uphold this code. To learn more, you can write to dreamoitaly@gmail.com
