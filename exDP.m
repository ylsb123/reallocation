function [pairing_vec,max_quality,expect]=exDP(task,budget,user_expect)

[m1,n1] = size(task);%task-user

proposal_list=ones(n1,m1); %user-task
reject_list=ones(n1,m1); %user-task
maxbudget=max(budget);
max_quality=zeros(1,m1);



for j=1:m1 %task
         dp=zeros(n1+1,maxbudget+1);
         path=zeros(n1,maxbudget+1);
         k=0;
            for i=1:n1 %user
                    k=k+1;
                    for v=user_expect(i,j):budget(j) %user-反应的是每个任务的奖励 任务奖励不能超过
                        tmp1=dp(k,v+1);
                        tmp2=dp(k,v-user_expect(i,j)+1)+task(j,i);
                        dp(k+1,v+1)=max(tmp1,tmp2); %task-反映的是每个user的能力
                        if(tmp1<tmp2)
                            path(i,v+1)=1;
                        end
                    end  
            end
            
            max_quality(1,j)=max(max(dp));
            v=budget(j)+1;
            i=n1;%user
              while(i)
                   if(path(i,v)==1 && v)
                        v=v-user_expect(i,j);
                               
                    else
                        proposal_list(i,j)=0;
                        reject_list(i,j)=0; %用户被拒绝 user-task
                        
                   end
                    i=i-1;
              end 
end
expect=user_expect;
pairing_vec=proposal_list;