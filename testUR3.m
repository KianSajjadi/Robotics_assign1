%%
clc
clf
UR3_base_1 = transl(0, 0, 0);
UR3_base_2 = transl(0, 0, 0);
robot = UR3(UR3_base_1);
%robot_2 = UR3(UR3_base_2);
robot.model.teach()

