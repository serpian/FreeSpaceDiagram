%P is polygon. And S1 and S2 are segments. 
%ex P = [0,0 ; 4,10; 6,4 ; 7,5 ; 13,0 ; 0,0] S1 = [2,5 ; 4,10 ; 5,7] S2 =[6,4
%; 7,5 ; 8,4]
% hourglass([0,0 ; 4,10; 6,4 ; 8,8 ; 16,0 ; 0,0],[2,5 ; 4,10 ; 5,7],[7,6 ;8,8 ; 9,7])
function y = hourglass(P, S1, S2)
%We first check whether S1 and S2 belongs to polygon P. If not, we end the
%algorithm and return -1;
  num_P = length(P(:,1));
  num_S1 = length(S1(:,1));
  num_S2 = length(S2(:,1));
  figure;
  hold on
  plot(P(:,1),P(:,2),'k.-');
  plot(S1(:,1),S1(:,2),'r.-');
  plot(S2(:,1),S2(:,2),'.-');
  
  for i=1:num_P - 1
    
  end

end