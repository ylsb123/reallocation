

function [tmp_pairing_vec,final_budget]=GS(select,pairing_vec,expect,task_preference,final_budget,distance)

[user,task]=size(pairing_vec);
[row,col]=find(pairing_vec==0);%=0����ʾδ��ѡ���
tmp_pairing_vec=zeros(user,task);
col_step=length(row);
for i=1:col_step %�ҵ�����δ��ѡ�е� 
tmp_row=row(i);
tmp_col=col(i);
tmp_pairing_vec(tmp_row,tmp_col)=1; %δ��ѡ��ĸ�ֵ��ֵΪ1
end

count=zeros(1,task);

task_expect=zeros(1,task);

for j=1:task
     count(j)=length(find(pairing_vec(:,j)==1));%ͳ��0�ĸ���
  
     
     select_number=0;
     
 while select_number<select %step1:Ѱ�����ʺ���������Ĺ��� �൱��ƥ�����ߵĹ���
     max_user_quality=10000000; %���Ѿ�ѡ��Ĺ����У�ѡ�����������Ĺ���
     for i=1:user
        if tmp_pairing_vec(i,j)==0%�ڱ�ѡ��Ĺ����Ѱ�����������Ĺ��˼���
            tmp1=0.5*task_preference(j,i);
            tmp2=0.5*distance(i,j);
            tmp_user_quality=tmp1-tmp2; %��ʽ 0.5*����-0.5*���루0.5�����޸ģ����ھ���Ƚ�Զ���Ǹ���
            if max_user_quality>tmp_user_quality %ѡ����Ӧ�Ĺ���
                 max_user_quality=tmp_user_quality;
                 index_i=i;
            end
        end
     end
     tmp_pairing_vec(index_i,j)=3;%2:��ʾ��һ���Ѿ�ѡ�����������,ѡ������ǿ�Ĺ���
    task_expect(1,j)=task_expect(1,j)+expect(index_i,j);%��Ӷ�ù��˵ķ���
    select_number=select_number+1;
 end
 %%step2:Ѱ���滻�Ĺ���,��Ҫ����|B|r-rw+bt>0 
 %1) 
 
 bt=0;
final_budget(j)=final_budget(j)+task_expect(j);
 while  true 
     max_preference=0;
      maxj=0;
      maxi=0;
      for i=1:user
          if tmp_pairing_vec(i,j)==1 && max_preference<task_preference(j,i)% ��δѡ��Ĺ�����Ѱ��ѡ�����Ҫ��Ĺ���
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


      
     
     