
%%����������� 
%%select:ѡ���滻�����Ĺ�������
%%pairing_vec��ƥ���ǩ
%%expect��������轱�� 
%%task_preference�����˵�����ƫ��
%%final_budget:ʣ�ཱ��
%%distance:����

function [tmp_pairing_vec,final_budget]=reallocation(select,pairing_vec,expect,task_preference,final_budget,distance)
global index_2;
paramter=0.5;
[user,task]=size(pairing_vec);
[row,col]=find(pairing_vec==0);
tmp_pairing_vec=zeros(user,task);
col_step=length(row);
for i=1:col_step %�ҵ�����δ��ѡ�е�
tmp_row=row(i);
tmp_col=col(i);
tmp_pairing_vec(tmp_row,tmp_col)=1; 


end
count=zeros(1,task);
set_value=zeros(1,task);

 %%Ѱ������ǿ�Ĺ���
 task_expect=zeros(1,task);%

for j=1:task
    
     count(j)=length(find(pairing_vec(:,j)==1));%ͳ��0�ĸ���
     
     tmp_sort=zeros(1,count(j));%��ŷ�����������
     tmp_sort_b=zeros(1,count(j));%������Ҫ�����������
     select_number=0;
    
    while select_number<select
     max_user_quality=-10000000;
    for i=1:user
       
        if tmp_pairing_vec(i,j)==1 %��û��ѡ��Ĺ����Ѱ��������ǿ�Ҿ�����Ĺ���
            
            tmp1=paramter*task_preference(j,i);
            tmp2=(1-paramter)*distance(i,j);
            tmp_user_quality=tmp1-tmp2; %��ʽ 0.5*����-0.5*���루0.5�����޸�
            
            if max_user_quality<tmp_user_quality
                 max_user_quality=tmp_user_quality;
                 index_i=i;
            end
        end
    end
    tmp_pairing_vec(index_i,j)=2;%2:��ʾ��һ���Ѿ�ѡ�����������,ѡ������ǿ�Ĺ���
    task_expect(1,j)=task_expect(1,j)+expect(index_i,j);%��Ӷ�ù��˵ķ���
    select_number=select_number+1;
    
    end

     %%Ѱ���滻�Ĺ���


        list=zeros(2,user);
        index_2=1;
        max_expect=task_expect(1,j);
        dp=zeros (count(j),max_expect); 
        index=0;
        for k=1:user
        if tmp_pairing_vec(k,j)== 0 %��ʾһ��ʼ��ѡ��ļ���
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
        
      %  set_value(j)=dp(index-1,max_expect);%set_value:��ʾ���ϵ����ֵ
        set_value(j)=dp(index,max_expect);%set_value:��ʾ���ϵ����ֵ
        final_budget(j)=final_budget(j)+set_value(j)-max_expect;%�滻���ʣ��Ԥ��
        %�ж����ļ�������ɼ������ֵ
        tmp_sort_b(j,:)=sort(tmp_sort(j,:));%����
        list=dfs(list,tmp_sort_b(j,:),set_value(j),1); %%�ҵ���ϵ���֮��
        %%Ѱ��list��������
        [row,col]=find(list(1,:)~=0);
        col_step=length(row);
        for i=1:col_step %�ҵ�����δ��ѡ�е�
            tmp_row=row(i);
            tmp_col=col(i);
            for k=1:user
                if expect(k,j)==list(tmp_row,tmp_col)&&tmp_pairing_vec(k,j)==0
                    tmp_pairing_vec(k,j)=3; %��ʾ�滻�ɹ��Ĺ��ˣ�ѡ��0��2������
                    break;
                end
            end
        end 
       
        tmp=0;
        for i=1:user %��֤������
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


