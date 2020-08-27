%% moveRobot
%this function utilises the animateRobot function to move the robot arm to
%a specific location that is determined by a goal transform and the current
%joints of the robot. Using the goal transform and inverse kinematics we
%can find the goal joints and thus get a pose qMatrix by utilising the
%trapezoidal velocity profile.
%This function also returns value endJoints = goalJoints so that we can
%make the next maneuvre afterwards.
function endJoints = moveRobot(robot, goalTr, isHolding, prop, eff2PropTr, currentJoints, numSteps)
    goalJoints = robot.model.ikcon(goalTr, currentJoints);
	qMatrix = robot.getPoseQMatrix(currentJoints, goalJoints, numSteps);
	endJoints = goalJoints;
	robot.animateRobot(qMatrix, isHolding, prop, eff2PropTr);
end