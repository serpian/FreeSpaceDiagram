function y = FreeSpaceDiagram(P, Q, Frechet)

num_P = length(P(:,1));
num_Q = length(Q(:,1));
A = zeros(101*(num_Q-1),101*(num_P-1));

for i=1:101*(num_Q-1)
    for j=1:101*(num_P-1)
      A(i,j) = 1;
    end
end

%P = [0,0;1,2;2,0;3,2;4,0];
%Q = [0,2;2,0;4,2];


for k = 1:num_P-1
  grad_P(k,1) = ((P(k,2)-P(k+1,2))/(P(k,1)-P(k+1,1))); 
end

for l = 1:num_Q-1
  grad_Q(l,1) = ((Q(l,2)-Q(l+1,2))/(Q(l,1)-Q(l+1,1)));
end

%pdist(P) For ratio

for k=1:num_Q-1
  for l=1:num_P-1
      
    for i=1:101
      t = (Q(k+1,1)-Q(k,1))*0.01*(i-1)+Q(k,1);
      flag = 0;
      t2 = grad_Q(k)*(t-Q(k,1))+Q(k,2);
      for j=1:101
        x = (P(l+1,1)-P(l,1))*0.01*(j-1)+P(l,1);
        x2 = grad_P(l)*(x-P(l,1)) + P(l,2);
        if (x - t)*(x - t) + (x2 - t2)*(x2 - t2) <= Frechet*Frechet
          A(i+101*(k-1),j+101*(l-1)) = 0;
        end
      end
    end
    
  end
end

imagesc(A);            %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)                         
end