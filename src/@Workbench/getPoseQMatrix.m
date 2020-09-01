%% getPoseQMatrix
% using trapezoidal velocity profile to find the qMatrix
function qMatrix = getPoseQMatrix(~, currentJoints, goalJoints, numSteps)
    s = lspb(0, 1, numSteps);
    qMatrix = zeros(numSteps, 6);
    for i = 1:numSteps
        qMatrix(i, :) = (1-s(i))*currentJoints + s(i)*goalJoints; 
    end
    

%     qMatrix = jtraj(currentJoints, goalJoints, numSteps);
end