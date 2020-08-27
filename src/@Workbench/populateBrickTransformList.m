%%populateBrickTransformList
% This function populates the bricktransform list with a number of random
% coordinates within the radius of the robot at any given base
function brickTransformList = populateBrickTransformList(~, robot)
    brickTransformList = zeros(9, 3);
    robotXYRadius = robot.maximumReachAndVolume(1, 1);
    robotBase = transl(robot.base);
    x = (-robotXYRadius + robotBase(1, 1) + (2*robotXYRadius + robotBase(1, 1)));
    y = (-robotXYRadius + robotBase(2, 1) + (2*robotXYRadius + robotBase(2, 1)));
    z = robotBase(3, 1);
    for i = 1:9
        brickTransformList(i, 1) = x * rand(1);
        brickTransformList(i, 2) = y * rand(1);
        brickTransformList(i, 3) = z;
    end
end