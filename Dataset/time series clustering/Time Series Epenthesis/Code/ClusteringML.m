function [Clustering] = ClusteringML(TS, MM, MaxStep)      
    if (~exist('MaxStep','var')), MaxStep=100; end;
    TS = TS(:)';
    %clc;
    t_ref0 = cputime;
    
    
    Mark = zeros(1,length(TS));
    Cluster = [];
    ClusterPath = {};
    Cost_Add = [inf 0 0 0];
    ActionList(1,:) = [0 0 0];

    % Initial Motif variable
    for k=1:length(MM)
        Motif(k,:) = [inf 0 0 MM(k)];
    end
    
    step=1; 
     NoMotif(1:length(MM)) = false;
    while (step<MaxStep) %% Fix at most 100 steps
        disp(sprintf(' ===== Step %d ======',step));
        t_ref1 = cputime;   
        
        disp(' -- Create New Cluster --');
        %%% Motif Discovery %%%
        m_index = 0;
        for k=1:length(MM)
            M=MM(k);            
            if (k>1),
                if (NoMotif(k-1)==true),
                    NoMotif(k)=true;
                end
            end
            
            if ( NoMotif(k) == true)
                Cost_Create(k) = inf;
                fprintf('No more motif of length:%d\n',M);                
            else
                if (Motif(k,1)==inf)
                    fprintf('Finding motif of length:%d .... ',M);
                    t_ref = cputime;        
                    motif = MK_Motif(TS,M,Mark);                     
                    Motif(k,:) = [motif, M];                
                    if (Motif(k,1)==inf)
                       NoMotif(k)=true; 
                    end
                    fprintf('motif ED:%.2f @[%d, %d]   Finish in %.2f sec\n',motif(1,1),motif(1,2),motif(1,3),cputime-t_ref);                                       
                else
                    disp(sprintf('Motif of length:%d  is ready.',M));
                end       
                
                [Cost_Create(k)]= CostIfCreate(TS,Mark,Cluster,Motif(k,:));                                

            end            
        end
        [cost_create m_index] = min(Cost_Create);

        
        disp(' -- Add to current Cluster --');     
        Cost_Add(:,1) = inf;
        cost_add=inf;       

        [Cost_Add] = CostIfAddML(TS,Mark,Cluster,Cost_Add,MM);
        [cost_add a_index] = min(Cost_Add(:,1)); 
           
                
        disp(' -- Merge 2 Clusters --');
        cost_merge=inf;
        
        [cost_merge TmpCluster MergeInfo] = CostIfMergeML(TS,Mark,Cluster);
           
        fprintf('Cost=>Create:%.2f,  Add:%.2f,   Merge:%.2f\n',cost_create, cost_add, cost_merge);
        min_cost = min([cost_create, cost_add, cost_merge]);
        if (min_cost == inf),
            break;
        end
        
        if (cost_create == min_cost)
            M = MM(m_index);
            
            [Cluster Mark] = CreateNewCluster(TS,Mark,Cluster,Motif(m_index,:));  
            ActionListML(step,:)=[1 Motif(m_index,2) Motif(m_index,3) M];
            disp(sprintf('Choost to Create Cluster    from Motif Len:%d, pos1:%d, pos2:%d',M,Motif(m_index,2),Motif(m_index,3)));
        elseif (cost_add == min_cost)     
            pos = Cost_Add(a_index,2);
            cid = Cost_Add(a_index,3);
            M   = Cost_Add(a_index,4);
            [Cluster Mark] = AddToCluster(TS,Mark,Cluster,pos,cid,M);
            ActionListML(step,:)=[2 pos cid M];
            disp('Choose to Add ');           
        elseif (cost_merge == min_cost)    
            Cluster = TmpCluster;
            cid1=MergeInfo(1);
            cid2=MergeInfo(2);            
            M   =MergeInfo(3);            
            
            ActionListML(step,:)=[3 cid1 cid2 M];
            disp('Choose to Merge 2 Clusters');
        end    
        
        %%% Before starting next round - Remove motif 
        % % Remove the motifs if the positions inside them are already used        
        for k=1:length(MM)
            if (Motif(k,1)~=inf)
                a=Motif(k,2);
                b=Motif(k,3);
                M=Motif(k,4);                
                %%%%%%%%%% Better to change here %%%%%%%%%%%%%%
                ChkM = [0, MM(MM<=M)-1];
                if (any(Mark(a+ChkM)==1) || any(Mark(b+ChkM)==1))
                    Motif(k,:) = [inf 0 0 0];      % in next round, do motif discovery again
                end
            end  
        end
        % % Remove the added subsequence if some positions inside them are already used
        for ci=1:size(Cost_Add,1)
           if (Cost_Add(ci,1) ~= inf)
               a = Cost_Add(ci,2);
               M = Cost_Add(ci,4);
               ChkM = [0,  MM(MM<=M)-1];
               if (any(Mark(a+ChkM)==1))
                    Cost_Add(ci,:) = [inf 0 0 0];      % in next round, do find added cluster again
               end
           end
        end
        

        %DisplayClusterA(TS,Cluster,1);
        DList(step)=min_cost;
        ClusterPath{end+1} = Cluster;
        
        disp(sprintf('.. Finish Step %d in %.2f sec',step,cputime-t_ref1));
