using LinearAlgebra,NLsolve,LaTeXStrings,CairoMakie


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


#= 
记录k1 k2，计算k和色散关系，查看、theta和λ1 λ2分布图
=#

N = 32

figsize = (width = 450,height = 300)
fig = Figure()
axE = Axis(fig[1,1];figsize...,
title = "FM Heisenberg chain (Bethe Ansatz), N = $N",
xlabel = L"k/2\pi",
xticks = 0:0.1:0.5,
ylabel = L"(E-E_0)\ /\ J")
xlims!(axE, -0.01, 0.51)

ksC2 = []
EsC2 = []
#θs = zeros(N,N)

for (i2,λ2) in enumerate(0:N-1),(i1,λ1) in enumerate(0:λ2-2)
    params = (
        N = N,
        λ1 = λ1,
        λ2 = λ2,
    )

    f!(F,x) = f0!(F,x;params...)

    sol = nlsolve(f!,[0.1])
    θ = mod(sol.zero[1]/2pi,1)*2pi
    #θs[i1,i2] = θ
    k1 = (2pi*λ1 + θ) / N 
    k2 = (2pi*λ2 - θ) / N 
    k = mod((k1 + k2 + 1e-3)/2pi,1)*2pi - 1e-3
    E = 2 - cos(k1) - cos(k2)
    push!(ksC2,k)
    push!(EsC2,E)
end

scatter!(axE,ksC2 / 2pi,EsC2;markersize = 6,color = :white,strokecolor = :black,strokewidth = 1,label = L"C_2,\ \Delta \lambda \geq 2")


ksfree = []
Esfree = []

for λ1 in 0:N-1, λ2 in 0:N-1
    push!(ksfree,mod((λ1 + λ2) / N ,1)* 2pi)
    push!(Esfree,2 - cos(λ1 * 2pi / N) - cos(λ2 * 2pi / N) )
end

scatter!(axE,ksfree / 2pi,Esfree;markersize = 6,marker = :+,color = :black,label = L"\mathrm{Free\ magnons}")

ksC1 = []
EsC1 = []
for λ2 in 0:N-1
    params = (
        N = N,
        λ1 = 0,
        λ2 = λ2,
    )

    f!(F,x) = f0!(F,x;params...)

    sol = nlsolve(f!,[0.1])
    θ = mod(sol.zero[1]/2pi,1)*2pi
    k1 = (2pi*0 + θ) / N 
    k2 = (2pi*λ2 - θ) / N 
    k = k1 + k2
    E = 2 - cos(k1) - cos(k2)
    push!(ksC1,k)
    push!(EsC1,E)
end

scatter!(axE,ksC1 / 2pi,EsC1;markersize = 8,color = :red,label = L"C_1,\ \lambda_1=0")

ksC30 = []
EsC30 = []
vsC30 = []
for λ2 in 0:N-1
    params = (
        N = N,
        λ1 = λ2,
        λ2 = λ2,
    )

    f!(F,x) = f03!(F,x;params...)

    sol = nlsolve(f!,[5.])
    #@assert sol.x_converged || sol.f_converged
    v = sol.zero[1]
    k = (mod((params.λ1 + params.λ2)/N + 1e-3,1) - 1e-3)*2pi
    push!(vsC30, v)
    push!(ksC30, k)
    push!(EsC30, 2*(1- cos(k/2)*cosh(v)))
end

ind = findall(x -> x > 1e-5, vsC30)

vsC30r = vsC30[ind]
ksC30r = ksC30[ind]
EsC30r = EsC30[ind]

scatter!(axE,ksC30r / 2pi,EsC30r;markersize = 8,marker = :rect,color=:blue,label = L"C_3,\ \Delta \lambda=0")

ksC31 = []
EsC31 = []
vsC31 = []
for λ2 in 0:N-1
    params = (
        N = N,
        λ1 = λ2-1,
        λ2 = λ2,
    )

    f!(F,x) = f03!(F,x;params...)

    sol = nlsolve(f!,[5.,])
    v = sol.zero[1]
    k = (mod((params.λ1 + params.λ2)/N + 1e-3,1) - 1e-3)*2pi
    push!(vsC31, v)
    push!(ksC31, k)
    push!(EsC31, 2*(1-cos(k/2)*cosh(v)))
end

ind = findall(x -> x > 1e-5, vsC31)

vsC31r = vsC31[ind]
ksC31r = ksC31[ind]
EsC31r = EsC31[ind]

scatter!(axE,ksC31r / 2pi,EsC31r;markersize = 8,marker = :diamond,color=:blue,label = L"C_3,\ \Delta \lambda=1")

leg = Legend(fig[1, 2], axE)

resize_to_layout!(fig)
display(fig)

save("Heisenberg/figures/FM spectrum_N=$(N).png",fig)
save("Heisenberg/figures/FM spectrum_N=$(N).pdf",fig)



