function DisplayClusterML(Clustering, delay, MaxSteps)
    global MAXM  NC  NE   vgap
    
    TS           = Clustering.TS;
    ClusterPath  = Clustering.CPath;
    ActionListML = Clustering.AList;
    DList        = Clustering.DList;    
    
    if (~exist('MaxSteps','var')),   MaxSteps=length(ClusterPath); end;
    
    vgap = 10;
    DList = -DList;
    note_str = '';
    
    if (~exist('delay','var')), delay=1; end;
    
    MAXM=0; NC=0;
    for t=1:length(ClusterPath)
        for ci=1:length(ClusterPath{t})
            MAXM = max(MAXM, ClusterPath{t}(ci).maxM);                        
        end
        NC   = max(NC, length(ClusterPath{t}));
    end
    NE = length(ClusterPath)+1;
    
    Color = [   1 0 0;
            0 0 1;
            0 1 0;
            0 1 1;
            1 0 1;
            1 1 0;];
    Color = [Color; rand(NE-size(Color,1),3)];
    Color2 = rand(NE*NC,3);
    
    minMDL=min([-0.5 DList(1:MaxSteps)]);
    maxMDL=max([0.5  DList(1:MaxSteps)]);
    
    figure(1);     
    plot(TS,'k');       
    title('Original Time Series');
    axis([-inf inf -inf inf]);    
    
    figure(2);     
    plot(MAXM,0); 
    title('Clusters in each step');
    
    figure(3); hold off;
    bar(1,0,'r'); hold on;
    bar(1,0,'b'); 
    bar(1,0,'g');        
    legend('Create','Add','Merge');
    xlabel('Step in clustering process');
    ylabel('Bitsave per unit');
    title(['BitSave in each step' , note_str]);
    set(gca,'XTick',1:length(ClusterPath));
    axis([0, MaxSteps+1, minMDL, maxMDL]);
    
    pause(1);
    
    for t=1: min(length(ClusterPath),MaxSteps)
        if (delay < 0)
            fprintf('Press any key ...\n');
            pause();
        else
            pause(delay);
        end
        
        
        if (ActionListML(t,1)==3)
           cid2 = ActionListML(t,3);            
           Color(cid2,:)=[];
        end
        DisplayClusterA(TS,ClusterPath{t},Color,2,Color2);
        
        str=[];
        if (ActionListML(t,1)==1)
            str=sprintf('Step:%d,  Create New Cluster of length %d',t,ActionListML(t,end));
            c = 'r';
        elseif (ActionListML(t,1)==2)
            str=sprintf('Step:%d,  Add Subsequence to Cluster ',t);
            c = 'b';
        else
            str=sprintf('Step:%d,  Merge 2 Clusters ',t);
            c = 'g';
        end
        figure(3); 
        bar(t,DList(t),c); 
        figure(3);
        
        figure(1);
        plot(TS,'k'); hold on;
        for ci=1:length(ClusterPath{t})
            for i=1:size(ClusterPath{t}(ci).elm,1)
                pos = ClusterPath{t}(ci).elm(i,1);
                M = ClusterPath{t}(ci).elm(i,2);
                plot(pos:pos+M-1, TS(pos:pos+M-1), 'Color',Color(ci,:), 'LineWidth',2);
            end            
        end
        axis([-inf inf -inf inf]);        
        hold off;
        title(str);
    end

    figure(1); hold off; title('Finish');
    figure(2); hold off; title('Final Cluster');
    figure(3); hold off;    
end



%% 
function DisplayClusterA(TS,Cluster, Color,f,Color2)        
    global MAXM  NC  NE vgap
    
    if (exist('f','var')), figure(f); end;
    plot(MAXM,0); hold on;
    off = 0;
    for ci=1:length(Cluster)
         off = off+MAXM;
         ts = Cluster(ci).cenTS;         
         plot(off+1:off+Cluster(ci).cenM, ts,'Color',Color(ci,:),'LineWidth',2);
         for i=1:size(Cluster(ci).elm,1)
             pos  = Cluster(ci).elm(i,1);
             M    = Cluster(ci).elm(i,2);
             Xshf = abs(Cluster(ci).elm(i,3));    

             ts = DNorm_Unif(TS(pos:pos+M-1))-50-vgap*i; 
             new_color = Color2((ci-1)*NE+i,:);
             new_color(new_color>1)=1;
             new_color(new_color<0)=0;             
             plot(off+1+Xshf:off+M+Xshf,ts,'k','Color',new_color);
         end
    end
    hold off;
    title(sprintf('Now there are %d clusters, Top line is a center of cluster.',length(Cluster)));
    axis([MAXM/2, MAXM*(NC+1), -inf, inf]);
end