function vo = resistor_div(rt, rb, vt, vb)
  current = (vt - vb) / (rt + rb);
  vo = current * rb + vb;
end