function d =  euclidianDist(A,B)
    delta = A - B;
    d = sqrt(delta*delta');
end