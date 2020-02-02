function p = gf(x,m,prim_poly)
%GF  Create a Galois field array.
%   X_GF = GF(X,M) creates a Galois field array from X 
%   in the field GF(2^M), for 1<=M<=16. The elements of X must be
%   integers between 0 and 2^M-1. X_GF behaves like
%   a MATLAB array, and you can use standard indexing and 
%   arithmetic operations (+, *, .*, .^, \, etc.) on it.
%   For a complete list of operations you can perform on
%   X_GF, type "GFHELP".
%
%   X_GF = GF(X,M,PRIM_POLY) creates a Galois field array from X
%   and uses the primitive polynomial PRIM_POLY to define 
%   the field. PRIM_POLY must be a primitive polynomial in 
%   decimal representation. For example, the polynomial D^3+D^2+1 
%   is represented by the number 13, because 1 1 0 1 is the binary
%   form of 13.
%
%   X_GF = GF(X) uses a default value of M = 1.
%
%   Example:
%
%     A = gf(randi([0 7],4,4),3)    % 4x4 matrix in GF(2^3)
%     B = gf(1:4,3)'                % A 4x1 vector
%     C = A*B   
%
%   See also GFHELP, GFTABLE.

%    Copyright 1996-2011 The MathWorks, Inc.


if nargin == 0
    p.x = [];
    p.m = 1;
    p.prim_poly = uint32(1);
    p = class(p,'gf');
elseif isa(x,'gf')
    p = x;
else
    
    if  ~all(all(isfinite(double(x))))
        error(message('comm:gf:ElementsOfXInfOrNaN'));                    
    end
    
    if nargin == 1
        m = 1;
    end
    
    
    %Checking for SCALAR m before doing the MOD operation if x is double
    
    if mod(m,round(m))~=0
        error(message('comm:gf:NonIntegerM'));
    end
    
    if numel(m)~=1
        error(message('comm:gf:NonScalarM'))
    end
    
    if m<1 || m>16
        error(message('comm:gf:RangeM1To16'))
    end
    
  
if(any(any(x<0 | x>2^m-1)))
    error(message('comm:gf:InvalidX'));
end
  p.x = uint32(x);
  p.m = m;

   % Define vector of default primitive polynomials:
   p_vec = [3 7 11 19 37 67 137 285 529 1033 2053 4179 8219 17475 32771 69643];

  % if the primitive polynomial is passed in, and is not one of the
  % defaults, it needs to be checked. if its not passed in, use default.
  need2CheckPoly = 0;
  if(nargin>2)
      if(prim_poly) ~= uint32(p_vec(m));
          need2CheckPoly = 1;  
      else
          p.prim_poly=uint32(p_vec(m));
      end
  else
       p.prim_poly=uint32(p_vec(m));
  end
  
  if need2CheckPoly
      %check to make sure prim_poly is a integer, not a polynomial
      if(numel(prim_poly)>1)
          error(message('comm:gf:NonScalarPrim_Poly'));
      end
    p.prim_poly = uint32(prim_poly);
    % check that prim_poly is actually a primitive polynomial, and in the
    % corect range for the value of M.
    if(~isprimitive(double(prim_poly)))
        warning(message('comm:gf:primPolyPrim'));
    end
    if(prim_poly > 2^(m+1)-1 || prim_poly <0 )
        error(message('comm:gf:primPolyRange'));
    end
    
  end
  p = class(p,'gf');
end

