function rp = parallel_r(varargin)
  den = 0;
  for i = 1:nargin
    den = den + 1/varargin{i};
  end
  rp = 1/den;
end