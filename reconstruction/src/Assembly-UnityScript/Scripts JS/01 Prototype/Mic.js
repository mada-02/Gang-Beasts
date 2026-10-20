#pragma strict


var qSamples : int = 1024;
var refValue : float = 0.1;
var threshold : float = 0.02;
var rmsValue : float;
var dbValue : float;
var pitchValue : float;
private var samples : float[];
private var spectrum : float[];
var display : GUIText;
function Start () {
	samples = new float[qSamples];
	spectrum = new float[qSamples];
}

function AnalyzeSound () {
	audio.GetOutputData(samples, 0); // fill array with samples
	var i : int;
	var sum : float = 0;
	for (i = 0; i < qSamples; i++) {
		sum += samples[i] * samples[i]; // sum squared samples
	}
	rmsValue = Mathf.Sqrt(sum / qSamples); // rms = square root of average
	dbValue = 20 * Mathf.Log10(rmsValue / refValue); // calculate dB
	if (dbValue < -160) dbValue = -160; // clamp it to -160dB min
	// get sound spectrum
	audio.GetSpectrumData(spectrum, 0, FFTWindow.BlackmanHarris);
	var maxV : float = 0;
	var maxN : int = 0;
	for (i = 0; i < qSamples; i++) { // find max
		if (spectrum[i] > maxV && spectrum[i] > threshold) {
			maxV = spectrum[i];
			maxN = i; // maxN is the index of max
		}
	}
	var freqN : float = maxN; // pass the index to a float variable
	if (maxN > 0 && maxN < qSamples - 1) { // interpolate index using neighbours
		var dL : float = spectrum[maxN - 1] / spectrum[maxN];
		var dR : float = spectrum[maxN + 1] / spectrum[maxN];
		freqN += 0.5 * (dR * dR - dL * dL);
	}
	pitchValue = freqN * 24000 / qSamples; // convert index to frequency
}

function Update () {
	if (Input.GetKeyDown("p")) {
		audio.Play();
	}
	AnalyzeSound();
	if (display) {
		display.text = "RMS: " + rmsValue.ToString("F2") + " (" + dbValue.ToString("F1") + " dB)\n" + "Pitch: " + pitchValue.ToString("F0") + " Hz";
	}
}

