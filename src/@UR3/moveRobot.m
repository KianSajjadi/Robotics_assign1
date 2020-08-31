%% getRobotEndJoints
%this function utilises the qMatrix generated through using the quintic
%polynomial jtratj function. The trapezoidal function was originally used
%however would come up with erratic robot arm movements. This function
%takes a robot arm, a goal transformation and the current joints to
%generate the endJoints of the robot movements.
function endJoints = getRobotEndJoints(robot, goalTr, isHolding, prop, eff2PropTr, currentJoints, numSteps)
    goalJoints = robot.model.ikine(goalTr, currentJoints);
	qMatrix = robot.getPoseQMatrix(currentJoints, goalJoints, numSteps);
	endJoints = goalJoints;
	numStepsMtx = size(qMatrix);
    numSteps = numStepsMtx(1);
    for i = 1:numSteps
        drawnow()
        %animate doesn't save end effector position, therefore we must use
        %forward kinematics to calculate it
        animate(robot.model, qMatrix(i, :));
        %animate prop motion
        if isHolding == true
            prop.updatePos(robot.model.fkine(qMatrix(i, :)) * eff2PropTr);
        end
    end
end