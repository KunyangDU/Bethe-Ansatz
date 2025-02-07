using LinearAlgebra,NLsolve

function ϕ(x)
    return 2*atan(x)    
end

function ϵ(x)
    return -2/(1+x^2)
end

function getIs(N,r = N/2)
    St = N/2 - r
    return [(St - 1 + 2*i - N/2)/2 for i in 1:r]
end

function f0(zs0::Vector;Is,N)
    r = length(zs0)
    zs = 0 * zs0
   
    for i in 1:r
        Z = 0
        for j in 1:r 
            i == j && continue 
            Z += ϕ((zs0[i]-zs0[j]) / 2)
            zs[i] = tan(pi * Is[i] / N + Z/2/N)  
        end
    end
    return zs
end

function getzs(N, Is;iterN = 10000,tol = 1e-16)
    return let 
        z0 = zeros(length(Is))
        nmax = 0
        for i in 1:iterN
            zs = f0(z0;Is=Is,N=N)
            err = sum(abs.(z0 .- zs)) / sum(abs.(z0 .+ zs))
            z0 = zs
            if err < tol 
                nmax = i
                break
            elseif i == iterN && err > tol 
                println("not converged with error = $(err)")
                nmax = i
            end
        end
        z0,nmax
    end
end



