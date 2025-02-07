using LinearAlgebra,NLsolve,LaTeXStrings,CairoMakie

include("AFM.jl")

for N in [16,64,256,1024]
    t0 = time()
    Is = getIs(N)
    zs,nmax = getzs(N,Is)
    E0 = sum(ϵ.(zs)) / N
    println("N = $N  \tE0 = $(E0)\tn_max = $(nmax)\tCPU-time = $(round(time()-t0;digits=4))s")
end



