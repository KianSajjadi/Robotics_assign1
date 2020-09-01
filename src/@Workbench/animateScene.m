%% animateRobot
% This function utilises the animate function but adds in the functionality
% of moving the held prop with the robot end effector.

% function animateRobot(robot, qMatrix, isHolding, prop, effToPropTr)
%     numStepsMtx = size(qMatrix);
%     numSteps = numStepsMtx(1);
%     for i = 1:numSteps
%         drawnow()
%         %animate robot motion
%         animate(robot.model, qMatrix(i, :));
%         %animate prop motion
%         if isHolding == true
%             prop.updatePos(robot.model.fkine(qMatrix(i, :)) * effToPropTr);
%         end
%     end
% end

function animateScene(~, robot1, qMatrix1, is1HoldingBrick, robot1brick, robot2, qMatrix2, is2HoldingBrick, robot2brick)
    %assume numSteps the same for both robots
    numStepsMtx = size(qMatrix1);
    numSteps = numStepsMtx(1);
    for i = 1:numSteps
        drawnow()
        %animate robot motion
        if size(qMatrix1) > 1
            animate(robot1.model, qMatrix1(i, :));
        end
        
        if size(qMatrix2) > 1
            animate(robot2.model, qMatrix2(i, :));
        end
        
        if is1HoldingBrick == true
            newPos1 = robot1.model.fkine(qMatrix1(i, :)) * transl(0, 0, -0.01);
            robot1brick.updatePos(newPos1);
        end
        
        if is2HoldingBrick == true
            newPos2 = robot2.model.fkine(qMatrix2(i, :)) * transl(0, 0, 0.073);
            robot2brick.updatePos(newPos2);
        end
    end
end