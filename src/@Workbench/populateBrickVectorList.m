%%populateBrickTransformList
% This function populates a vector list to then be turned into transforms
% later for the bricks.
function brickVectorList = populateBrickVectorList(~, robot)
    brickVectorList = zeros(9, 3);
    robotXYRadius = robot.maximumReachAndVolume(1, 1);
    robotBase = transl(robot.base);
    x = (-robotXYRadius + robotBase(1, 1) + (2*robotXYRadius + robotBase(1, 1)));
    y = (-robotXYRadius + robotBase(2, 1) + (2*robotXYRadius + robotBase(2, 1)));
    z = robotBase(3, 1);
    for i = 1:9
        brickVectorList(i, 1) = x * rand(1);
        brickVectorList(i, 2) = y * rand(1);
        brickVectorList(i, 3) = z;
    end
end