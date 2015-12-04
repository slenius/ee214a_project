function a = sum_mos_area(varargin)
  a = 0;
  for i = 1:nargin;
    a = a + varargin{i}.l * varargin{i}.w;
  end
  a = a * 1e6;
end