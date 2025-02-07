using LinearAlgebra,NLsolve,LaTeXStrings,CairoMakie

include("AFM.jl")

N = 32

I0s = getIs(N)
E0 = sum(ϵ.( getzs(N,I0s)[1]))
E1 = sum(ϵ.( getzs(N,getIs(N,div(N,2)-1))[1]))
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

figsize = (width = 450,height = 200)

fig = Figure()
ax= Axis(fig[1,1];figsize...,
title = "Spinon spectrum, N=$N Heisenberg chain",
xlabel = L"q\ /\ \pi",
ylabel = L"(E-E_A)/J")
#xlims!(ax,0,1)
ylims!(ax,-0.1,pi+0.1)

t = range(0,2,101)
lines!(ax,t,@. abs(sin(pi*t))*pi/2;color = :black)
lines!(ax,t,@. abs(sin(pi*t/2))*pi;color = :black)
scatter!(ax, 1,E1-E0;strokewidth = 2,strokecolor = :red,markersize = 14,label = L"\mathrm{GS\ of}\ r = N/2-1",color = :white)
scatter!(ax,qs / pi,Es;label=L"\mathrm{Triplet},\ (1,1)")
Legend(fig[1,2],ax)
resize_to_layout!(fig)
display(fig)

save("Heisenberg/figures/AFM-spectrum-1,1.png",fig)
save("Heisenberg/figures/AFM-spectrum-1,1.pdf",fig)


