using LinearAlgebra,NLsolve,LaTeXStrings,CairoMakie

include("AFM.jl")

N = 32

I0s = getIs(N)
E0 = sum(ϵ.( getzs(N,I0s)[1]))

qs = []
Es = []

for i in 1:div(N,2)+1, j in i+1:div(N,2)+1
    Is = collect(-div(N,4):div(N,4))
    spinon_Is = Is[[i,j]]
    deleteat!(Is,[i,j])
    q = 2pi*(sum(Is) - sum(I0s))/N + pi
    zs,~ = getzs(N,Is)
    E = sum(ϵ.(zs))
    push!(Es,E - E0)
    push!(qs,q)
end

figsize = (width = 400,height = 200)

fig = Figure()
ax= Axis(fig[1,1];figsize...,
title = "Triplet Spinon spectrum, N=$N Heisenberg chain",
xlabel = L"q\ /\ \pi",
ylabel = L"(E-E_A)/JN")

ylims!(ax,-0.1,pi+0.1)

t = range(0,2,101)
lines!(ax,t,@. abs(sin(pi*t))*pi/2;color = :black)
lines!(ax,t,@. abs(sin(pi*t/2))*pi;color = :black)

scatter!(ax,qs / pi,Es)

resize_to_layout!(fig)
display(fig)

save("Heisenberg/figures/AFM-spectrum-1,1.png",fig)
save("Heisenberg/figures/AFM-spectrum-1,1.pdf",fig)


