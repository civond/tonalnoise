<h1>Noise Removal from Audio Signal</h1>
<h2>Overview</h2>
<div>
    In this project, I compared and evaluated the effectiveness of a lowpass Butterworth (filter #2) and a N-point moving average (filter #1) in removing high frequency noise from a audio signal.<br/><br/>
    Additionally, the audio signal contains a tonal noise at 400 Hz, which I nullified with a 4th order IIR notch filter. <br/>
</div>

<h2>Results</h2>
The results from the butterworth filter yielded much better results. However other filters such as Chebeshev type II or elliptic filter may yield even better results due to a sharper transition band.

<img src="Figures/Audio.jpg" width="500px"></img><br/>
<img src="Figures/FreqResp.jpg" width="500px"></img><br/>
<img src="Figures/PoleZero.jpg" width="500px"></img><br/>
