function scalarTo3D(s, a)
    return { s*a[3], s*a[7], s*a[11] }
end

function rotate(x, y, theta)
    return { math.cos(theta) * x + math.sin(theta) * y, -math.sin(theta) * x + math.cos(theta) * y }
end