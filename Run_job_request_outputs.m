    function [tophf,bottomhf,LfT,WebT,UfT,time]=Run_job_request_outputs()

    close all
    S = mfilename('fullpath');
    f = filesep;
    ind=strfind(S,f);
    S1=S(1:ind(end)-1);
    cd(S1)
    %above sets the path
    file='mdbname.csv';
    [fidd] = Readcsv(file);
    for i = 1:height(fidd)   
        dep=fidd(i,1);
        wid=fidd(i,2);
        ft=fidd(i,3);
        wt=fidd(i,4);
        it=fidd(i,5);
        round(it,2)
        disp(it)
        ic=fidd(i,6);
        if it >= (dep-2*ft)/2
            it=(dep-2*ft)/2-0.01;
        end
        dep=num2str(fix(dep));
        wid=num2str(fix(wid));
        ft=num2str(fix(ft));
        wt=num2str(fix(wt));
        if it >=1
            it=num2str(fix(it));
        else
            it=num2str(it);
        end
        ic=num2str(ic);
        dep=strrep(dep,'.','l');
        wid=strrep(wid,'.','l');
        ft=strrep(ft,'.','l');
        wt=strrep(wt,'.','l');
        it=strrep(it,'.','l');
        ic=strrep(ic,'.','l');
        model=append(dep,'x',wid,'x',ft,'x',wt,'it',it,'con',ic);
        mdbname = append('3sided',model);
        disp(mdbname);
        delete(append(mdbname,'.odb'));
        delete(append(mdbname,'.lck'));
        %% 
        inp=append(mdbname,'.inp');
        modifyfile(inp,inp);
        pause(2) % can this pause stop the job from getting stuck?
        desc=append('abaqus job=',mdbname,' cpus=10 interactive');
        system(desc)
        pause(2)
        while exist(append(mdbname,'.lck'),'file')==2
            pause(0.1)
        end
        while exist(append(mdbname,'.odb'),'file')==0
            pause(0.1)
        end
        %%
        [tophf,bottomhf,LfT,WebT,UfT,time,mdbname]=Read_ODB_outputs_ele(mdbname);
        [k_u_f,k_l_f]=k_calculation(tophf,bottomhf,time,127,76,7.6,4.2,14.9,2e-5);
        f1=figure;
        hold on
        plot(time,tophf);
        plot(time,bottomhf);
        legend('Top heat flux','Bottom heat flux');
        ylabel('Heat flux (W/mmK)');
        xlabel('Time (s)');
        hold off
        hffig=append(mdbname,'hf.png');
        saveas(gcf,hffig);
        pause(1)
        f3=figure;
        hold on
        plot(time,LfT);
        plot(time,WebT);
        plot(time,UfT);
        legend('Lowerflange temperature','Web temperature','Upperflange temperature');
        % Create ylabel
        ylabel('Temperature (˚C)');
        % Create xlabel
        xlabel('Time (s)');
        hold off
        tempfig=append(mdbname,'temp.png');
        saveas(gcf,tempfig);

        f4=figure;
        hold on
        plot(time,k_u_f);
        plot(time,k_l_f);
        legend('k_u_f','k_l_f');
        % Create ylabel
        ylabel('k');
        % Create xlabel
        xlabel('Time (s)');
        xlim([0 7200]);
        ylim([-0.4 10]);
        hold off
        tempfig=append(mdbname,'k_values.png');
        saveas(gcf,tempfig);

        data=cat(1,tophf,bottomhf,UfT,WebT,LfT,k_u_f,k_l_f,time);
        csv=append(mdbname,'.csv');
        writematrix(data,csv);
    end       
    clear all
    disp('Plotting finished')
end
%%

