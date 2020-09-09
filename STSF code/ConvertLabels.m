function [new_y_train,new_y_test] = ConvertLabels(y_train,y_test)
    all_classes = sort(unique(y_train)); 
    if isequal(all_classes(1),0) %classes that start with 0...e.g., 0,1 or 0,1,2,3,4,5
        y_train = y_train + 1;
        y_test = y_test + 1;
    elseif all_classes(1)>1 %classes that start with values larger than 1..e.g. 3,4,5,6
        get_initclass = all_classes(1);
        difference = get_initclass - 1;
        y_train = y_train - difference;
        y_test = y_test - difference;
    else %%% classes that start with -1,1 it'll changed to  2,1, otherwise the labels won't be changed
        y_train(y_train < 0) = 2; 
        y_test(y_test < 0) = 2;

    end
    
    new_y_train = y_train;
    new_y_test = y_test;
end

