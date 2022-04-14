
function [tmp_pairing_vec,final_budget]=GR(select,pairing_vec,expect,task_preference,final_budget,distance)

[user,task]=size(pairing_vec);
[row,col]=find(pairing_vec==0);
tmp_pairing_vec=zeros(user,task);
col_step=length(row);

for i=1:col_step %找到所有未被选中的，标记1
tmp_row=row(i);
tmp_col=col(i);
tmp_pairing_vec(tmp_row,tmp_col)=1; 

end
count=zeros(1,task);

task_expect=zeros(1,task);

for j=1:task
     count(j)=length(find(pairing_vec(:,j)==1));%统计0的个数
    
    
         
         
     select_number=0;
   while select_number<select %贪心算法，在未被选择的工人中间，选择替换的工人
     max_user_quality=-10000000;
     for i=1:user
       
        if tmp_pairing_vec(i,j)==1 %在没被选择的工人里，寻找能力最强且距离近的工人
            
            tmp1=0.5*task_preference(j,i);
            tmp2=0.5*distance(i,j);
            tmp_user_quality=tmp1-tmp2; %公式 0.5*能力-0.5*距离（0.5可以修改，由于距离比较远，是负数
            
            if max_user_quality<tmp_user_quality %选择相应的工人
                 max_user_quality=tmp_user_quality;
                 index_i=i;
            end
        end
    end
    tmp_pairing_vec(index_i,j)=2;%2:表示这一轮已经选择了这个工人,选择能力强的工人
    task_expect(1,j)=task_expect(1,j)+expect(index_i,j);%雇佣该工人的费用
    select_number=select_number+1;
   end
    %%寻找替换的工人,贪心算法，从已经选择的工人中选择
     tmp_sum=0;  
     while tmp_sum< task_expect(1,j)
         best_expect=-1;
         maxi=0;
         maxj=0;
      for i=1:user
          if tmp_pairing_vec(i,j)==0  && expect(i,j)>best_expect
              best_expect=expect(i,j);
              maxi=i;
              maxj=j;
          end
      end
      tmp_sum=tmp_sum+best_expect;
      tmp_pairing_vec(maxi,maxj)=3;
     end
      final_budget(j,1)=final_budget(j,1)+tmp_sum-task_expect(1,j);
      
end

