%example
t_all=0;
n=120;
m=20;
index_user=1;
overall=zeros((n-m)/10+1,5);
overall_changed=zeros((n-m)/10+1,5);
overall_greedy=zeros((n-m)/10+1,5);
overall_JAC=zeros((n-m)/10+1,5);
overall_budget=zeros((n-m)/10+1,5);
for user=20:10:120
task=20;
%user=20;
expect=randi([3,6],user,task);%������������
task_preference=randi([1,5],task,user);%����Թ��˵�ƫ�ã���ʾ���˵��������㷨����max���ֵ
budget=randi([30,50],1,task); %task��Ԥ��
distance=randi([10,100],user,task);
sumbudget_10=zeros(task,1); 

% task=2;
% user=5;
% expect=[6,6;4,5;5,3;4,5;7,6];%������������
% task_preference=[13,11,11,11,15;11,10,11,13,14];%����Թ��˵�ƫ�ã���ʾ���˵��������㷨����max���ֵ
% budget=[17,17];
% distance=[5,6;4,3;2,4;3,5;4,7];
%%%


global index_2;
index_2=1;

%%%Ϊ����żȻ�ԣ�ÿ���ۼ�ʮ��
%��Ҫ �û����룬ʣ��Ԥ�㣬�����������������廯��
distance_inital_10=zeros(task,1);
distance_changed_10=zeros(task,1);%����
distance_greedy_changed_10=zeros(task,1);%greedy�㷨
distance_Stable_changed_10=zeros(task,1);


final_budget_10=zeros(task,1);%budget Ԥ��
final_budget_changed_10=zeros(task,1); 
final_budget_greedy_changed_10=zeros(task,1);
final_budget_Stable_changed_10=zeros(task,1);

measurement_10=zeros(task,1);
measurement_changed_10=zeros(task,1);%measurement
measurement_greedy_changed_10=zeros(task,1);%measurement
measurement_Stable_changed_10=zeros(task,1);

workernumber_10=zeros(task,1);
workernumber_changed_10=zeros(task,1);%workernumber
workernumber_greedy_changed_10=zeros(task,1);%workernumber
workernumber_Stable_changed_10=zeros(task,1);

totalperward_10=zeros(task,1);
totalperward_changed_10=zeros(task,1);
totalperward_greedy_changed_10=zeros(task,1);
totalperward_Stable_changed_10=zeros(task,1);

for count=1:20
%%%%��һ�������Ľ�����൱�ڳ�ʼֵ
[pairing_vec,max_quality,expect]=exDP(task_preference,budget,expect); %��̬�滮δ���Ǿ����һ���������
final_budget=zeros(task,1);
final_budget_inital=zeros(task,1);
distance_inital=zeros(task,1);
perward=zeros(task,1);
number=zeros(task,1);
fix_pairing_vec=pairing_vec;


for j=1:task
    sum_index=0;
    index=0;
    for i=1:user
        if pairing_vec(i,j)==1
            sum_index=sum_index+expect(i,j);
            index=index+1;
            number(j)=number(j)+1;
        end
    end
    perward(j)=sum_index/index;
    totalperward_10(j)=totalperward_10(j)+perward(j);
    final_budget(j)=budget(j)-sum_index;
    final_budget_inital(j)=final_budget(j);
    final_budget_10(j)= final_budget_10(j)+ final_budget_inital(j); %10(n)����Ӻ��ʣ��Ԥ����
    sumbudget_10(j)=sumbudget_10(j)+budget(j);
    workernumber_10(j)=workernumber_10(j)+number(j);
end


measurement=zeros(task,1);%��������
for j=1:task
    for i=1:user
        if pairing_vec(i,j)==1
            measurement(j,1)= measurement(j,1)+task_preference(j,i);
           distance_inital(j,1)=distance_inital(j,1)+distance(i,j);
        end
    end
    measurement_10(j,1)=measurement_10(j,1)+measurement(j,1);%��ʼmeasurement
    distance_inital_10(j,1)=distance_inital_10(j,1)+distance_inital(j,1);
end

select=1;%�滻��������
%%%%%%%%%%%%%%%%%%greedy algorithm
[greedy_pairing_vec,final_greedy_budget]=GR(select,fix_pairing_vec,expect,task_preference,final_budget_inital,distance);
[user,task]=size(greedy_pairing_vec);

 measurement_greedy_changed=zeros(task,1);
 distance_greedy_changed=zeros(task,1);
 greedy_worknumber=zeros(task,1);
 greedy_reward=zeros(task,1);
 
for i=1:task
    sum_index=0;
    for j=1:user
        if greedy_pairing_vec(j,i)==0 || greedy_pairing_vec(j,i)==2 %%ѡ��0��2��
            sum_index=sum_index+expect(j,i);
            measurement_greedy_changed(i,1)=measurement_greedy_changed(i,1)+task_preference(i,j);%��������
            distance_greedy_changed(i,1)=distance_greedy_changed(i,1)+distance(j,i);%
            greedy_worknumber(i,1)=greedy_worknumber(i,1)+1;
            
        end
    end
    greedy_reward(i,1)=sum_index/greedy_worknumber(i,1);
    totalperward_greedy_changed_10(i,1)=totalperward_greedy_changed_10(i,1)+greedy_reward(i,1);
    workernumber_greedy_changed_10(i,1)= workernumber_changed_10(i,1)+greedy_worknumber(i,1);
    measurement_greedy_changed_10(i,1)= measurement_greedy_changed_10(i,1)+measurement_greedy_changed(i,1);
    distance_greedy_changed_10(i,1)=distance_greedy_changed_10(i,1)+distance_greedy_changed(i,1);
    final_budget_greedy_changed_10(i,1)=final_budget_greedy_changed_10(i,1)+final_greedy_budget(i,1);
     
