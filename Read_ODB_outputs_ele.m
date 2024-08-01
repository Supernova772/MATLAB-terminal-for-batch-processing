function [avg_top_hf,avg_bottom_hf,avg_Lf_Temp,avg_Web_Temp,avg_Uf_Temp,time,mdbname]=Read_ODB_outputs_ele(mdbname)
%clear all
close all
debug = 0;
if (debug)
    debug_file = fopen('debug.dat', 'wt');
end
fil = append(mdbname,'.dat');
while exist(fil,'file')==0
    pause(0.1)
end

fidd = fopen(fil);
i = 0;
pause(0.5)
numSteps = 0;
j=0;
while ( ~feof(fidd) )    
    tline = fgetl(fidd);
    i = i+1;
        %<<<<<<<<<<<<<<<<<<<<Time output>>>>>>>>>>>>>>>>
    if (regexpi(tline, 'TOTAL TIME COMPLETED')>0)
        position=regexpi(tline, 'TOTAL TIME COMPLETED');
        position=position+27;
        numSteps = numSteps+1;
        %string='TOTAL TIME COMPLETED';
        %position = strfind(tline, string);
        text= tline(position:end);
        tvalue = str2double(text);
        time(numSteps) = tvalue; 
        tline = fgetl(fidd);
        i = i+1;
    end
    %<<<<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>>>>>>>>>>
    if (regexpi(tline, 'E L E M E N T   O U T P U T')>0)  %For elements, replace 'N O D E   O U T P U T'  by 'E L E M E N T   O U T P U T'
        
        
        while(isempty(regexpi(tline, 'ASSEMBLY_TOP', 'once')))
            tline = fgetl(fidd);
            i = i+1;
        end
        if (regexpi(tline, 'ASSEMBLY_TOP')>0)
            top_hf(numSteps) = 0;
            k = 0;
            while(isempty(str2num(tline)))
                tline = fgetl(fidd);
                i = i+1;
            end
            while(~isempty(str2num(tline)))
                j = j+1;
                k = k+1;
                data_f = sscanf(tline, '%d %d %e' , [1,3]);
    %             if (debug)
    %                 fprintf(debug_file, '%d\t%e\n', data_f(1), data_f(2), data_f(3));
    %             end
                top_hf(numSteps)=top_hf(numSteps)-data_f(3);
                
                tline = fgetl(fidd);
                i = i+1; 
            end
            avg_top_hf(numSteps)=top_hf(numSteps)/k;
            while(isempty(regexpi(tline, 'ASSEMBLY_BOTTOM', 'once')))
                tline = fgetl(fidd);
                i = i+1;
            end
        end    
 %           if (debug)
 %               fprintf(debug_file, '\n');
 %           end
            
        if (regexpi(tline, 'ASSEMBLY_BOTTOM')>0)
            while(isempty(str2num(tline)))
                tline = fgetl(fidd);
                i = i+1;
            end
            bottom_hf(numSteps) = 0;
            k = 0;
            while(~isempty(str2num(tline)))
                j = j+1;
                k = k+1;
                data_f = sscanf(tline, '%d %d %e' , [1,3]);
    %             if (debug)
    %                 fprintf(debug_file, '%d\t%e\n', data_f(1), data_f(2), data_f(3));
    %             end
                bottom_hf(numSteps) = bottom_hf(numSteps)-data_f(3);

                tline = fgetl(fidd);
                i = i+1;
                
            end
            avg_bottom_hf(numSteps) = bottom_hf(numSteps)/k;
            
   %         if (debug)
   %             fprintf(debug_file, '\n');
   %         end
        end
    end



    %<<<<<<<<<<<<<<<<   Element   output    >>>>>>>>>>>>>>>>>
    if (regexpi(tline, 'N O D E   O U T P U T')>0)  %For elements, replace 'N O D E   O U T P U T'  by 'E L E M E N T   O U T P U T'
        
        while(isempty(regexpi(tline, 'ASSEMBLY_LOWERFLANGE', 'once')))
            tline = fgetl(fidd);
            i = i+1;
        end
        
        if (regexpi(tline, 'ASSEMBLY_LOWERFLANGE')>0)
            while(isempty(str2num(tline)))
                tline = fgetl(fidd);
                i = i+1;
            end 
            k = 0;
            Lf_Temp(numSteps)= 0;
            while(~isempty(str2num(tline))) 
                k = k+1;
                j = j+1;
                data_f = sscanf(tline, '%d %e', [1,2]);
   %             if (debug)
   %                 fprintf(debug_file, '%d\t%e\n', data_f(1), data_f(2));
   %             end
                node_number = data_f(1);
                tline = fgetl(fidd);
                i = i+1;
                Lf_Temp(numSteps) = Lf_Temp(numSteps) + data_f(2);
                
            end
            avg_Lf_Temp(numSteps)=Lf_Temp(numSteps)/k;
            
    %        if (debug)
    %            fprintf(debug_file, '\n');
    %        end
            while(isempty(regexpi(tline, 'ASSEMBLY_WEB', 'once')))
                tline = fgetl(fidd);
                i = i+1;
            end
        end
        if (regexpi(tline, 'ASSEMBLY_WEB')>0)
            while(isempty(str2num(tline)))
                tline = fgetl(fidd);
                i = i+1;
            end 
            k = 0;
            Web_Temp(numSteps)=0;
            while(~isempty(str2num(tline))) 
                k = k+1;
                j = j+1;
                data_f = sscanf(tline, '%d %e', [1,2]);
                if (debug)
                    fprintf(debug_file, '%d\t%e\n', data_f(1), data_f(2));
                end
                node_number=data_f(1);
                tline = fgetl(fidd);
                i = i+1;
                Web_Temp(numSteps)=Web_Temp(numSteps)+data_f(2);
                
            end
            avg_Web_Temp(numSteps)=Web_Temp(numSteps)/k;
  %         if (debug)
  %             fprintf(debug_file, '\n');
  %         end
            while(isempty(regexpi(tline, 'ASSEMBLY_UPPERFLANGE', 'once')))
                tline = fgetl(fidd);
                i = i+1;
            end
        end
        if (regexpi(tline, 'ASSEMBLY_UPPERFLANGE')>0)
            while(isempty(str2num(tline)))
                tline = fgetl(fidd);
                i = i+1;
            end 
            k = 0;
            Uf_Temp(numSteps)=0;
            while(~isempty(str2num(tline))) 
                k = k+1;
                j = j+1;
                data_f = sscanf(tline, '%d %e', [1,2]);
                if (debug)
                    fprintf(debug_file, '%d\t%e\n', data_f(1), data_f(2));
                end
                node_number=data_f(1);
                tline = fgetl(fidd);
                i = i+1;
                Uf_Temp(numSteps)=Uf_Temp(numSteps)+data_f(2);
                
            end
            avg_Uf_Temp(numSteps)=Uf_Temp(numSteps)/k;
            
            if (debug)
                fprintf(debug_file, '\n');
            end
            
        end
    end
end
if (debug)
    fclose(debug_file);
end
fclose(fidd);
fclose all
