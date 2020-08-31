%% getClosestCoordsList
% this function returns a list of coordinates showing the closest point on
% the brick to the end effector. This function can be adapted in the future
% to work with any polygon prop
function closestCoordsList = getClosestCoordsList(workbench, robot, bricks)
    closestCoordsList = zeros(9, 3);
    for i = 1:9
        coords = workbench.findClosestPointBetweenEffAndBrick(robot, bricks{i, 1});
        for j = 1:3
            closestCoordsList(i, j) = coords(1, j);
        end
    end
end