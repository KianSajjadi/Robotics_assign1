classdef Brick < handle
	properties
		faces;
		points;
		data;
		numPoints;
		brick_h;
        pos;
	end

	methods
		function self = Brick(startTr)
            if nargin > 0
                self.pos = transl(startTr);
                [faces, points, data] = getPolyData(self);
                self.faces = faces;
                self.points = points;
                self.data = data;
                numPoints = size(points);
                self.numPoints = numPoints(1);
                self.brick_h = self.initBrick(faces, points);
                self.updatePos(startTr);                
                drawnow();
            end
        end
		
		function [faces, points, data] = getPolyData(~)
			[faces, points, data] = plyread("brick.ply", "tri");
		end

		function brick_h = initBrick(~, faces, points)
			hold on
			brick_h = trisurf(faces, points(:, 1), points(:, 2), points(:, 3), "LineStyle", "none", 'Facecolor', [0.55 0.27 0.07]);
			hold off
		end
		
		function updatePos(self, brickTr)
			for i = 1:self.numPoints
				self.brick_h.Vertices(i, :) = transl(brickTr * transl(self.points(i, :)))';
			end
		end
		
	end
end