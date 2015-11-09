function transistor = calc_idsat(transistor)
  transistor.id = 1/2 * transistor.k * transistor.vov ^2;
end