%% getRenderData
% this function uses a datalist with structure dataList = {Robot, GoalTr,
% isHolding, brick#} to return a list of all the renderData required to
% animate the robots.
function renderData = getRenderData(workbench, dataList)
    numSteps = 10;
    currentJoints = zeros(1, 6);
    sizeListMtx = size(dataList);
    sizeList = sizeListMtx(1);
    renderData = cell(sizeList, 6);
    
    for i = 1:sizeList
        if dataList{i, 1} == 0
            renderData{i, 1} = 0;
            renderData{i, 2} = false;
            renderData{i, 3} = 0;
        else
            goalJoints = workbench.getRobotGoalJoints(dataList{i, 1}, dataList{i, 2}, currentJoints);
            qMatrix = workbench.getQMatrix(dataList{i, 1}, currentJoints, goalJoints, numSteps);
            currentJoints = goalJoints;
            renderData{i, 1} = qMatrix;
            renderData{i, 2} = dataList{i, 3};
            renderData{i, 3} = dataList{i, 4};
        end
    end
    
end