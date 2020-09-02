%%populateBrickTransformList
% This function populates a vector list to then be turned into transforms
% later for the bricks.
% function brickVectorList = populateBrickVectorList(~, robot)
%     brickVectorList = zeros(9, 3);
%     robotXYRadius = robot.maximumReachAndVolume(1, 1);
%     robotBase = transl(robot.base);
%     x = (-robotXYRadius + robotBase(1, 1) + (2*robotXYRadius + robotBase(1, 1)));
%     y = (-robotXYRadius + robotBase(2, 1) + (2*robotXYRadius + robotBase(2, 1)));
%     z = robotBase(3, 1);
%     for i = 1:9
%         brickVectorList(i, 1) = x * rand(1);
%         brickVectorList(i, 2) = y * rand(1);
%         brickVectorList(i, 3) = z;
%     end
% end

function brickTransformList = populateBrickTransformList(~)
    %Robot 1 Bricks
    brickTransformList{1, 1} = transl(-0.25, -0.2, 0.062);
    brickTransformList{3, 1} = transl(-0.25, -0.2, 0);
    brickTransformList{5, 1} = transl(-0.25 - 0.266, -0.2, 0.062);
    brickTransformList{7, 1} = transl(-0.25 - 0.266, -0.2, 0);
    brickTransformList{9, 1} = transl(-0.25 - 0.266, -0.4, 0);
    %Robot 2 Bricks
    brickTransformList{2, 1} = transl(0.3, 0.7, 0.062);
    brickTransformList{4, 1} = transl(0.3, 0.7, 0);
    brickTransformList{6, 1} = transl(-0.6, 0.5, 0.062);
    brickTransformList{8, 1} = transl(-0.6, 0.5, 0);
end