% Input: X ts is a subsequence, a row vector
% Output: DZ is a discrete subsequence in range [1,card]
function DZ = DNorm_Unif(X, card)
    if (~exist('card','var')), card=64; end;
      
    mn = min(X);
    mx = max(X);
    DZ = round((X-mn)/(mx-mn)*(card-1)) + 1;
end