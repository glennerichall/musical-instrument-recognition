function moments = hu_moments(contours,values)
   
    if(isempty(contours))
        moments = [NaN, NaN, NaN, NaN, NaN, NaN, NaN];
        return;
    end

    if(iscell(contours))
        xy=[contours{:}];
        if(nargin==2)    
            values = values-min(values)+1;
            values = values/max(values);
            I = cellfun(@length,contours);
            I = arrayfun(@(n) ones (1,n), I, 'uniformoutput',false);
            for i=1:length(I)
                I{i} = I{i}*values(i);
            end
            I = [I{:}]';
        end        
    else
        xy = contours;
        if(nargin==2)    
            I = values;
        end         
    end
    

    

    
    [M,N]=size(xy); 
    
    if(M==2)
        xy = xy';
    end

    x=xy(:,1); 
    y=xy(:,2); 
        
    if(nargin==2)
         m = @(p,q) sum(x.^p.*y.^q.*I);
    else
         m = @(p,q) sum(x.^p.*y.^q);
    end
    
    m00=m(0,0);
    if(m00==0) 
        m00=eps; 
    end   
    m10 = m(1,0);
    m01 = m(0,1);

    xbar = m10/m00; 
    ybar = m01/m00; 
    
    if(nargin==2)
        mu = @(p,q) sum((x-xbar).^p.*(y-ybar).^q.*I);
    else
        mu = @(p,q) sum((x-xbar).^p.*(y-ybar).^q);
    end
    
    mu00 = mu(0,0);
    n = @(p,q) mu(p,q)/ mu00^(1+(p+q)/2);
    
    n20 = n(2,0);
    n02 = n(0,2);
    n11 = n(1,1);
    n21 = n(2,1);
    n12 = n(1,2);
    n03 = n(0,3);
    n30 = n(3,0);
    
    phi(1) = n20 + n02;
    
    phi(2) = (n20-n02)^2 + (2*n11)^2;
    
    phi(3) = (n30-3*n12)^2 + (3*n21-n03)^2;
    
    phi(4) = (n30+n12)^2 + (n21+n03)^2;
    
    phi(5) = (n30-3*n12)*(n30+n12)*( (n30+n12)^2-3*(n21+n03)^2 )+ ...
             (3*n21-n03)*(n21+n03)*( 3*(n30+n12)^2-(n21+n03)^2 );
         
    phi(6) = (n20-n02)*( (n30+n12)^2-(n21+n03)^2 ) + ...
             4*n11*(n30+n12)*(n21+n03);
         
    phi(7) = (3*n21-n03)*(n30+n12)*( (n30+n12)^2-3*(n21+n03)^2 )- ...
             (n30-3*n12)*(n21+n03)*( 3*(n30+n12)^2-(n21+n03)^2 );
   
         

%     mu20 = mu(2,0);
%     mu02 = mu(0,2);
%     mu11 = mu(1,1);
%     mu21 = mu(2,1);
%     mu12 = mu(1,2);
%     mu03 = mu(0,3);
%     mu30 = mu(3,0);
%     
%     
%     phi(1) = mu20 + mu02;
%     phi(1) = phi(1)/mu00^2;
%     
%     
%     
%     phi(2) = (mu20-mu02)^2 + (2*mu11)^2;
%     phi(2) = phi(2)/mu00^4;
%     
%     
%     
%     phi(3) = (mu30-3*mu12)^2 + (3*mu21-mu03)^2;
%     phi(3) = phi(3)/mu00^5;
%     
%     
%     
%     phi(4) = (mu30+mu12)^2 + (mu21+mu03)^2;
%     phi(4) = phi(4)/mu00^5;
%     
%     
%     
%     phi(5) = (mu30-3*mu12)*(mu30+mu12)*( (mu30+mu12)^2-3*(mu21+mu03)^2 )- ...
%              (3*mu21-mu03)*(mu21+mu03)*( (mu21+mu03)^2-3*(mu03+mu12)^2 );
%     phi(5) = phi(5)/mu00^10;
%     
%     
%     
%     phi(6) = (mu20-mu02)*( (mu30+mu12)^2-(mu21+mu03)^2 ) - ...
%              4*mu11*(mu30+mu12)*(mu21+mu03);    
%     phi(6) = phi(6)/mu00^7;
%     
%     
%     
%     phi(7) = (3*mu21-mu03)*(mu30+mu12)*( (mu30+mu12)^2-3*(mu21+mu03)^2 )- ...
%              (mu30-mu12)*(mu21+mu03)*( 3*(mu30+mu12)^2-(mu21+mu03)^2 );
%     phi(7) = phi(7)/mu00^10;    
        
    moments = phi;

end

