import Pkg; Pkg.add(["ColorSchemes","Measures"])
using Plots, ColorSchemes, FileIO, Images, Measures; gr()

# Solve for the parameter spanning the pencil in terms of the function, on the affine chart z=1
f(x, y) = (x^4+y^4+1)/(x^2+y^2 + x^2 * y^2)

# Fix the width of the plot -- here we're graphing in the square [-4,4]x[-4,4]
width_of_plot = 8

x = range(-width_of_plot/2, width_of_plot/2, length=100)
y = range(-width_of_plot/2, width_of_plot/2, length=100)

z = @. f(x', y) # this is a bit strange, the prime ' is a tranposition of the vector x, needed here for some reason that's a bit unclear to me

octahedral_pencil = Plots.contour(x, y, z, 
    levels = 0:0.5:5,           # let z range from 0 to 5 with a 0.5 step size
    fill = true,                # fill the regions between the contours
    c = :picasso,               # color range
    cbar=false,                 # no color bar
    aspect_ratio = :equal,      # equal aspect ratio
    framestyle = :none,         # trim whitespace
    left_margin = 0mm, right_margin = 0mm, top_margin = 0mm, bottom_margin = 0mm  # updated margin
    )

println("Saving image to: ", pwd())
png(octahedral_pencil,"octahedral_pencil.png")

###################################
# Now let's make a gif!

println("Creating animated gif...")
anim = @animate for t in vcat(0.1:0.1:5, reverse(0.1:0.1:5))
    f_t(x, y) = (x^4 + y^4 + 1) / (x^2 + y^2 + x^2 * y^2)-t
    z_t = [f_t(xi, yi) for xi in x, yi in y]
    z0 = 1.0
    println("t = $t | plotting f_t(x,y) = $z0")
    contour(x, y, z_t,
        levels = [z0],
        fill = false,
        c = :black,
        cbar = false,
        aspect_ratio = :equal,
        framestyle = :none,
        left_margin = 0mm, right_margin = 0mm, top_margin = 0mm, bottom_margin = 0mm
    )
end

gif(anim, "octahedral_pencil.gif", fps = 20)