%FreeSpaceDiagramDouble for closed curve


function y = FreeSpaceDiagramDouble(P, Q, Frechet,grid_flag)
%clear
num_P = length(P(:,1));
num_Q = length(Q(:,1));

grad_P = zeros(num_P,1);
grad_Q = zeros(num_Q,1);

length_P = zeros(num_P,1);
length_Q = zeros(num_Q,1);
partial_sum_P = zeros(num_P,1);
partial_sum_Q = zeros(num_Q,1);

sum_P = 0;
for k = 1:num_P - 1
 length_P(k) = int64(100*sqrt((P(k,2)-P(k+1,2))*(P(k,2)-P(k+1,2))+(P(k,1)-P(k+1,1))*(P(k,1)-P(k+1,1))));
 sum_P = sum_P + length_P(k);
 partial_sum_P(k) = sum_P;
end

sum_Q = 0;
for l = 1:num_Q - 1
 length_Q(l) = int64(100*sqrt((Q(l,2)-Q(l+1,2))*(Q(l,2)-Q(l+1,2))+(Q(l,1)-Q(l+1,1))*(Q(l,1)-Q(l+1,1))));
 sum_Q = sum_Q + length_Q(l);
 partial_sum_Q(l) = sum_Q; 
end

A = zeros(sum_Q,sum_P);

for i=1:sum_Q
    for j=1:sum_P
      A(i,j) = 1;
    end
end

for k = 1:num_P-1
  grad_P(k) = ((P(k,2)-P(k+1,2))/(P(k,1)-P(k+1,1))); 
end

for l = 1:num_Q-1
  grad_Q(l) = ((Q(l,2)-Q(l+1,2))/(Q(l,1)-Q(l+1,1)));
end

%pdist(P) For ratio

%Choose each two segments from P and Q.
for k=1:num_P-1
  for l=1:num_Q-1
      
    for i=1:length_P(k)
      t1 = (P(k+1,1)-P(k,1))*i/length_P(k)+P(k,1);
      t2 = (P(k+1,2)-P(k,2))*i/length_P(k)+P(k,2);
      for j=1:length_Q(l)
        u1 = (Q(l+1,1)-Q(l,1))*j/length_Q(l)+Q(l,1);
        u2 = (Q(l+1,2)-Q(l,2))*j/length_Q(l)+Q(l,2);
        if (u1 - t1)*(u1 - t1) + (u2 - t2)*(u2 - t2) <= Frechet*Frechet
          if k == 1 && l == 1
            A(i,j) = 0;
          elseif k == 1 && l ~= 1
            A(i,j+partial_sum_Q(l-1)) = 0;
          elseif k ~= 1 && l == 1
            A(i+partial_sum_P(k-1),j) = 0;
          else
            A(i+partial_sum_P(k-1),j+partial_sum_Q(l-1)) = 0;
          end
        end
      end
    end
    
  end
end
figure(1);
plot(P(:,1),P(:,2),'.-');
hold on;
plot(Q(:,1),Q(:,2),'.-');
fig = figure(2);
if sum_P>3000 || sum_Q>3000
  fig.Position = [1 1 sum_P/8 sum_Q/8];
elseif sum_P>1500 || sum_Q>1500
  fig.Position = [1 1 sum_P/4 sum_Q/4];
elseif sum_P>750 || sum_Q>750
  fig.Position = [1 1 sum_P/2 sum_Q/2];
else
  fig.Position = [1 1 sum_P sum_Q];
end

imagesc(A);            %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)
set(gca,'Ydir','Normal') %# Reverse the y-axis (Optional step)
title('Free Space Diagram between P and Q');
xlabel('Parameter space of P') % x-axis label
ylabel('Parameter space of Q') % y-axis label
hold on;
vertex_P=zeros(sum_Q,num_P-1);
vertex_Q=zeros(sum_P,num_Q-1);
for i=1:num_P-1
  for j=1:sum_Q
    vertex_P(j,i)=partial_sum_P(i);
  end
end
for i=1:num_Q-1
  for j=1:sum_P
    vertex_Q(j,i)=partial_sum_Q(i);
  end
end
if grid_flag == 1
    for i=1:num_P-1
      plot(vertex_P(:,i),1:sum_Q,'b');
    end
    for i=1:num_Q-1
      plot(1:sum_P,vertex_Q(:,i),'r');
    end
end
%set(gca,'YTickLabel',{'7' '6' '5' '4' '3' '2' '1' '0'})
%set(gca,'XTickLabel',{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'})
end