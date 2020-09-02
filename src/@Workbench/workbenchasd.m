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
        closestCoordsList;
        renderData;
    end
    
    methods
        function self = Workbench()
            clf
            hold on
            self.robot1Base = transl(0, -0.3, 0);
            self.robot1 = UR3(self.robot1Base);
            self.robot2Base = transl(0, 0.5, 0);
            self.robot2 = UR5(self.robot2Base);
            self.brickTransformList = self.populateBrickTransformList();
            for i = 1:9
                self.bricks{i, 1} = Brick(self.brickTransformList{i, 1});
            end
            
            %self.closestCoordsList = self.getClosestCoordsList(self.robot1, self.bricks);
            self.renderData = self.getRenderData();            
        end
        
        %This function gathers all the renderData required for renderScene
        %to animate the robot and brick. The first two columns contain the
        %qMatrices and boolean values of if the prop is being held of robot 1
        %and the last two columns contain the qMatrices and boolean values
        %of if the prop is being held of robot 2. The fifth and sixth column is
        %reserved for the brick each robot is interacting with
        function renderData = getRenderData(self)
            numSteps = 10;
            %% Step 1: Robot1 to brick1
                %Robot 1 Brick 1
            brick1InitTr = transl(self.bricks{1, 1}.pos) * trotx(pi);
            currentJoints1 = zeros(1, 6);
            brick1InitGoalJoints = self.getRobotGoalJoints(self.robot1, brick1InitTr, currentJoints1);
            brick1InitQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick1InitGoalJoints, numSteps);
            renderData{1, 1} = brick1InitQMatrix;
            renderData{1, 2} = false;
            renderData{1, 3} = self.bricks{1, 1};
            currentJoints1 = brick1InitGoalJoints;
            
            %% Step 2: Robot1/Brick1 Clearance, Robot2 to Brick2
                %Robot 1 Brick 1
            brick1ClearanceTr = brick1InitTr * transl(0, 0, -0.05);
            brick1ClearanceGoalJoints = self.getRobotGoalJoints(self.robot1, brick1ClearanceTr, currentJoints1);
            brick1ClearanceQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick1ClearanceGoalJoints, numSteps);
            renderData{2, 1} = brick1ClearanceQMatrix;
            renderData{2, 2} = true;
            renderData{2, 3} = self.bricks{1, 1};
            currentJoints1 = brick1ClearanceGoalJoints;
                %Robot 2 Brick 2
            brick2InitTr = transl(self.bricks{2, 1}.pos) * transl(0, 0, 0.072) * trotx(pi);
            currentJoints2 = zeros(1, 6);
            brick2InitGoalJoints = self.getRobotGoalJoints(self.robot2, brick2InitTr, currentJoints2);
            brick2InitQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick2InitGoalJoints, numSteps);
            renderData{1, 4} = 0;
            renderData{1, 5} = false;
            renderData{1, 6} = 0;
            renderData{2, 4} = brick2InitQMatrix;
            renderData{2, 5} = false;
            renderData{2, 6} = self.bricks{2, 1};
            currentJoints2 = brick2InitGoalJoints;
            
            %% Step 3: Robot1/Brick 1 Wall Pos, Robot2/Brick2 Clearance
            %2 to clearance area
                %Robot 1 Brick 1
            robot1BaseY = 0;%self.robot1.model.base(2, 4);
            brick1EndTr = transl(-0.266, robot1BaseY, 0.062) * trotx(pi);
            brick1EndGoalJoints = self.getRobotGoalJoints(self.robot1, brick1EndTr, currentJoints1);
            brick1EndQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick1EndGoalJoints, numSteps);
            renderData{3, 1} = brick1EndQMatrix;
            renderData{3, 2} = true;
            renderData{3, 3} = self.bricks{1, 1};
            currentJoints1 = brick1EndGoalJoints;
                %Robot 2 Brick 2
            brick2ClearanceTr = brick2InitTr * transl(0, 0, -0.2);
            brick2ClearanceGoalJoints = self.getRobotGoalJoints(self.robot2, brick2ClearanceTr, currentJoints2);
            brick2ClearanceQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick2ClearanceGoalJoints, numSteps);
            renderData{3, 4} = brick2ClearanceQMatrix;
            renderData{3, 5} = true;
            renderData{3, 6} = self.bricks{2, 1};
            currentJoints2 = brick2ClearanceGoalJoints;
            
            %% Step 4: Robot1 to Brick3, Robot2/Brick2 Wall Pos
                %Robot 1 Brick 3
            brick3InitTr = transl(self.bricks{3, 1}.pos) * trotx(pi);
            brick3InitJoints = self.getRobotGoalJoints(self.robot1, brick3InitTr, currentJoints1);
            brick3InitQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick3InitJoints, numSteps);
            renderData{4, 1} = brick3InitQMatrix;
            renderData{4, 2} = false;
            renderData{4, 3} = self.bricks{3, 1};
            currentJoints1 = brick3InitJoints;
                %Robot 2 Brick 2
            brick2EndTr = transl(0.266, 0, 0.146) * trotx(pi);
            brick2EndGoalJoints = self.getRobotGoalJoints(self.robot2, brick2EndTr, currentJoints2);
            brick2EndQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick2EndGoalJoints, numSteps);
            renderData{4, 4} = brick2EndQMatrix;
            renderData{4, 5} = true;
            renderData{4, 6} = self.bricks{2, 1};
            currentJoints2 = brick2EndGoalJoints;
            
            %% Step 5: Robot1 Brick3 Wall Pos, Robot2 to Brick4
                %Robot 1 Brick 3
            brick3EndTr = transl(-0.266, robot1BaseY, 0.124) * trotx(pi);
            brick3EndGoalJoints = self.getRobotGoalJoints(self.robot1, brick3EndTr, currentJoints1);
            brick3EndQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick3EndGoalJoints, numSteps);
            renderData{5, 1} = brick3EndQMatrix;
            renderData{5, 2} = true;
            renderData{5, 3} = self.bricks{3, 1};
            currentJoints1 = brick3EndGoalJoints;
                %Robot 2 Brick 4
            brick4InitTr = transl(self.bricks{4, 1}.pos) * transl(0, 0, 0.072) * trotx(pi);
            brick4InitGoalJoints = self.getRobotGoalJoints(self.robot2, brick4InitTr, currentJoints2);
            brick4InitQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick4InitGoalJoints, numSteps);
            renderData{5, 4} = brick4InitQMatrix;
            renderData{5, 5} = false;
            renderData{5, 6} = self.bricks{4, 1};
            currentJoints2 = brick4InitGoalJoints;
            
            %% Step 6:Robot1 to Brick5, Robot2 Brick4 Wall Pos
                %Robot 1 Brick 5
            brick5InitTr = transl(self.bricks{5, 1}.pos) * trotx(pi);
            brick5InitGoalJoints = self.getRobotGoalJoints(self.robot1, brick5InitTr, currentJoints1);
            brick5InitQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick5InitGoalJoints, numSteps);
            renderData{6, 1} = brick5InitQMatrix;
            renderData{6, 2} = false;
            renderData{6, 3} = self.bricks{5, 1};
            currentJoints1 = brick5InitGoalJoints;
                %Robot 2 Brick 4
            brick4EndTr = transl(0.266, robot1BaseY, 0.208) * trotx(pi);
            brick4EndGoalJoints = self.getRobotGoalJoints(self.robot2, brick4EndTr, currentJoints2);
            brick4EndQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick4EndGoalJoints, numSteps);
            renderData{6, 4} = brick4EndQMatrix;
            renderData{6, 5} = true;
            renderData{6, 6} = self.bricks{4, 1};
            currentJoints2 = brick4EndGoalJoints;
            
            %% Step 7: Robot1 Brick 5 Clearance, Robot2 to Brick6
                %Robot 1 Brick 5
            brick5ClearanceTr = transl(-0.266, robot1BaseY, 0.3) * trotx(pi);
            brick5ClearanceGoalJoints = self.getRobotGoalJoints(self.robot1, brick5ClearanceTr, currentJoints1);
            brick5ClearanceQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick5ClearanceGoalJoints, numSteps);
            renderData{7, 1} = brick5ClearanceQMatrix;
            renderData{7, 2} = true;
            renderData{7, 3} = self.bricks{5, 1};
            currentJoints1= brick5ClearanceGoalJoints;
                %Robot 2  Brick 6
            brick6InitTr = transl(self.bricks{6, 1}.pos) * transl(0, 0, 0.072) * trotx(pi);
            brick6InitGoalJoints = self.getRobotGoalJoints(self.robot2, brick6InitTr, currentJoints2);
            brick6InitQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick6InitGoalJoints, numSteps);
            renderData{7, 4} = brick6InitQMatrix;
            renderData{7, 5} = false;
            renderDatA{7, 6} = self.bricks{6, 1};
            currentJoints2 = brick6InitGoalJoints;
            
            %% Step 8: Robot1/Brick5 Wall pos, Robot2/Brick6 Clearance
                %Robot 1 Brick 5
            brick5EndTr = transl(-0.266, robot1BaseY, 0.186) * trotx(pi);
            brick5EndGoalJoints = self.getRobotGoalJoints(self.robot1, brick5EndTr, currentJoints1);
            brick5EndQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick5EndGoalJoints, numSteps);
            renderData{8, 1} = brick5EndQMatrix;
            renderData{8, 2} = true;
            renderData{8, 3} = self.bricks{5, 1};
            currentJoints1 = brick5EndGoalJoints;
                %Robot 2 Brick 6
            brick6ClearanceTr = transl(0.266, 0, 0.28) * trotx(pi);
            brick6ClearanceGoalJoints = self.getRobotGoalJoints(self.robot2, brick6ClearanceTr, currentJoints2);
            brick6ClearanceQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick6ClearanceGoalJoints, numSteps);
            renderData{8, 4} = brick6ClearanceQMatrix;
            renderData{8, 5} = true;
            renderData{8, 6} = self.bricks{6, 1};
            currentJoints2 = brick6ClearanceGoalJoints;
            
            %% Step 9: Robot1 to Brick7, Robot2/Brick6 Wall pos
                %Robot 1 Brick 7
            brick7InitTr = transl(self.bricks{7, 1}.pos) * trotx(pi);
            brick7InitGoalJoints = self.getRobotGoalJoints(self.robot1, brick7InitTr, currentJoints1);
            brick7InitQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick7InitGoalJoints, numSteps);
            renderData{9, 1} = brick7InitQMatrix;
            renderData{9, 2} = false;
            renderData{9, 3} = self.bricks{7, 1};
            currentJoints1 = brick7InitGoalJoints;
                %Robot 2 Brick 6
            brick6EndTr = transl(0.266, robot1BaseY, 0.268) * trotx(pi);
            brick6EndGoalJoints = self.getRobotGoalJoints(self.robot2, brick6EndTr, currentJoints2);
            brick6EndQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick6EndGoalJoints, numSteps);
            renderData{9, 4} = brick6EndQMatrix;
            renderData{9, 5} = true;
            renderData{9, 6} = self.bricks{6, 1};
            currentJoints2 = brick6EndGoalJoints;
            
            %% Step 10: Robot1/Brick7 Wall Pos, Robot2 to Brick 8
                %Robot 1 Brick 7
            brick7ClearanceTr = transl(0, robot1BaseY, 0.3) * trotx(pi);
            brick7ClearanceGoalJoints = self.getRobotGoalJoints(self.robot1, brick7ClearanceTr, currentJoints1);
            brick7ClearanceQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick7ClearanceGoalJoints, numSteps);
            renderData{10, 1} = brick7ClearanceQMatrix;
            renderData{10, 2} = true;
            renderData{10, 3} = self.bricks{7, 1};
            currentJoints1 = brick7ClearanceGoalJoints;
                %Robot 2 Brick 8 
            brick8InitTr = transl(self.bricks{8, 1}.pos) * transl(0, 0, 0.072) * trotx(pi);
            brick8InitGoalJoints = self.getRobotGoalJoints(self.robot2, brick8InitTr, currentJoints2);
            brick8InitQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick8InitGoalJoints, numSteps);
            renderData{10, 4} = brick8InitQMatrix;
            renderData{10, 5} = false;
            renderData{10, 6} = self.bricks{8, 1};
            currentJoints2 = brick8InitGoalJoints;
            
            %% Step 11: Robot1/Brick7 Wall Pos, Robot2/Brick8 Clearance
                %Robot 1 Brick 9
            brick7EndTr = transl(0, robot1BaseY, 0.062) * trotx(pi);
            brick7EndGoalJoints = self.getRobotGoalJoints(self.robot1, brick7EndTr, currentJoints1);
            brick7EndQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick7EndGoalJoints, numSteps);
            renderData{11, 1} = brick7EndQMatrix;
            renderData{11, 2} = true;
            renderData{11, 3} = self.bricks{7, 1};
            currentJoints1 = brick7EndGoalJoints;   
                %Robot 2 Brick 8
            brick8ClearanceTr = transl(0, robot1BaseY, 0.4) * trotx(pi);
            brick8ClearanceGoalJoints = self.getRobotGoalJoints(self.robot2, brick8ClearanceTr, currentJoints2);
            brick8ClearanceQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick8ClearanceGoalJoints, numSteps);
            renderData{11, 4} = brick8ClearanceQMatrix;
            renderData{11, 5} = true;
            renderData{11, 6} = self.bricks{8, 1};
            currentJoints2 = brick8ClearanceGoalJoints;

            %% Step 12: Robot1 to Brick 9,  Robot2/Brick8 Wall Pos
                %Robot 1 Brick 9
            brick9InitTr = transl(self.bricks{9, 1}.pos) * trotx(pi);
            brick9InitGoalJoints = self.getRobotGoalJoints(self.robot1, brick9InitTr, currentJoints1);
            brick9InitQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick9InitGoalJoints, numSteps);
            renderData{12, 1} = brick9InitQMatrix;
            renderData{12, 2} = false;
            renderData{12, 3} = self.bricks{9, 1};
            currentJoints1 = brick9InitGoalJoints;
                %Robot 2 Brick 8
            brick8EndTr = transl(0, robot1BaseY, 0.206) * trotx(pi);
            brick8EndGoalJoints = self.getRobotGoalJoints(self.robot2, brick8EndTr, currentJoints2);
            brick8EndQMatrix = self.getQMatrix(self.robot2, currentJoints2, brick8EndGoalJoints, numSteps);
            renderData{12, 4} = brick8EndQMatrix;
            renderData{12, 5} = true;
            renderData{12, 6} = self.bricks{8, 1};
            currentJoints2 = brick8EndGoalJoints;
            
            %% Step 13: Robot1/Brick9 Clearance, Robot2 Clearance
                %Robot 1 Brick 9
            brick9ClearanceTr = transl(0, robot1BaseY, 0.4) * trotx(pi);
            brick9ClearanceGoalJoints = self.getRobotGoalJoints(self.robot1, brick9ClearanceTr, currentJoints1);
            brick9ClearanceQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick9ClearanceGoalJoints, numSteps);
            renderData{13, 1} = brick9ClearanceQMatrix;
            renderData{13, 2} = true;
            renderData{13, 3} = self.bricks{9, 1};
            currentJoints1 = brick9ClearanceGoalJoints;
                %Robot 2
            robot2EndQMatrix = self.getQMatrix(self.robot2, currentJoints2, zeros(1, 6), numSteps);
            renderData{13, 4} = robot2EndQMatrix;
            renderData{13, 5} = false;
            renderData{13, 6} = self.bricks{9, 1};
            
            %% Step 14 Robot1/Brick9 Wall Pos
            brick9EndTr = transl(0, robot1BaseY, 0.186) * trotx(pi);
            brick9EndGoalJoints = self.getRobotGoalJoints(self.robot1, brick9EndTr, currentJoints1);
            brick9EndQMatrix = self.getQMatrix(self.robot1, currentJoints1, brick9EndGoalJoints, numSteps);
            renderData{14, 1} = brick9EndQMatrix;
            renderData{14, 2} = true;
            renderData{14, 3} = self.bricks{9, 1};
            currentJoints1 = brick9EndGoalJoints;
            
            renderData{14, 4} = 0;
            renderData{14, 4} = false;
            renderData{14, 4} = 0;
        end
        %% Render Function
        function renderScene(self)
            listSize = size(self.renderData);
            iteratorSize = listSize(1);
            for i = 1:iteratorSize
                self.animateScene(...
                                self.robot1, self.renderData{i, 1}, self.renderData{i, 2}, ...
                                self.renderData{i, 3}, self.robot2, self.renderData{i, 4}, ...
                                self.renderData{i, 5}, self.renderData{i, 6} ...
                            );
            end
        end
    end
    
end