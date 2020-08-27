%% getPoseQMatrix
% using trapezoidal velocity profile to find the qMatrix
function qMatrix = getPoseQMatrix(~, startJoints, goalJoints, numSteps)
    s = lspb(0, 1, numSteps);
    qMatrix = zeros(numSteps, 6);
    for i = 1:numSteps
        qMatrix(i, :) = startJoints + s(i) * (goalJoints - startJoints);
    end
end