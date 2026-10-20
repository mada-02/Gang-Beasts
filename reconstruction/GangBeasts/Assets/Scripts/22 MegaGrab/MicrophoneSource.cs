using UnityEngine;

public class MicrophoneSource : MonoBehaviour
{
	public int qSamples = 1024;

	public float refValue = 0.1f;

	public float threshold = 0.02f;

	public float rmsValue;

	public float dbValue;

	public float pitchValue;

	private float[] samples;

	private float[] spectrum;

	public GUIText display;

	private void Start()
	{
		samples = new float[qSamples];
		spectrum = new float[qSamples];
	}

	private void AnalyzeSound()
	{
		audio.GetOutputData(samples, 0);
		float num = 0f;
		for (int i = 0; i < qSamples; i++)
		{
			num += samples[i] * samples[i];
		}
		rmsValue = Mathf.Sqrt(num / (float)qSamples);
		dbValue = 20f * Mathf.Log10(rmsValue / refValue);
		if (dbValue < -160f)
		{
			dbValue = -160f;
		}
		audio.GetSpectrumData(spectrum, 0, FFTWindow.BlackmanHarris);
		float num2 = 0f;
		int num3 = 0;
		for (int i = 0; i < qSamples; i++)
		{
			if (spectrum[i] > num2 && spectrum[i] > threshold)
			{
				num2 = spectrum[i];
				num3 = i;
			}
		}
		float num4 = num3;
		if (num3 > 0 && num3 < qSamples - 1)
		{
			float num5 = spectrum[num3 - 1] / spectrum[num3];
			float num6 = spectrum[num3 + 1] / spectrum[num3];
			num4 += 0.5f * (num6 * num6 - num5 * num5);
		}
		pitchValue = num4 * 24000f / (float)qSamples;
	}

	private void Update()
	{
		if (Input.GetKeyDown("space"))
		{
			audio.Play();
		}
		AnalyzeSound();
		if ((bool)display)
		{
			display.text = "RMS: " + rmsValue.ToString("F2") + " (" + dbValue.ToString("F1") + " dB)\nPitch: " + pitchValue.ToString("F0") + " Hz";
		}
	}
}
