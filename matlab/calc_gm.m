function transistor = calc_gm(transistor)
  transistor.gm = sqrt(2 * transistor.id * transistor.uCox * transistor.w / transistor.l);
end