clc;
clear all;
close all;
%reading database file and form S(skills),U(user_id,user_pos,user_skills),P(pos) vectors
[num,skills]= xlsread('skills.xlsx','A1:A10'); 
[num,pos]=xlsread('positions.xlsx','A1:A4');
[user_id,user_pos]=xlsread('userprofiles','B1:B5');
[user_id,user_skills]=xlsread('userprofiles','C1:C5');

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
            

%Taking user's skill as input and make binary vector of user input skill
A=input('Enter your skills:','s');
A=lower(A);
A=strsplit(char(A),',');
user_input_skill=zeros(length(skills),1);

    for j=1:length(skills)
        for k=1:length(A)
            if(strcmp(skills(j),A(k)))
              user_input_skill(j)=1; 
            end
        end
    end

[r,clm]=size(W);
%calculating cosine similarity between each column vector of w with user input skill vector 
for i=1:clm
     dist(i)=dot(W(:,i),user_input_skill)/(norm(W(:,i),2)*norm(user_input_skill,2));
   
end
%sorting based on cosine similarity between vectors
[dist,index]=sort(dist,'descend');
%disp(index);
%disp(dist);
q=1;
r=1;
% gets first and second most recommended position.
for i = 1:length(skills)
    if W(i,index(1))>=1
        cust_skills(q)=i;
        q=q+1;
    end
    if W(i,index(2)>=1)
        cust_skills_2(r)=i;
        r=r+1;
    end
end

%Recommendation vectors(Rec1 and Rec2)
Rec1=zeros(10,1);
Rec2=zeros(10,1);

%Replacing weights in recommendaion vectors with 1 and then subtracting
%from user input skill vector to get vector of skills which are not
%currently user have
for p=1:length(cust_skills)
    Rec1(cust_skills(p))=1;
end
for p=1:length(cust_skills_2)
    Rec2(cust_skills_2(p))=1;
end

Rec1 = (Rec1-user_input_skill);
Rec2 = (Rec2-user_input_skill);
for n = 1:length(Rec2)
    if Rec2(n)<0
        Rec2(n)=0;
    end
end
mat_1 = find(Rec1);
mat_2 = find(Rec2);
fprintf('Most recommended job position for user is %s:\n',pos{index(1)});
disp('for this job position skills to be acquired are(High to low):');

%skills to be acquire for first recommended profession
for l = 1:length(mat_1)
    disp(skills(mat_1(l)));
end

fprintf('Second most recommended job position for user is %s\n',pos{index(2)});
disp('for this job position skills to be acquired are (High to low):');


%skills to be acquire for second recommended profession
for l = 1:length(mat_2)
    disp(skills(mat_2(l)));
end
            
            
            
            