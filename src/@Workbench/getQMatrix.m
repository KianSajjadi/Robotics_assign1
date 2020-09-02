%% getQMatrix
% using trapezoidal velocity profile to find the qMatrix
function qMatrix = getQMatrix(workbench, robot, currentJoints, goalJoints, numSteps)
    s = lspb(0, 1, numSteps);
    
    if robot == workbench.robot1
        qMatrix = zeros(numSteps, 6);
    end
    
    if robot == workbench.robot2
        qMatrix = zeros(numSteps, 6);
    end
    
    for i = 1:numSteps
        qMatrix(i, :) = (1-s(i))*currentJoints + s(i)*goalJoints;
    end


%     qMatrix = jtraj(currentJoints, goalJoints, numSteps);
end