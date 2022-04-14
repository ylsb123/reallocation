
%%输入参数依次 
%%select:选择替换出来的工人数量
%%pairing_vec：匹配标签
%%expect：任务给予奖励 
%%task_preference：工人的能力偏好
%%final_budget:剩余奖励
%%distance:距离

function [tmp_pairing_vec,final_budget]=reallocation(select,pairing_vec,expect,task_preference,final_budget,distance)
global index_2;
paramter=0.5;
[user,task]=size(pairing_vec);
[row,col]=find(pairing_vec==0);
tmp_pairing_vec=zeros(user,task);
col_step=length(row);
for i=1:col_step %找到所有未被选中的
tmp_row=row(i);
tmp_col=col(i);
tmp_pairing_vec(tmp_row,tmp_col)=1; 


end
count=zeros(1,task);
set_value=zeros(1,task);

 %%寻找能力强的工人
 task_expect=zeros(1,task);%

for j=1:task
    
     count(j)=length(find(pairing_vec(:,j)==1));%统计0的个数
     
     tmp_sort=zeros(1,count(j));%存放符合条件的人
     tmp_sort_b=zeros(1,count(j));%后续需要对其进行排序
     select_number=0;
    
    while select_number<select
     max_user_quality=-10000000;
    for i=1:user
       
        if tmp_pairing_vec(i,j)==1 %在没被选择的工人里，寻找能力最强且距离近的工人
            
            tmp1=paramter*task_preference(j,i);
            tmp2=(1-paramter)*distance(i,j);
            tmp_user_quality=tmp1-tmp2; %公式 0.5*能力-0.5*距离（0.5可以修改
            
            if max_user_quality<tmp_user_quality
                 max_user_quality=tmp_user_quality;
                 index_i=i;
            end
        end
    end
    tmp_pairing_vec(index_i,j)=2;%2:表示这一轮已经选择了这个工人,选择能力强的工人
    task_expect(1,j)=task_expect(1,j)+expect(index_i,j);%雇佣该工人的费用
    select_number=select_number+1;
    
    end

     %%寻找替换的工人


        list=zeros(2,user);
        index_2=1;
        max_expect=task_expect(1,j);
        dp=zeros (count(j),max_expect); 
        index=0;
        for k=1:user
        if tmp_pairing_vec(k,j)== 0 %表示一开始被选择的集合
            index=index+1;
            tmp_sort(j,index)=expect(k,j);
            
         for i=1:max_expect
            if index==1 && expect(k,j)>=i
                dp(index,i)=expect(k,j);
            elseif index==1 && expect(k,j)<i
                dp(index,i)=0;
            elseif index>1
                    tmp1=dp(index-1,i);
                if(i-expect(k,j)<=0)
                    tmp2=0+expect(k,j);
                else
                    tmp2=dp(index-1,i-expect(k,j))+expect(k,j);
                end
                    if tmp1>=i &&tmp2 >=i
                        dp(index,i)=min(tmp1,tmp2);
                    elseif tmp1<i &&tmp2>=i
                        dp(index,i)=tmp2;
                    elseif tmp1>=i && tmp2 <i
                        dp(index,i)=tmp1;
                    end
             end
            
         end
        
        end
        end
        
      %  set_value(j)=dp(index-1,max_expect);%set_value:表示集合的最大值
        set_value(j)=dp(index,max_expect);%set_value:表示集合的最大值
        final_budget(j)=final_budget(j)+set_value(j)-max_expect;%替换后的剩余预算
        %判断由哪几个数组成集合最大值
        tmp_sort_b(j,:)=sort(tmp_sort(j,:));%排序
        list=dfs(list,tmp_sort_b(j,:),set_value(j),1); %%找到组合的数之后，
        %%寻找list里非零的数
        [row,col]=find(list(1,:)~=0);
        col_step=length(row);
        for i=1:col_step %找到所有未被选中的
            tmp_row=row(i);
            tmp_col=col(i);
            for k=1:user
                if expect(k,j)==list(tmp_row,tmp_col)&&tmp_pairing_vec(k,j)==0
                    tmp_pairing_vec(k,j)=3; %表示替换成功的工人，选择0，2，工人
                    break;
                end
            end
        end 
       
        tmp=0;
        for i=1:user %验证，保险
            if tmp_pairing_vec(i,j)==3
                tmp=tmp+expect(i,j);
                if tmp>set_value(j)
                    tmp_pairing_vec(i,j)=0;
                    break;
                end
            end
        end
        
end   

   
end



function list=dfs(list,tmp_sort_b,set_value,start)
global index_2;

 sort_length=length(tmp_sort_b);
    if set_value<0
        return;
    end
    if set_value == 0
        index_2=index_2+1;
    else
        for i=start:sort_length
           % if i ~= start && tmp_sort_b(i)==tmp_sort_b(i-1)
           %     continue;
           % end 
            list(index_2,i)=tmp_sort_b(i);
            list=dfs(list,tmp_sort_b,set_value-tmp_sort_b(i),i+1);
           
            list(index_2,i)=0;
        end
    end
end


