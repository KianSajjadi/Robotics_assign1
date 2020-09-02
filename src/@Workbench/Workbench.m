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
        renderData1;
        renderData2;
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
            self.renderData1;
            self.renderData2;
            self.preAnimateCalcs;
        end
        
        %This function gathers all the renderData required for renderScene
        %to animate the robot and brick. The first two columns contain the
        %qMatrices and boolean values of if the prop is being held of robot 1
        %and the last two columns contain the qMatrices and boolean values
        %of if the prop is being held of robot 2. The fifth and sixth column is
        %reserved for the brick each robot is interacting with
        function preAnimateCalcs(self)
            numSteps = 10;
            %% Step 1: Robot1 to brick1
                %Robot 1 Brick 1          
            brickTr = transl(self.bricks{1, 1}.pos) * trotx(pi);
            isHolding = false;
            brick = self.bricks{1, 1};
            dataList1(1, :) = {self.robot1, brickTr, isHolding, brick};
            dataList2(1, :) = {0, 0, 0, 0};
            %% Step 2: Robot1/Brick1 Clearance, Robot2 to Brick2
                %Robot 1 Brick 1
            brickTr = transl(self.bricks{1, 1}.pos) * trotx(pi) * transl(0, 0, -0.05);
            isHolding = true;
            brick = self.bricks{1, 1};
            dataList1(2, :) = {self.robot1, brickTr, isHolding, brick};            
                %Robot 2 Brick 2
            brickTr = transl(self.bricks{2, 1}.pos) * transl(0, 0, 0.072) * trotx(pi);
            isHolding = false;
            brick = self.bricks{2, 1};
            dataList2(2, :) = {self.robot2, brickTr, isHolding, brick};
            %% Step 3: Robot1/Brick 1 Wall Pos, Robot2/Brick2 Clearance
            %2 to clearance area
                %Robot 1 Brick 1
            wallMiddle = 0;%self.robot1.model.base(2, 4);
            brickTr = transl(-0.266, wallMiddle, 0.062) * trotx(pi);
            isHolding = true;
            brick = self.bricks{1, 1};
            dataList1(3, :) = {self.robot1, brickTr, isHolding, brick}; 
                %Robot 2 Brick 2
            brickTr = transl(self.bricks{2, 1}.pos) * transl(0, 0, 0.072) * trotx(pi) * transl(0, 0, -0.2);
            isHolding = true;
            brick = self.bricks{2, 1};
            dataList2(3, :) = {self.robot2, brickTr, isHolding, brick}; 
            
            %% Step 4: Robot1 to Brick3, Robot2/Brick2 Wall Pos
                %Robot 1 Brick 3
            brickTr = transl(self.bricks{3, 1}.pos) * trotx(pi);
            isHolding = false;
            brick = self.bricks{3, 1};
            dataList1(4, :) = {self.robot1, brickTr, isHolding, brick};
                %Robot 2 Brick 2
            brickTr = transl(0.266, 0, 0.146) * trotx(pi);
            isHolding = true;
            brick = self.bricks{2, 1};
            dataList2(4, :) = {self.robot2, brickTr, isHolding, brick};
            
            %% Step 5: Robot1 Brick3 Wall Pos, Robot2 to Brick4
                %Robot 1 Brick 3
            brickTr = transl(-0.266, wallMiddle, 0.124) * trotx(pi);
            isHolding = true;
            brick = self.bricks{3, 1};
            dataList1(5, :) = {self.robot1, brickTr, isHolding, brick};
                %Robot 2 Brick 4
            brickTr = transl(self.bricks{4, 1}.pos) * transl(0, 0, 0.072) * trotx(pi);
            isHolding = false;
            brick = self.bricks{4, 1};
            dataList2(5, :) = {self.robot2, brickTr, isHolding, brick};
            
            %% Step 6:Robot1 to Brick5, Robot2 Brick4 Wall Pos
                %Robot 1 Brick 5
            brickTr = transl(self.bricks{5, 1}.pos) * trotx(pi);
            isHolding = false;
            brick = self.bricks{5, 1};
            dataList1(6, :) = {self.robot1, brickTr, isHolding, brick};
                %Robot 2 Brick 4
            brickTr = transl(0.266, wallMiddle, 0.208) * trotx(pi);
            isHolding = true;
            brick = self.bricks{4, 1};
            dataList2(6, :) = {self.robot2, brickTr, isHolding, brick};
            
            %% Step 7: Robot1 Brick 5 Clearance, Robot2 to Brick6
                %Robot 1 Brick 5
            brickTr = transl(-0.266, wallMiddle, 0.3) * trotx(pi);
            isHolding = true;
            brick = self.bricks{5, 1};
            dataList1(7, :) = {self.robot1, brickTr, isHolding, brick};
                %Robot 2  Brick 6
            brickTr = transl(self.bricks{6, 1}.pos) * transl(0, 0, 0.072) * trotx(pi);
            isHolding = false;
            brick = self.bricks{6, 1};
            dataList2(7, :) = {self.robot2, brickTr, isHolding, brick};
            
            %% Step 8: Robot1/Brick5 Wall pos, Robot2/Brick6 Clearance
                %Robot 1 Brick 5
            brickTr = transl(-0.266, wallMiddle, 0.186) * trotx(pi);
            isHolding = true;
            brick = self.bricks{5, 1};
            dataList1(8, :) = {self.robot1, brickTr, isHolding, brick};
                %Robot 2 Brick 6
            brickTr = transl(0.266, 0, 0.28) * trotx(pi);
            isHolding = true;
            brick = self.bricks{6, 1};
            dataList2(8, :) = {self.robot2, brickTr, isHolding, brick};
            
            %% Step 9: Robot1 to Brick7, Robot2/Brick6 Wall pos
                %Robot 1 Brick 7
            brickTr = transl(self.bricks{7, 1}.pos) * trotx(pi);
            isHolding = false;
            brick = self.bricks{7, 1};
            dataList1(9, :) = {self.robot1, brickTr, isHolding, brick};
                %Robot 2 Brick 6
            brickTr = transl(0.266, wallMiddle, 0.268) * trotx(pi);
            isHolding = true;
            brick = self.bricks{6, 1};
            dataList2(9, :) = {self.robot2, brickTr, isHolding, brick};
            %% Step 10: Robot1/Brick7 Wall Pos, Robot2 to Brick 8
                %Robot 1 Brick 7
            brickTr = transl(0, wallMiddle, 0.3) * trotx(pi);
            isHolding = true;
            brick = self.bricks{7, 1};
            dataList1(10, :) = {self.robot1, brickTr, isHolding, brick};
                %Robot 2 Brick 8 
            brickTr = transl(self.bricks{8, 1}.pos) * transl(0, 0, 0.072) * trotx(pi);
            isHolding = false;
            brick = self.bricks{8, 1};
            dataList2(10, :) = {self.robot2, brickTr, isHolding, brick};
            %% Step 11: Robot1/Brick7 Wall Pos, Robot2/Brick8 Clearance
                %Robot 1 Brick 9
            brickTr = transl(0, wallMiddle, 0.062) * trotx(pi);
            isHolding = true;
            brick = self.bricks{7, 1};
            dataList1(11, :) = {self.robot1, brickTr, isHolding, brick};
                %Robot 2 Brick 8
            brickTr = transl(0, wallMiddle, 0.4) * trotx(pi);
            isHolding = true;
            brick = self.bricks{8, 1};
            dataList2(11, :) = {self.robot2, brickTr, isHolding, brick};

            %% Step 12: Robot1 to Brick 9,  Robot2/Brick8 Wall Pos
                %Robot 1 Brick 9
            brickTr = transl(self.bricks{9, 1}.pos) * trotx(pi);
            isHolding = false;
            brick = self.bricks{9, 1};
            dataList1(12, :) = {self.robot1, brickTr, isHolding, brick};
                %Robot 2 Brick 8
            brickTr = transl(0, wallMiddle, 0.206) * trotx(pi);
            isHolding = true;
            brick = self.bricks{8, 1};
            dataList2(12, :) = {self.robot2, brickTr, isHolding, brick};
            
            %% Step 13: Robot1/Brick9 Clearance, Robot2 Clearance
                %Robot 1 Brick 9
            brickTr = transl(0, wallMiddle, 0.4) * trotx(pi);
            isHolding = true;
            brick = self.bricks{9, 1};
            dataList1(13, :) = {self.robot1, brickTr, isHolding, brick};
                %Robot 2
            brickTr = transl(0, 0.5, 0.5);
            isHolding = false;
            brick = self.bricks{8, 1};
            dataList2(13, :) = {self.robot2, brickTr, isHolding, brick};
            
            %% Step 14 Robot1/Brick9 Wall Pos
            brickTr = transl(0, wallMiddle, 0.186) * trotx(pi);
            isHolding = true;
            brick = self.bricks{9, 1};
            dataList1(14, :) = {self.robot1, brickTr, isHolding, brick};
            
            dataList2(14, :) = {0, 0, 0, 0};
            
            
            %% Step 15 Robot1 pose
                %Robot 1
            brickTr = transl(0, -0.3, 0.7);
            isHolding = false;
            brick = self.bricks{9, 1};
            dataList1(15, :) = {self.robot1, brickTr, isHolding, brick};
            
            dataList2(15, :) = {0, 0, 0, 0};
                
                
            %% Generate Render Data for Animation
            self.renderData1 = self.getRenderData(dataList1);
            self.renderData2 = self.getRenderData(dataList2);
        end
        %% Render Function
        function renderScene(self)
            listSize = size(self.renderData1);
            iteratorSize = listSize(1);
            for i = 1:iteratorSize
                self.animateScene(...
                                self.robot1, self.renderData1{i, 1}, self.renderData1{i, 2}, ...
                                self.renderData1{i, 3}, self.robot2, self.renderData2{i, 1}, ...
                                self.renderData2{i, 2}, self.renderData2{i, 3} ...
                            );
            end
        end
    end
    
end