%         if (length(DList)>3)&&(DList(end-3) > 0),
%             disp('Terminated because min_cost > 2');
%             break; 
%         end;        
        step = step+1; 
        save;
    end  
    Clustering.TS    = TS;
    Clustering.MM    = MM;
    Clustering.CPath = ClusterPath;
    Clustering.AList = ActionListML;
    Clustering.DList = DList;    
    disp(sprintf('Finish All %.2f sec',step,cputime-t_ref0));
end

%%
function d=ED(ts1,ts2)
    d = sqrt(sum((ts1-ts2).^2));     
end

%% Note: motif is a struct
function [cost_create]= CostIfCreate(TS,Mark,Cluster,motif)
    if (motif(1,1)==inf),  cost_create=inf; return; end
        
    clen = length(Cluster);        
    a = motif(1,2);
    b = motif(1,3);
    M = motif(1,4);
    ts1 = DNorm_Unif(TS(a:a+M-1));
    ts2 = DNorm_Unif(TS(b:b+M-1));
    %%% BUG_ROUND    
    center = round((ts1+ts2)/2);

    Mark(a:a+M-1)=1;
    Mark(b:b+M-1)=1;
    
    Xshf=0;    
    Cluster(clen+1).elm(1,:) = [a, M, Xshf];
    Cluster(clen+1).elm(2,:) = [b, M, Xshf];        
    Cluster(clen+1).cenTS = center;
    Cluster(clen+1).cenM = M;
    Cluster(clen+1).minXs = 0;
    Cluster(clen+1).maxXs = 0;
    Cluster(clen+1).minM = M;
    Cluster(clen+1).maxM = M;    
    
    %%% New MDL: Bits Save / length
    diff1 = MDL(ts1-center);
    diff2 = MDL(ts2-center);    
    MDL_OLD = (MDL(ts1)+MDL(ts2))/M;
    MDL_NEW = (MDL(center)+ min(diff1,diff2))/M;
    cost_create = MDL_NEW - MDL_OLD;   
end


%%
function [Cluster Mark] = CreateNewCluster(TS,Mark,Cluster,motif)    

    clen = length(Cluster);        
    a = motif(1,2);
    b = motif(1,3);
    M = motif(1,4);
    ts1 = DNorm_Unif(TS(a:a+M-1));
    ts2 = DNorm_Unif(TS(b:b+M-1));
    center = round((ts1+ts2)/2);

    Xshf=0;    
    Cluster(clen+1).elm(1,:) = [a, M, Xshf];
    Cluster(clen+1).elm(2,:) = [b, M, Xshf];        
    Cluster(clen+1).cenTS = center;
    Cluster(clen+1).cenM = M;
    Cluster(clen+1).minXs = 0;
    Cluster(clen+1).maxXs = 0;
    Cluster(clen+1).minM = M;
    Cluster(clen+1).maxM = M;
    
    if (any(Mark(a:a+M-1)) || any(Mark(b:b+M-1)))
        fprintf('Warning!! CreateNewCluster:: Mark twice!!\n');
        pause(1);
    end
    
    Mark(a:a+M-1)=1; 
    Mark(b:b+M-1)=1;
end



%%
function [Cost_Add] = CostIfAddML(TS,Mark,Cluster,Cost_Add,MM)           
    if (length(Cluster) < 1),
        Cost_Add = [inf 0 0 0];
        return;
    end
    
    for ci=1:length(Cluster) 
        [Cost_Add(ci,:)] = FindAddedClusterML(TS,Mark,Cluster,ci,MM);
        cadd = Cost_Add(ci,:);
        fprintf('Add=> cid:%d, ts:%d, M=%d,  cost=%.2f\n',cadd(3),cadd(2),cadd(4),cadd(1));         
    end
end


