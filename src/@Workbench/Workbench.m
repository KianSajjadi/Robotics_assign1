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
        closestCoordsList
    end
    
    methods
        function self = Workbench()
            clf
            hold on
            self.robot1Base = transl(0, 0, 0);
            self.robot1 = UR3;
            self.robot1.model.teach();
            %self.robot2 = UR3;
            self.brickTransformList = self.populateBrickTransformList(self.robot1);
            for i = 1:9
                self.bricks{i, 1} = Brick(transl(self.brickTransformList(i, :)));
            end
            
            self.closestCoordsList = self.getClosestCoordsList(self.robot1, self.bricks);
            
        end
            
        function preRenderCalculationsList = generatePreRenderCalculations(self)
            isHolding = false;
            eff2PropTr = transl(0, 0, -0.073);
            currentJoints = zeros(1, 6);
            numSteps = 120;

        end
        
        function renderScene(preRenderCalculationsList)
            
        end
    end
    
end