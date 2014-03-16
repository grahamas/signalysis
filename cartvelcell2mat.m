function cartvelmat = cartvelcell2mat( cartvelcell )
%CARTVELCELL2MAT Takes cartvelcell to a matrix
%   

cartveltime = double([cartvelcell{:,2}]) - double(cartvelcell{1,2}) + double([cartvelcell{:,3}]) * 10^(-9);
cartvelmat = [[cartvelcell{:,1}]',cartveltime'];

end

