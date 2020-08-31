%% getPoseQMatrix
% using trapezoidal velocity profile to find the qMatrix
function qMatrix = getPoseQMatrix(~, startJoints, goalJoints, numSteps)

    %Ran into the issue where the qMatrix generated from the trapezoidal
    %velocity profile was causing issues with the robot colliding with
    %itself constantly
%     s = lspb(0, 1, numSteps);
%     qMatrix = zeros(numSteps, 6);
%     for i = 1:numSteps
%         qMatrix(i, :) = (1-s(i)) * startJoints + s(i) * goalJoints; 
%     end

    qMatrix = jtraj(startJoints, goalJoints, numSteps);
end