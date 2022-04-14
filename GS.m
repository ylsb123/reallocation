

function [tmp_pairing_vec,final_budget]=GS(select,pairing_vec,expect,task_preference,final_budget,distance)

[user,task]=size(pairing_vec);
[row,col]=find(pairing_vec==0);%=0：表示未被选择的
tmp_pairing_vec=zeros(user,task);
col_step=length(row);
for i=1:col_step %找到所有未被选中的 
tmp_row=row(i);
tmp_col=col(i);
tmp_pairing_vec(tmp_row,tmp_col)=1; %未被选择的赋值赋值为1
end

count=zeros(1,task);

task_expect=zeros(1,task);

for j=1:task
     count(j)=length(find(pairing_vec(:,j)==1));%统计0的个数
  
     
     select_number=0;
     
 while select_number<select %step1:寻找最适合这个工作的工人 相当于匹配度最高的工人
     max_user_quality=10000000; %在已经选择的工人中，选择能力最弱的工人
     for i=1:user
        if tmp_pairing_vec(i,j)==0%在被选择的工人里，寻找能力最弱的工人集合
            tmp1=0.5*task_preference(j,i);
            tmp2=0.5*distance(i,j);
            tmp_user_quality=tmp1-tmp2; %公式 0.5*能力-0.5*距离（0.5可以修改，由于距离比较远，是负数
            if max_user_quality>tmp_user_quality %选择相应的工人
                 max_user_quality=tmp_user_quality;
                 index_i=i;
            end
        end
     end
     tmp_pairing_vec(index_i,j)=3;%2:表示这一轮已经选择了这个工人,选择能力强的工人
    task_expect(1,j)=task_expect(1,j)+expect(index_i,j);%雇佣该工人的费用
    select_number=select_number+1;
 end
 %%step2:寻找替换的工人,需要满足|B|r-rw+bt>0 
 %1) 
 
 bt=0;
final_budget(j)=final_budget(j)+task_expect(j);
 while  true 
     max_preference=0;
      maxj=0;
      maxi=0;
      for i=1:user
          if tmp_pairing_vec(i,j)==1 && max_preference<task_preference(j,i)% 从未选择的工人中寻找选择符合要求的工人
               max_preference=task_preference(j,i);
               maxj=j;
               maxi=i;
          end
      end
           bt=bt+expect(maxi,maxj); 
           final_budget(j)=final_budget(j)-expect(maxi,maxj);
           tmp_pairing_vec(maxi,maxj)=2; 
      
      if final_budget(j)<0
          bt=bt-expect(maxi,maxj); 
          final_budget(j)=final_budget(j)+expect(maxi,maxj);
          tmp_pairing_vec(maxi,maxj)=1; 
          break;
      
      end
    end
end
         
   
 end  


      
     
     