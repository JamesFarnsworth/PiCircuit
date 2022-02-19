# PiCircuit
MATLAB scripts to calculate the optimal capacitance values of a Pi matching circuit and plot its frequency response.

This Pi-Match circuit can be used between a source and a load to ensure that there is no reflection of radio-frequency (RF) electrical signals when a source and load of differing impedances are connected.

![pimatch_lowpass](https://user-images.githubusercontent.com/18512577/154815869-31815f5b-520d-4cdb-b083-b40d3bdb13ca.png)

This is the particular form of Pi-Match circuit we are concerned with since it is the easiest to construct, and has low-pass characteristics that are more desirable in the application I was concerned with (minimising reflection back to an RF amplifier). The load studied is an inductor with large resistance and inductance, but negligible capacitance (although this can be easily generalised by adding on the capacitance contribution to the load impedance).

PiCircuitValues calculates the optimal capacitances to construct the circuit, for a given inductor. It achieves this by demanding that the real and imaginary parts of the circuit's input impedance match the input line impedance. This ensures there is no reflection at the intended frequency.

PiCircuitPlot takes given capacitance and inductance values for the Pi circuit (and its load), and plots the input impedance of the Pi circuit and the reflection coefficient over different frequencies. It also calculates the full width at half-maximum (FWHM) of the dip in the reflection coefficient, providing a measure of the frequency bandwidth over which reflection is prevented effectively.
