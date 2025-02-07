using LinearAlgebra,NLsolve,LaTeXStrings,CairoMakie

include("AFM.jl")

N = 32
figsize = (width = 300,height = 200)
lsr = 1:div(N,2)
lsSt = N/2 .- lsr
lsh = range(0,2,100)
E0s = zeros(length(lsh),length(lsr))
Sts = zeros(length(lsh),length(lsr))
for (ir,r) in enumerate(lsr)
    Is = getIs(N,r)
    St = N/2 - r
    zs,~ = getzs(N,Is)
    for (ih,h) in enumerate(lsh)
        E0 = (sum(ϵ.(zs))  - h*St) / N
        E0s[ih,ir] = E0
        Sts[ih,ir] = St
    end
end

gsSt = lsSt[[findfirst(x -> x == minimum(E0s[i,:]), E0s[i,:]) for i in eachindex(lsh)]]

fig = Figure()

ax = Axis(fig[1,1];
xlabel = L"h\ /\ J",
ylabel = L"S_T\ /\ N",
title = "GS magnetization",
figsize...)

hm = heatmap!(ax,lsh,lsSt / N,E0s)
Colorbar(fig[1,2],hm)
scatterlines!(ax,0 * ones(length(lsSt)),lsSt / N;color = Makie.wong_colors()[1])
scatterlines!(ax,1 * ones(length(lsSt)),lsSt / N;color = Makie.wong_colors()[2])
scatterlines!(ax,2 * ones(length(lsSt)),lsSt / N;color = Makie.wong_colors()[3])
lines!(ax,lsh,gsSt / N;color = :red,linewidth = 2)

axE = Axis(fig[1,3];
title = "GS energy (h=0)",
ylabel = L"(E-E_F)\ /\ JN",
xlabel = L"S_T\ /\ N",
yticks = 0:-0.2:-1,
height = figsize.height,
width = 180)

scatterlines!(axE,lsSt / N,E0s[1,:];color = Makie.wong_colors()[1],label = L"h/J=0")
scatterlines!(axE,lsSt / N,E0s[div(length(lsh),2),:];color = Makie.wong_colors()[2],label = L"h/J=1")
scatterlines!(axE,lsSt / N,E0s[end,:];color = Makie.wong_colors()[3],label = L"h/J=2")
axislegend(axE,position = :lt)
resize_to_layout!(fig)

display(fig)

save("Heisenberg/figures/AFM-magnetization.png",fig)
save("Heisenberg/figures/AFM-magnetization.pdf",fig)


