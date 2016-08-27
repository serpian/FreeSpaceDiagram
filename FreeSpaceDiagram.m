function y = FreeSpaceDiagram(P, Q, Frechet)

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

sum_P
sum_Q

%P = [0,0;1,2;2,0;3,2;4,0];
%Q = [0,2;2,0;4,2];

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
fig = figure;
if sum_P>1500 || sum_Q>1500
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
%set(gca,'YTickLabel',{'7' '6' '5' '4' '3' '2' '1' '0'})
%set(gca,'XTickLabel',{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'})
end