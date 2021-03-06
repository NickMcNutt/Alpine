function section{T<:AbstractFloat}(x::T, b::T, n::Int)
    fld(n * (x + b/2), b)
end

function density{T<:AbstractFloat}(file_out::IO, C::AbstractMatrix{T}, n::Int, bw::T = zero(Float64))
    num_atoms = size(C, 2)

    b::T = 2 * maxabs(C)
    println(b)

    if (bw != zero(T))
        bw < b && error("Your box specification is not big enough to contain all atoms.")

        b = bw
    else
        b *= (1 + 1/n)
    end

    println(file_out, "density")
    println(file_out, "$b   "^3, "90.00000   "^3)
    println(file_out, "$n   "^3)

    indices, counts = Int[], Int[]
    @inbounds for i in 1:num_atoms
        xs = section(C[1, i], b, n)
        ys = section(C[2, i], b, n)
        zs = section(C[3, i], b, n)
        index = zs + n*ys + n*n*xs + 1
        push!(indices, index)
        push!(counts, 1)
    end
    ρ = sparsevec(indices, counts)
    full_ρ = full(ρ)

    remaining_zeros = n^3 - length(full_ρ)

    print_joined(file_out, full_ρ, '\n')
    println(file_out, "\n0" ^ remaining_zeros)
end

function density2{T<:AbstractFloat}(file_out::IO, C::AbstractMatrix{T}, n::Int, bw::T = zero(Float64))
    num_atoms = size(C, 2)

    b::T = 2 * maxabs(C)
    println(b)

    if (bw != zero(T))
        bw < b && error("Your box specification is not big enough to contain all atoms.")

        b = bw
    else
        b *= (1 + 1/n)
    end

    println(file_out, "density")
    println(file_out, "$b   "^3, "90.00000   "^3)
    println(file_out, "$n   "^3)

    indices, counts = Int[], Int[]
    @inbounds for i in 1:num_atoms
        xs = section(C[1, i], b, n)
        ys = section(C[2, i], b, n)
        zs = section(C[3, i], b, n)
        index = zs + n*ys + n*n*xs + 1
        push!(indices, index)
        push!(counts, 1)
    end
    ρ = sparsevec(indices, counts)
    full_ρ = full(ρ)

    remaining_zeros = n^3 - length(full_ρ)

    print_joined(file_out, full_ρ, '\n')
    println(file_out, "\n0" ^ remaining_zeros)
end
