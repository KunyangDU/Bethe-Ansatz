
function f0!(F, x; λ1, λ2 ,N)
    k1 = (2pi*λ1 + x[1]) / N 
    k2 = (2pi*λ2 - x[1]) / N 
    F[1] = 2*cot(x[1]/2) - cot(k1/2) + cot(k2/2)
end

function f03!(F, x; λ1, λ2 ,N)
    k = 2pi * (λ1 + λ2) / N 
    ϕ = pi * (λ1 - λ2)
    F[1] = cos(k/2)*sinh(N*x[1]) - sinh((N-1)*x[1]) - cos(ϕ)*sinh(x[1])
end




