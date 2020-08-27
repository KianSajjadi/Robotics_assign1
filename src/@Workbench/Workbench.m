classdef Workbench < handle
    properties
        robot1;
        robot2; 
        robot1Base; %these will be hardcoded
        robot2Base; 
        q1;
        q2;
        
        brickTransformList;
        bricks;
        wallBrickTransformList;
    end
    
    methods
        function self = Workbench()
            clf
            hold on
            self.robot1Base = transl(0, 0, 0);
            self.robot1 = UR3;
            self.robot1.model.teach()
            %self.robot2 = UR3;
            self.brickTransformList = self.populateBrickTransformList(self.robot1);
            for i = 1:9
                self.bricks{i, 1} = Brick(transl(self.brickTransformList(i, :)));
            end
        end
        
        function stackBricks(self)
            %distance between brick 1 and end effector
            %eff = self.robot1.model.fkine(self.robot1.model.getpos());
            brick1 = self.bricks{1, 1};
            closestCoords = self.findClosestPointBetweenEffAndBrick(self.robot1, brick1);
            isHolding = false;
            prop2EffTr = transl(0, 0, 0.073);
            eff2PropTr = self.homInvert(prop2EffTr);
            goalTr = transl(closestCoords);       
            currentJoints = self.robot1.model.getpos();
            numSteps = 120;
            q = self.robot1.moveRobot(goalTr, isHolding, brick1, eff2PropTr, currentJoints, numSteps);
        end
    end
    
end