clc;
clear all;
close all;
%reading database file and form S(skills),U(user_id,user_pos,user_skills),P(pos) vectors
[num,skills]= xlsread('skills.xlsx','A1:A10');
[num,pos]=xlsread('positions.xlsx','A1:A4');
[user_id,user_pos]=xlsread('userprofiles','B1:B6');
[user_id,user_skills]=xlsread('userprofiles','C1:C6');

%calculating wieght matrix W
W=zeros(length(skills),length(pos));
for i=1:length(pos)
    for j=1:length(user_pos)
            if(strcmp(user_pos(j),pos(i)))
                user_skill_array=strsplit(char(user_skills(j)),',');
                for k=1:length(skills)
                    for l=1:length(user_skill_array)
                        if(strcmp(skills(k),user_skill_array(l)))
                        %if(length(strmatch(skills(k),user_skills(j))));
                        W(k,i)=W(k,i)+1;
                        end
                    end
                end
            end
    end
end

%calculting binary user skill matrix(Us)
Us=zeros(length(skills),length(user_id));
for i=1:length(user_pos)
    for j=1:length(skills)
         user_skill_array=strsplit(char(user_skills(i)),',');
        for k=1:length(user_skill_array)
            if(strcmp(skills(j),user_skill_array(k)))
              Us(j,i)=1; 
            end
        end
    end
end
            
Us;            
            
%Getting target profession from user  
profession=input('Enter the profession:','s');

%getting index of target profession from W and extracting that from W
q=1;
for  i = 1:length(pos)
    if(strcmp(pos(i),profession))
         for j = 1:length(skills)
            if W(j,i)>=1
                cust_skills_wt(q)=W(j,i);
                cust_skills(q)=j;
                q=q+1;
            end
         end
    end
end

% Sorting skills based on weight in that extracted vector profession
[cust_skills_wt,in]=sort(cust_skills_wt,'descend');
disp('Recommended skills(High Preference-->Low Preferemce):')
for n=1:length(in)
   recommended_skills(n)= skills((cust_skills(in(n))));
end
   
disp(recommended_skills);

