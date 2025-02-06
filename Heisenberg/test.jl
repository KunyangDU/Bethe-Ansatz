using CairoMakie
function f0!(x;λ1,λ2,N)
    k1 = (2pi*λ1 + x) / N 
    k2 = (2pi*λ2 - x) / N 
    return 2*cot(x/2) - cot(k1/2) + cot(k2/2)
end


params = (
N = 100,
λ1 = 0,
λ2 = 3,
)

θ = range(-0.00001,0.00001,200)
sol = @. f0!(θ;params...)


fig = Figure()
ax= Axis(fig[1,1])
lines!(ax,θ,sol)

display(fig)



