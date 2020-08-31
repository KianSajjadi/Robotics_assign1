%% createProp
%function that reads a polygon file and renders a static prop using the
%vertices and the location at which the prop will be
function prop_h = createProp(propName, locationTr, colour)
    [faces, points, data] = plyread(propName, "tri");
	hold on
	prop_h = trisurf(faces, points(:, 1), points(:,2), points(:,3), "LineStyle", "none", "Facecolor", colour);
	hold off 
	numPoints = size(points);
	self.numPoints = numPoints(1);
	for i = 1:self.numPoints
		prop_h.Vertices(i, :) = transl(locationTr * transl(points(i, :)))';
	end
end