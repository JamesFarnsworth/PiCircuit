clear;

%Input parameters
Freq = 100e6; %Desired frequency for the circuit to work at, in Hz
Z_line = 50; %Impedance of input line (usually 50 Ohms for RF signals)

%Load parameters
R_load = 100; %Ohms
L_load = 1e-6; %Henrys

%Fixed Pi-circuit inductance value
L = 140e-9; %Henrys

%Initial guesses of capacitance
C_s_initial = 40e-12; %Farads
C_l_initial = 10e-12; %Farads



%Calculate impedances of the load and the inductor from given values
Z_load = R_load + 1i * 2 * pi * Freq * L_load;
Z_ind = 1i * 2 * pi * Freq * L;

syms C_s C_l %creates symbolic variables for the capacitances
Z_s = -1i / (2 * pi * Freq * C_s);
Z_l = -1i / (2 * pi * Freq * C_l);
Z_input = para(Z_s, Z_ind + para(Z_l, Z_load)); %input impedance of pi-circuit

%Use vpasolve to match real and imaginary parts of pi-circuit impedance to input line
[C_s_soln, C_l_soln] = vpasolve([real(Z_line) == real(Z_input), imag(Z_line) == imag(Z_input)], [C_s, C_l], [C_s_initial, C_l_initial]);


disp('Optimal source-side capacitance Cs = ' + string(C_s_soln * 1e12) + ' pF')
disp('Optimal load-side capacitance Cl = ' + string(C_l_soln * 1e12) + ' pF')

%substitute in solution to find Z_input
C_s = C_s_soln;
C_l = C_l_soln;
Z_input = double(subs(Z_input));
disp('Giving input impedance Z_input = ' + string(Z_input) + ' Ohms');
r = (Z_input - Z_line) / (Z_input + Z_line);
disp('(and reflection coefficient r = ' + string(r) + ')')


function Z_para = para(Z_1, Z_2) %calculates impedance values in parallel
    Z_1_recip = 1 / Z_1;
    Z_2_recip = 1 / Z_2;
    Z_para = 1 / (Z_1_recip + Z_2_recip);
end