%% Brute Force to find the next candidate to merge
function [cost_Add] = FindAddedClusterML(TS,Mark,Cluster,ci,MM)     
    
    cenTS = Cluster(ci).cenTS;       
    M = Cluster(ci).cenM;
    
    bsf_ed = inf;
    for p=1:length(TS)-M+1
        ChkM = [0,  MM(MM<=M)-1];
        if (any(Mark(p+ChkM)==1))
            continue;
        end      
        

        ed = ED(cenTS,DNorm_Unif(TS(p:p+M-1)));
        if (bsf_ed > ed)
            bsf_ed  = ed;                
            bsf_pos = p;
            bsf_cid = ci; 
        end                
    end

    if (bsf_ed==inf)
       cost_Add = [inf 0 0 0];
    else
        %%% New MDL: Bits Save / length
        MDL_OLD1 = MDL_Cluster_i(TS,Cluster(bsf_cid))/M;
        MDL_OLD2 = MDL(DNorm_Unif(TS(bsf_pos:bsf_pos+M-1)))/M;
        MDL_OLD = MDL_OLD1 + MDL_OLD2;        
        
        cen1 = Cluster(bsf_cid).cenTS;
        
        Cluster = AddToCluster(TS,Mark,Cluster,bsf_pos,bsf_cid,M);
        cen2 = Cluster(bsf_cid).cenTS;
        
        %%% New MDL: Bits Save / length
       MDL_NEW = MDL_Cluster_i(TS,Cluster(bsf_cid))/M;
       cost = MDL_NEW - MDL_OLD;              
       cost_Add = [cost bsf_pos bsf_cid M];
    end
end


%%
function [Cluster Mark] = AddToCluster(TS,Mark,Cluster,pos,cid,M)    
    Mark(pos:pos+M-1)=1;
    Cluster(cid).elm(end+1,:) = [pos M 0];
    n = size(Cluster(cid).elm,1);
    old_cen = Cluster(cid).cenTS;
    new_cen = round(( (n-1)*old_cen + DNorm_Unif(TS(pos:pos+M-1)) )/n);
    Cluster(cid).cenTS = new_cen;
end
    

%%
function [cost Cluster MergeInfo] = CostIfMergeML(TS,Mark,Cluster)   
     if (length(Cluster) < 2), cost=inf; MergeInfo = [0 0 0]; return; end;         
     [Cluster MergeInfo cost] = Find2NearestClustersML(TS,Cluster);
     fprintf('Best Merge=> c1:%d, c2:%d,  cost=%.2f\n',MergeInfo(1), MergeInfo(2), cost);  
end


function [FCluster MergeInfo cost] = Find2NearestClustersML(TS,Cluster)   
    FCluster = Cluster;
    MergeInfo = [0 0 0];
    cost = inf;
    bsf_mdl = inf;
    for c1 = 1:length(Cluster)
        cen1 = Cluster(c1).cenTS;        
        M1   = length(cen1);
        N1   = size(Cluster(c1).elm,1);
        bsf_ed = inf; 
        for c2 = c1+1:length(Cluster)
            cen2 = Cluster(c2).cenTS;        
            M2   = length(cen2);
            if (c1==c2), continue; end; 
            N2   = size(Cluster(c2).elm,1);
            % Find best position of merging center using ED
                        
            Mmax = M1+M2;
            for x = 1:Mmax-M2
                ts1 = [            cen1, zeros(1,M2+x-M1)];
                ts2 = [zeros(1,x), cen2, zeros(1,M1-M2-x)];      