end

%%%%%%%%%%%%%%%%%%GS algorithm
fix_pairing_vec=pairing_vec;
final_budget_inital=final_budget;

[stable_pairing_vec,final_greedy_budget]=GS(select,fix_pairing_vec,expect,task_preference,final_budget_inital,distance);
[user,task]=size(stable_pairing_vec);

 measurement_Stable_changed=zeros(task,1);
 distance_Stable_changed=zeros(task,1);
stable_worknumber=zeros(task,1);
stable_reward=zeros(task,1);

for i=1:task
    sum_index=0;
    for j=1:user
        if stable_pairing_vec(j,i)==0 || stable_pairing_vec(j,i)==2 %%ѡ��0��2��
            sum_index=sum_index+expect(j,i);
            measurement_Stable_changed(i,1)=measurement_Stable_changed(i,1)+task_preference(i,j);%��������
            distance_Stable_changed(i,1)=distance_Stable_changed(i,1)+distance(j,i);%
            stable_worknumber(i,1)=stable_worknumber(i,1)+1;
        end
    end
    stable_reward(i,1)=sum_index/stable_worknumber(i,1);
    totalperward_Stable_changed_10(i,1)=totalperward_Stable_changed_10(i,1)+stable_reward(i,1);
    workernumber_Stable_changed_10(i,1)=workernumber_Stable_changed_10(i,1)+stable_worknumber(i,1);
    measurement_Stable_changed_10(i,1)= measurement_Stable_changed_10(i,1)+measurement_Stable_changed(i,1);
    distance_Stable_changed_10(i,1)=distance_Stable_changed_10(i,1)+distance_Stable_changed(i,1);
    final_budget_Stable_changed_10(i,1)=final_budget_Stable_changed_10(i,1)+final_greedy_budget(i,1);
end

%%%%%%%%%%%%%%%%%%%��ʼ���ǵĳ���%%%
fix_pairing_vec=pairing_vec;
final_budget_inital=final_budget;
t1=clock;
[tmp_pairing_vec,final_budget_us]=reallocation(select,fix_pairing_vec,expect,task_preference,final_budget_inital,distance);
t2=clock;
t=etime(t2,t1);
t_all=t_all+t;
[user,task]=size(tmp_pairing_vec);
 measurement_changed=zeros(task,1);
 distance_changed=zeros(task,1);
 workernumber_changed=zeros(task,1);
 reward_changed=zeros(task,1);
 
for i=1:task
    sum_index=0;
    for j=1:user
        if tmp_pairing_vec(j,i)==0 || tmp_pairing_vec(j,i)==2 %%ѡ��0��2��
            sum_index=sum_index+expect(j,i);
            measurement_changed(i,1)=measurement_changed(i,1)+task_preference(i,j);
            distance_changed(i,1)=distance_changed(i,1)+distance(j,i);
            workernumber_changed(i,1)=workernumber_changed(i,1)+1;
        end
    end
    reward_changed(i,1)=sum_index/workernumber_changed(i,1);
    totalperward_changed_10(i,1)=totalperward_changed_10(i,1)+reward_changed(i,1);
    workernumber_changed_10(i,1)=workernumber_changed_10(i,1)+workernumber_changed(i,1);
    measurement_changed_10(i,1)= measurement_changed_10(i,1)+measurement_changed(i,1);
    distance_changed_10(i,1)=distance_changed_10(i,1)+distance_changed(i,1);
    final_budget_changed_10(i,1)=final_budget_changed_10(i,1)+final_budget_us(i,1);
    
end

end
%%%%%%%%%%%%%%%ʵ�����ݴ���


overall(index_user,1)=sum(final_budget_10)/count; %ʣ��Ԥ���ܺ�
overall(index_user,2)=sum(measurement_10)/count; %��������
overall(index_user,3)=sum(distance_inital_10)/count; %����
overall(index_user,4)=sum(totalperward_10)/count; 
overall(index_user,5)=sum(workernumber_10)/count; 


overall_greedy(index_user,1)=sum(final_budget_greedy_changed_10)/count; %ʣ��Ԥ���ܺ�
overall_greedy(index_user,2)=sum(measurement_greedy_changed_10)/count; %��������
overall_greedy(index_user,3)=sum(distance_greedy_changed_10)/count; %����
overall_greedy(index_user,4)=sum(totalperward_greedy_changed_10)/count; 
overall_greedy(index_user,5)=sum(workernumber_greedy_changed_10)/count; 

overall_JAC(index_user,1)=sum(final_budget_Stable_changed_10)/count; %ʣ��Ԥ���ܺ�
overall_JAC(index_user,2)=sum(measurement_Stable_changed_10)/count; %��������
overall_JAC(index_user,3)=sum(distance_Stable_changed_10)/count; %����
overall_JAC(index_user,4)=sum(totalperward_Stable_changed_10)/count; 
overall_JAC(index_user,5)=sum(workernumber_Stable_changed_10)/count; 

overall_changed(index_user,1)=sum(final_budget_changed_10)/count; %ʣ��Ԥ���ܺ�
overall_changed(index_user,2)=sum(measurement_changed_10)/count; %��������
overall_changed(index_user,3)=sum(distance_changed_10)/count; %����
overall_changed(index_user,4)=sum(totalperward_changed_10)/count; 
overall_changed(index_user,5)=sum(workernumber_changed_10)/count; 




index_user=index_user+1;
%%%%%%%%%%%%%%%
end