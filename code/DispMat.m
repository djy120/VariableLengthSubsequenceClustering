function DispMat(A)
[row,col] = size(A);

for i = 1:row
    str = '        ';
    for j = 1:col
        str = [str, num2str(A(i,j)),'       ']; %#ok<AGROW>
    end
    disp(str);
end
