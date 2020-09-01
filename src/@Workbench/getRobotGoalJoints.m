%% getRobotGoalJoints
%this function utilises the qMatrix generated through using the quintic
%polynomial jtratj function. The trapezoidal function was originally used
%however would come up with erratic robot arm movements. This function
%takes a robot arm, a goal transformation, and the current joints to
%generate the goalJoints
function goalJoints = getRobotGoalJoints(~, robot, goalTr, currentJoints)
    goalJoints = robot.model.ikcon(goalTr, currentJoints);
end