function [contour, values] = contourform(image)

    if(ndims(image)>2)
        image=reshape(image,size(image,2),size(image,3))';
    end

    s = size(image);
    [x y] = meshgrid(1:s(2),1:s(1));
    contour = [x(:)';y(:)'];
    values = image(:);
end