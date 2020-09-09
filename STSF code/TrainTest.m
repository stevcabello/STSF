function [X_train, y_train, X_test, y_test] = TrainTest(str)

temp1 =what;dir0=temp1.path;dir1=[dir0 '/' 'datasetsUCR/'];

%uncomment this to change the datasets directory to your corresponding folder
% dir1=['/Users/ncabello/Documents/Univariate_arff/'];

str=char(str);
testDir= [dir1 str '/' str '_TEST.txt'];
trainDir= [dir1 str '/' str '_TRAIN.txt'];
TEST = load(testDir); 
TRAIN= load(trainDir);

X=TRAIN;X(:,1)=[];
y=TRAIN(:,1);

TEST1 = TEST;
clsTest=TEST1(:,1);
TEST1(:,1)=[];

X_train = X;
y_train = y;
X_test = TEST1;
y_test = clsTest;


end

