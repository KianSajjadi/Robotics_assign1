%% animateRobot
% This function utilises the animate function but adds in the functionality
% of moving the held prop with the robot end effector.

function animateRobot(robot, qMatrix, isHolding, prop, effToPropTr)
    numSteps = size(qMatrix);
    numSteps = numSteps(1);
    for i = 1:numSteps
        drawnow()
        %animate robot motion
        animate(robot.model, qMatrix(i, :));
        %animate prop motion
        if isHolding == true
            prop.updatePos(robot.model.fkine(qMatrix(i, :)) * effToPropTr);
        end
    end
end