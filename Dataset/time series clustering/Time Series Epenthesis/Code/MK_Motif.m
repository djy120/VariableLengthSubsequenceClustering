% % MK Algorithm version 2 % %
% Find top-1 motif from TS with Excluded list
% ======================================
% == Input ==
% TS  : time series
% M   : motif length
% EX  : Excluded list, list of the starting positions of used subsequence
% or
% Mark: the sequence of size TS, 1-used position, 0-available position
% ======================================
% == Output ==
% Motif: List of motif 
%        when Motif = [d_motif pos_mA pos_mB]
% EX  : Excluded list
% ======================================
% last updated: 23 Nov 2010
function [Motif]= MK_Motif3(TS,M,Mark)
    R = 10;
    N = length(TS);
    Motif = [inf 0 0];
    
%     if (~exist('Mark','var'))
%         % Create array Mark from EX, mark the prohibit positions
%         EX = sort(EX);
%         Mark = zeros(1,length(TS));
%         for i=1:length(EX)
%            st = EX(i);
%            en=min(st+M-1, N);
%            Mark(st:en)=1; 
%         end
%         %disp(sprintf('Number of Mark = %d',sum(Mark)));
%     end
%     
    t_ref = cputime;
    bsf = inf;    
    gap = M;
    Num = N-M+1;
    RDist = zeros(Num,R);
    FixR=[1 2 3 4 5 6 7 8 9 10];  %For test only   
    for i=1:R
       r = FixR(i);               %For test only
       %r=ceil(rand*Num);
       for j=1:Num
           if (r==j)
               RDist(j,i)=0;
               continue;               
           end
           if (Mark(j)==1||Mark(j+M-1)==1)
               continue;
           end
           
           d = Dist_ED(TS(r:r+M-1), TS(j:j+M-1));
           RDist(j,i) = d;
           
           if (Mark(r)==1||Mark(r+M-1)==1)
               continue;
           end
           
           if ((d<bsf)&&(abs(j-r)>gap))
              bsf = d;
              Motif = [d min(j,r) max(j,r)];
           end
       end
    end    
    %disp(sum(sum(RDist)));
    
    [s six] = sort(std(RDist),'descend');
    [D Dix] = sort(RDist(:,six(1)));
    
%     disp(sprintf('Finish Phase 1 in time %.2f sec',cputime-t_ref));
    t_ref = cputime;
    
    off=0; abandon=false;
    while ((abandon==false)) %||(off<=gap))
       off=off+1;
       if (off >= Num)
           break;
       end
       
       abandon=true;
       for j=1:Num-off
          a = Dix(j);
          b = Dix(j+off);
          reject = false;

          for i=1:R
              r = six(i);
              if (abs(RDist(a,r)-RDist(b,r)) > bsf)
                  reject = true;
                  break;
              end          
          end           
          if (reject==false)
              abandon = false;      
              
              if (abs(a-b)<=gap)
                  continue;
              end    
              
              if (Mark(a)==1||Mark(a+M-1)==1||Mark(b)==1||Mark(b+M-1)==1)
                  continue;
              end

              %d = Dist_ED(TS(a:a+M-1), TS(b:b+M-1));
              d = Dist_ED2(TS(a:a+M-1), TS(b:b+M-1),bsf);
              if (bsf > d)
                 bsf = d;
                 Motif = [bsf min(a,b) max(a,b)];
              end
          end
       end        
    end
    
%     disp(sprintf('Finish Phase 2 in time %.2f sec',cputime-t_ref));
%     disp(Motif);    
end


%%
function d=Dist_ED(ts1,ts2)
    d=sqrt(sum( (zscore(ts1)-zscore(ts2)).^2 ));
end



%% ED with early abandon
function sum=Dist_ED2(ts1,ts2,bsf)
    bsf = bsf^2;
    ts1 = zscore(ts1);
    ts2 = zscore(ts2);
    d = inf;
    sum =0 ;
    for i=1:length(ts1)
        sum = sum+((ts1(i)-ts2(i))^2);
        if (sum>=bsf)            
            break;
        end
    end    
	if (sum < bsf)
        sum = sqrt(sum);
    else
        sum = inf;
    end
end