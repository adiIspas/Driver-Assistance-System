# Driver-Assistance-System

This bachelor's thesis proposes to approach a topic of major interest in the last period of time, namely the implementation of traffic assistance systems for cars.

The notion of a traffic assistance system means the following:
1. Detection of current lane of the car;
2. Detecting the car on the current lane;
3. Estimating distance from the car detected on the current lane;
4. Estimating the relative speed of the car on the current lane to the car from which the video is recorded.

The paper presents quantitative and qualitative results in the experimental evaluation chapter. We show that the app detects cars and lanes with a very high accuracy, around 90%, and can run under different lighting conditions.

From the implementation point of view, the application was developed in Matlab and run on an Intel i7 Quad Core, 2.60 GHz processor and 8 GB RAM. The OpenCV library was included in Matlab and used in various circumstances to which functions from the VLFeat library have been added.

The runtime of the entire process has achieved a mean runtime per frame of 0.05 seconds on 360p videos, which means real-time running of the entire application with a processing capacity of up to 30 frames per second.

The paper can be found [here](https://github.com/adiIspas/Driver-Assistance-System/tree/master/lucrare_scrisa).

Demo can be found [here](https://www.youtube.com/watch?v=ldqapheStqY)
