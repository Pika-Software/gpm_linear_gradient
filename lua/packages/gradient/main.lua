if (SERVER) then
    return
end

do

    local mesh_AdvanceVertex = mesh.AdvanceVertex
    local mesh_Position = mesh.Position
    local mesh_Color = mesh.Color
    local mesh_Begin = mesh.Begin
    local mesh_End = mesh.End

    local surface_SetDrawColor = surface.SetDrawColor
    local render_SetMaterial = render.SetMaterial
    local surface_DrawRect = surface.DrawRect

    local table_SortByMember = table.SortByMember
    local math_Clamp = math.Clamp
    local Vector = Vector

    local mat_white = Material("vgui/white")

    function draw.LinearGradient( x, y, w, h, stops, horizontal )
        if (#stops == 0) then
            return
        elseif (#stops == 1) then
            surface_SetDrawColor(stops[1].color)
            surface_DrawRect(x, y, w, h)
            return
        end

        table_SortByMember( stops, "offset", true )
        render_SetMaterial( mat_white )

        -- 7 = MATERIAL_QUADS
        mesh_Begin( 7, #stops - 1 )
        for i = 1, #stops - 1 do
            local offset1 = math_Clamp( stops[i].offset, 0, 1 )
            local offset2 = math_Clamp( stops[i + 1].offset, 0, 1 )
            if (offset1 == offset2) then continue end

            local deltaX1, deltaY1, deltaX2, deltaY2

            local color1 = stops[i].color
            local color2 = stops[i + 1].color

            local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
            local r2, g2, b2, a2
            local r3, g3, b3, a3 = color2.r, color2.g, color2.b, color2.a
            local r4, g4, b4, a4

            if horizontal then
                r2, g2, b2, a2 = r3, g3, b3, a3
                r4, g4, b4, a4 = r1, g1, b1, a1
                deltaX1 = offset1 * w
                deltaY1 = 0
                deltaX2 = offset2 * w
                deltaY2 = h
            else
                r2, g2, b2, a2 = r1, g1, b1, a1
                r4, g4, b4, a4 = r3, g3, b3, a3
                deltaX1 = 0
                deltaY1 = offset1 * h
                deltaX2 = w
                deltaY2 = offset2 * h
            end

            mesh_Color(r1, g1, b1, a1)
            mesh_Position(Vector(x + deltaX1, y + deltaY1))
            mesh_AdvanceVertex()

            mesh_Color(r2, g2, b2, a2)
            mesh_Position(Vector(x + deltaX2, y + deltaY1))
            mesh_AdvanceVertex()

            mesh_Color(r3, g3, b3, a3)
            mesh_Position(Vector(x + deltaX2, y + deltaY2))
            mesh_AdvanceVertex()

            mesh_Color(r4, g4, b4, a4)
            mesh_Position(Vector(x + deltaX1, y + deltaY2))
            mesh_AdvanceVertex()
        end

        mesh_End()
    end
end

do
    local draw_LinearGradient = draw.LinearGradient
    function draw.SimpleLinearGradient( x, y, w, h, startColor, endColor, horizontal )
        draw_LinearGradient(x, y, w, h, {
            {offset = 0, color = startColor},
            {offset = 1, color = endColor}
        }, horizontal)
    end
end