function dp = load_defaults()

  % EE214 Parameters
  dp.ee214a.unCox = 50e-6;
  dp.ee214a.upCox = 25e-6;
  dp.ee214a.Vtn0 = 0.5;
  dp.ee214a.Vtp0 = -0.5;


  dp.vov = 0.2;
  dp.r_eq_1 = 6.25e3;
  dp.r_eq_2 = 6.25e3;

  % Transistor Definitions
  dp.MN1.type = 'nmos';
  dp.MN2.type = 'nmos';
  dp.MP3.type = 'pmos';
  dp.MP4.type = 'pmos';
  dp.MP5.type = 'pmos';
  dp.MN6.type = 'nmos';
  dp.MN7.type = 'nmos';
  dp.MP8.type = 'pmos';
  dp.MN9.type = 'nmos';
  dp.MN10.type = 'nmos';

  dp.MN1.name = 'dp.MN1';
  dp.MN2.name = 'dp.MN2';
  dp.MP3.name = 'dp.MP3';
  dp.MP4.name = 'dp.MP4';
  dp.MP5.name = 'dp.MP5';
  dp.MN6.name = 'dp.MN6';
  dp.MN7.name = 'dp.MN7';
  dp.MP8.name = 'dp.MP8';
  dp.MN9.name = 'dp.MN9';
  dp.MN10.name = 'dp.MN10';

  dp.MN1.uCox = dp.ee214a.unCox;
  dp.MN2.uCox = dp.ee214a.unCox;
  dp.MP3.uCox = dp.ee214a.upCox;
  dp.MP4.uCox = dp.ee214a.upCox;
  dp.MP5.uCox = dp.ee214a.upCox;
  dp.MN6.uCox = dp.ee214a.unCox;
  dp.MN7.uCox = dp.ee214a.unCox;
  dp.MP8.uCox = dp.ee214a.upCox;
  dp.MN9.uCox = dp.ee214a.unCox;
  dp.MN10.uCox = dp.ee214a.unCox;

  dp.MN1.vt = dp.ee214a.Vtn0;
  dp.MN2.vt = 0.870; % from spice
  dp.MP3.vt = dp.ee214a.Vtp0;
  dp.MP4.vt = dp.ee214a.Vtp0; 
  dp.MP5.vt = -.834; % from spice
  dp.MN6.vt = dp.ee214a.Vtn0;
  dp.MN7.vt = dp.ee214a.Vtn0;
  dp.MP8.vt = dp.ee214a.Vtp0;
  dp.MN9.vt = dp.ee214a.Vtn0;
  dp.MN10.vt = 1.0609; % from spice
  
  % Transistor sizing
  dp.MN1.w = 2e-6;
  dp.MN1.l = 2e-6;

  dp.MN2.w = 2e-6;
  dp.MN2.l = 2e-6;

  dp.MP3.w = 2e-6;
  dp.MP3.l = 2e-6;

  dp.MP4.w = 2e-6;
  dp.MP4.l = 2e-6;

  dp.MP5.w = 2e-6;
  dp.MP5.l = 2e-6;

  dp.MN6.w = 2e-6;
  dp.MN6.l = 2e-6;

  dp.MN7.w = 2e-6;
  dp.MN7.l = 2e-6;

  dp.MP8.w = 2e-6;
  dp.MP8.l = 2e-6;

  dp.MN9.w = 2e-6;
  dp.MN9.l = 2e-6;

  dp.MN10.w = 2e-6;
  dp.MN10.l = 2e-6;

end