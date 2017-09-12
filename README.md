![bomo gif](https://github.com/HackBomo/Bomo/blob/master/Images/BomoGif.gif)
<iframe src="https://giphy.com/embed/o4cs9ONuLZRM4" width="270" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/motion-capture-vuforia-bomo-o4cs9ONuLZRM4">via GIPHY</a></p>

# BOMO
### AR 3D Motion Tracking App (PennApps Semi-Finalist Fall 2017)
*Built in Objective-C, C++, and Swift using Vuforia Object Tracking and SceneKit*

BOMO allows clinicians, coaches, and patients alike to easily and affordably quantify body movement.

DevPost Project Link: https://devpost.com/software/bomo

[![Demo Video](https://img.youtube.com/vi/T-njDnVP4bc9I/0.jpg)](https://www.youtube.com/watch?v=njDnVP4bc9I)

Not only can BOMO track joint flexion angles, which are useful for measuring range of motion, but also BOMO can track joint movement in 3d, allowing users to track overall joint stabliity, identify muscular imbalances, and analyze common dysfunctions such as lateral knee movement during walking and running…all with just a smartphone.


# How It Works
BOMO uses Vuforia for offline object tracking and SceneKit to build and render the 3d skeletal overlay. This prototype uses physical markers to track joint movement, but with further development, pose estimation technology and improved phone hardware will allow us to forgo the markers and track 3d motion natively like the Xbox kinect.

# Vuforia?... Why not ARKit?
Unfortunately, ARKit does not yet offer support for image/marker tracking, so we used Vuforia as the base library for our computer vision. Also, Vuforia is much faster.

# What BOMO really solves

### COST
Software to accurately track joint flexion, walking patterns, and body movement is extremely costly and hard to setup in a normal environment: e.g., a home, gym, or small doctor’s office.

### CONVENIENCE
In order to actually get accurate measurmenets, you likely have to go to a motion analysis lab and have the ability to access one in the first place.

### CONSISTENCY 
Physical therapists and doctors often don’t take enough care to consistently take accurate measurments and often “eyeball” their results.

![image](https://github.com/HackBomo/Bomo/blob/master/Images/Screenshots.jpg)

![image](https://github.com/HackBomo/Bomo/blob/master/Images/Stats%20Page.jpg)


