# uncomment and run the following once to install
import Pkg; Pkg.add([
    "GAP",              # for group theory
    "Images","Colors", "FileIO"
    ])

# using Pkg; Pkg.add("GAP")
using GAP, Images, Colors, FileIO

# the following code inputs a matrix and outputs a grid of pixels of distinct colors
function matrix_to_image(matrix; cell_size::Int=20)
    unique_vals = sort(collect(Set(matrix)))
    n = length(unique_vals)

    # Assign a unique color to each matrix value
    color_map = Dict(val => distinguishable_colors(n)[i] for (i, val) in enumerate(unique_vals))

    # Create a low-res color matrix from the original matrix
    color_matrix = [color_map[val] for val in matrix]
    color_matrix = reshape(color_matrix, size(matrix))

    # Blow up each cell into a block of size cell_size × cell_size
    img_height, img_width = size(color_matrix)
    full_img = Array{RGB{N0f8}}(undef, img_height * cell_size, img_width * cell_size)

    for i in 1:img_height
        for j in 1:img_width
            color = color_matrix[i, j]
            y_range = (cell_size*(i-1)+1):(cell_size*i)
            x_range = (cell_size*(j-1)+1):(cell_size*j)
            full_img[y_range, x_range] .= color
        end
    end

    return colorview(RGB, permutedims(full_img, (2, 1)))  # Transpose for correct orientation
end

#####################

# Plug in your favorite group here and extract its multiplication table

longname = "SymmetricGroup(3)"
shortname = "S3"

function gap_group_to_img(longname,shortname)
    gpname = string("G:=",longname,";")
    print(gpname)
    GAP.evalstr(gpname)
    GAP.evalstr("n:= Order(G);")
    gap_matx = GAP.evalstr("M:= MultiplicationTable(G);")

    # Convert the multiplication table (which is a GAP object) to Julia:
    #   more about GAP -> Julia conversion here: https://oscar-system.github.io/GAP.jl/dev/conversion/
    julia_matx = Matrix{Int64}(gap_matx)

    # # Create an image out of the matrix // change the cell_size in order to scale the image to a new resolution
    img_file = matrix_to_image(julia_matx,cell_size=40)
    println("Saving image to: ", pwd())
    img_filename = string(shortname,".png")
    save(img_filename, img_file)
end

groups_to_build_cayley_tables_for = [
    ["CyclicGroup(2)","C2"],
    ["CyclicGroup(3)","C3"],
    ["CyclicGroup(4)","C4"],
    ["SmallGroup(4,2)","K4"],       # Klein 4-group by GAP ID
    ["SymmetricGroup(3)","S3"],
    ["SymmetricGroup(4)","S4"],
]

for g in groups_to_build_cayley_tables_for
    gap_group_to_img(g[1],g[2])
end