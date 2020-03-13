listdir={'C:\Users\sgarg\Desktop\EEG\New Data\Controls', 'C:\Users\sgarg\Desktop\EEG\arrowsmith_controls'};
listdir={'/home/eeglewave/Documents/Report Generation/Data/train_data/controls/', '/home/eeglewave/Documents/Report Generation/Data/RFC/MAT'};
% age=[];
% count=0;
% for i=1:length(listdir)
%     directory = char(listdir(i));
%     
%     [list_dir]=dir(directory);
%     
%     % For each subject
%     for file = list_dir'
%         if(strcmp(file.name, '.') == 0 && strcmp(file.name,'..') == 0 && strcmp(file.name, 'desktop.ini') == 0 && strcmp(file.name, '$Recycle.Bin') == 0 && strcmp(file.name, 'Config.Msi') == 0)
%             count= count+1;
%             file_addr = strcat(directory, '\', file.name, '\*.txt');
%             txt_age = ls(file_addr);
%             if(~isempty(txt_age))
%             age(count) = (str2num( txt_age(1:end-4) ));
%             end
%         end
%     end
% end


[features_age, dir_numsubj, age] = feature_extraction(listdir); 



%fitting the line
[rows cols] = size(features_age);

new_features = features_age;
%for each feature
for i=1:cols
    p{i} = polyfit(age',features_age(:,i),1);
    
    y = p{i}(1)*age'+p{i}(2);
    
    new_features(:,i) = features_age(:,i) - y;
end

save('age_correction_parameters.mat','p');