%                 
                ts1_s = cen1(x+1:min(M1,M2+x));
                ts2_s = cen2(1:min(M1-x,M2));
                new_cen = (ts1_s*N1 + ts2_s*N2)/(N1+N2);
                
                Mc = length(new_cen);
                part1=[]; part2=[];
                if (M1>Mc),  part1 = cen1(1:x); end
                if (M1>M2+x),  
                    part2 = cen1(M2+x+1:M1); 
                else
                    part2 = cen2(M1-x+1:M2);
                end
                new_cen = [part1, new_cen, part2];
                                
                ed = ED(ts1_s, ts2_s);                
                Xshf1 = 0; Xshf2= x;
                [TmpCluster, cost_mdl] = Merge2Cluster(TS,Cluster,c1,c2,Xshf1,Xshf2,new_cen);                
                if (bsf_mdl > cost_mdl)
                    bsf_mdl = cost_mdl;
                    FCluster = TmpCluster;
                    MergeInfo = [c1 c2 length(new_cen)];
                end                
            end

            for x = 1:Mmax-M1
                ts1 = [zeros(1,x), cen1, zeros(1,M2-M1-x)];      
               ts2 = [             cen2, zeros(1,M1+x-M2)];
                  
                ts1_s = cen1(1:min(M2-x,M1));
                ts2_s = cen2(x+1:min(M2,M1+x));
                new_cen = (ts1_s*N1 + ts2_s*N2)/(N1+N2);
                
                Mc = length(new_cen);
                part1=[]; part2=[];
                if (M2>Mc),  part1 = cen2(1:x); end
                if (M2>M1+x),  
                    part2 = cen2(M1+x+1:M2); 
                else
                    part2 = cen1(M2-x+1:M1);
                end
                new_cen = [part1, new_cen, part2];
             
                ed = ED(ts1_s, ts2_s);                                               
                Xshf1 = x; Xshf2= 0;
                [TmpCluster, cost_mdl] = Merge2Cluster(TS,Cluster,c1,c2,Xshf1,Xshf2,new_cen);
                if (bsf_mdl > cost_mdl)
                    bsf_mdl = cost_mdl;
                    FCluster = TmpCluster;
                    MergeInfo = [c1 c2 length(new_cen)];
                end
            end                        
        end
        
        
        if (bsf_ed == inf),  continue; end;        
    end  
    
    cost = bsf_mdl;  
end

function [FCluster, cost_mdl] = Merge2Cluster(TS,Cluster,c1,c2,Xshf1,Xshf2,cen)
    %%% Compute MDL    
    if (c1>c2), 
        [FCluster, cost_mdl] = Merge2Cluster(TS,Cluster,c2,c1,Xshf2,Xshf1,cen);
        return;
    end;       

    Clus1 = Cluster(c1);
    Clus2 = Cluster(c2);
    MDL_OLD1 = MDL_Cluster_i(TS,Clus1) / Clus1.maxM;
    MDL_OLD2 = MDL_Cluster_i(TS,Clus2) / Clus2.maxM;
    MDL_OLD  = MDL_OLD1 + MDL_OLD2;
    
    Cluster(c1).elm = [ Clus1.elm(:,1:2), Clus1.elm(:,3)+Xshf1;  ...
                        Clus2.elm(:,1:2), Clus2.elm(:,3)+Xshf2];   
    new_cen = cen;
    Cluster(c1).cenTS = new_cen;
    Cluster(c1).cenM  = length(new_cen);
    Cluster(c1).minM  = min([Clus1.minM, Clus2.minM]);
    Cluster(c1).maxM  = max([Clus1.maxM, Clus2.maxM]);
    Cluster(c1).minXs = min(Cluster(c1).elm(:,3));
    Cluster(c1).maxXs = max(Cluster(c1).elm(:,3));
    
    Cluster(c2) = [];
    
    % %%% New MDL: Bits Save / length
    MDL_NEW = MDL_Cluster_i(TS,Cluster(c1)) / Cluster(c1).maxM;
    cost_mdl = MDL_NEW - MDL_OLD;
    FCluster = Cluster;
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%% MDL Stuffs  %%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function cost = MDL_Cluster_i(TS,clusi)
    cost = 0;
    cenTS = clusi.cenTS;
    cenM  = clusi.cenM;

    cost_clus = MDL(cenTS);
    cost_diff = 0;
    max_mdl_diff = -inf;

    for j=1:size(clusi.elm,1) %%%% Careful Here %%%
        pos  = clusi.elm(j,1);
        M    = clusi.elm(j,2);
        Xshf = clusi.elm(j,3);

        ts = DNorm_Unif(TS(pos:pos+M-1));
        ts = [zeros(1,Xshf), ts, zeros(1,cenM-M-Xshf)];
        
        mdl_diff = MDL(ts-cenTS);
        max_mdl_diff = max(max_mdl_diff, mdl_diff);
        cost_diff = cost_diff + mdl_diff;
    end
    cost_diff = cost_diff - max_mdl_diff;
    cost = cost + cost_clus + cost_diff;    
end

%% 
function cost = MDL(ts) 
    cost = bitcost_ent(ts);
end

function cost = bitcost_ent(ts)
    ts = ts-min(ts)+1;     
    if (min(ts)==max(ts))        
        ts(end) = -ts(end);
    end   
    cost = ent(ts);    
end

function cost = ent(ts)    
    min_val = min(ts);
    max_val = max(ts);    
    f = histc(ts(:),min_val:max_val);
    f = f(:)'/sum(f);
    ent = -f.*log(f+0.000000000000000000001)./log(2);    
    cost = length(ts)* sum(ent);            
end
