clear; %clear workspace variables

%Parameters of Pi circuit
C_s = 251.008e-12; %source side capacitance in Farads
C_l = 30.588e-12; %load side capacitance in Farads
L = 100e-9; %inductance value in Farads

%Load parameters
R_load = 100; %Resistance of load in Ohms
L_load = 1e-6; %Inductance of load in Henrys

%Input line parameters
Z_line = 50; %Input line impedance in Ohms
%Most RF transmission lines are about 50 Ohms

%Frequencies to plot
f_centre = 100e6;
f_width = 10e6;
n = 1000; %number of points to plot



%array of equally spaced frequency values
Freq = linspace(f_centre - (f_width/2), f_centre + (f_width/2), n);

%Calculate impedances of capacitors, inductor, and load
Z_s = -1i ./ (2 * pi * Freq * C_s);
Z_l = -1i ./ (2 * pi * Freq * C_l);
Z_ind = 1i * 2 * pi * Freq * L;
Z_load = R_load + 1i * L_load * 2 * pi * Freq;

%Calculate input impedance
Z_input = Z_ind + para(Z_l, Z_load);
Z_input = para(Z_s, Z_input);

%Reflection coefficient (and its modulus squared)
r = (Z_input - Z_line) ./ (Z_input + Z_line);
r_mod_sq = abs(r) .^ 2;


close all
figure;
hold on
plot(Freq * 1e-6, real(Z_input));
plot(Freq * 1e-6, imag(Z_input));
legend('Re(Z_{in})', 'Im(Z_{in})')
xlabel('Frequency / MHz')
ylabel('Impedance / \Omega')

figure;
hold on
plot(Freq * 1e-6, real(r));
plot(Freq * 1e-6, imag(r));
plot(Freq * 1e-6, r_mod_sq)
legend('Re(r)', 'Im(r)', '|r|^2')
xlabel('Frequency / MHz')


halfMax = (max(r_mod_sq) + min(r_mod_sq)) / 2;
f_1_index = find(r_mod_sq <= halfMax, 1, 'first');
f_2_index = find(r_mod_sq <= halfMax, 1, 'last');
FWHM = (f_2_index - f_1_index) * (f_width / n);
disp('FWHM of |r|^2 = ' + string(FWHM * 1e-6) + ' MHz')

function Z_para = para(Z_1, Z_2) %calculates parallel impedances
    Z_1_recip = 1 ./ Z_1;
    Z_2_recip = 1 ./ Z_2;
    Z_para = 1 ./ (Z_1_recip + Z_2_recip);
end
