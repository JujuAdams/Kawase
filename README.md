<h1 align="center">Kawase 1.0.0</h1>

<p align="center">Kawase dual filter blur for GameMaker Studio 2</p>

<p align="center"><b>@jujuadams</b></p>

<p align="center">Chat about Kawase on the <a href="https://discord.gg/8krYCqr">Discord server</a></p>

&nbsp;

&nbsp;

A Kawase blur is a close approximation of a Gaussian blur, but one that is more performant and requires slightly less texture memory. Kawase blurs were developed for use with [bloom](https://en.wikipedia.org/wiki/Bloom_(shader_effect)) in mind but can realistically be used anywhere blurring is needed.

This repo demonstrates an implementation of Kawase dual filter blur, based on [Masaki Kawase](https://www.mobygames.com/developer/sheet/view/developerId,180202/)'s work shown in [his 2003 GDC talk](http://genderi.org/frame-buffer-postprocessing-effects-in-double-s-t-e-a-l-wreckl.html). It is unfortunately quite hard to find detailed information on this technique despite its advantages, but this [Intel videp](https://software.intel.com/content/www/us/en/develop/videos/improving-real-time-gpu-based-image-blur-algorithms-kawase-blur-and-moving-box-averages.html) does a reasonable job of explaining the basic principles at work.

*For Gaussian or sigmoid blur, please see [my other blur repo](https://github.com/JujuAdams/blurs).*
