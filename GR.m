
function [tmp_pairing_vec,final_budget]=GR(select,pairing_vec,expect,task_preference,final_budget,distance)

[user,task]=size(pairing_vec);
[row,col]=find(pairing_vec==0);
tmp_pairing_vec=zeros(user,task);
col_step=length(row);

for i=1:col_step %�ҵ�����δ��ѡ�еģ����1
tmp_row=row(i);
tmp_col=col(i);
tmp_pairing_vec(tmp_row,tmp_col)=1; 

end
count=zeros(1,task);

task_expect=zeros(1,task);

for j=1:task
     count(j)=length(find(pairing_vec(:,j)==1));%ͳ��0�ĸ���
    
    
         
         
     select_number=0;
   while select_number<select %̰���㷨����δ��ѡ��Ĺ����м䣬ѡ���滻�Ĺ���
     max_user_quality=-10000000;
     for i=1:user
       
        if tmp_pairing_vec(i,j)==1 %��û��ѡ��Ĺ����Ѱ��������ǿ�Ҿ�����Ĺ���
            
            tmp1=0.5*task_preference(j,i);
            tmp2=0.5*distance(i,j);
            tmp_user_quality=tmp1-tmp2; %��ʽ 0.5*����-0.5*���루0.5�����޸ģ����ھ���Ƚ�Զ���Ǹ���
            
            if max_user_quality<tmp_user_quality %ѡ����Ӧ�Ĺ���
                 max_user_quality=tmp_user_quality;
                 index_i=i;
            end
        end
    end
    tmp_pairing_vec(index_i,j)=2;%2:��ʾ��һ���Ѿ�ѡ�����������,ѡ������ǿ�Ĺ���
    task_expect(1,j)=task_expect(1,j)+expect(index_i,j);%��Ӷ�ù��˵ķ���
    select_number=select_number+1;
   end
    %%Ѱ���滻�Ĺ���,̰���㷨�����Ѿ�ѡ��Ĺ�����ѡ��
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

