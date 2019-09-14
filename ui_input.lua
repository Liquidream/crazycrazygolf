
ui = castle.ui

function uiRow(id, ...)
  local nArgs = select('#', ...)
  local args = { ... }
  ui.box(id, { flexDirection = 'row', alignItems = 'center' }, function()
      for i = 1, nArgs do
          ui.box(tostring(i), { flex = 1 }, args[i])
          if i < nArgs then
              ui.box('space', { width = 20 }, function() end)
          end
      end
  end)
end

function uiSpacer()
  ui.box('spacer', { height = 40 }, function() end)
end


-- All the UI-related code is just in this function. Everything below it is normal game code!

-- UI-bound/global vars
uiEditorMode = false


function castle.uiupdate()

  
  --ui.markdown('![](assets/title-text.png)')   
  ui.markdown([[
## CrAzY CrAzY Golf
The craziest crazy golf! 🤪
  ]])


  --log("in gameMode = "..gameMode)

  ui.tabs('main', { selected = gameMode }, function()
    uiPlayMode = ui.tab('⛳ Play Mode', function()
      -- ================================================
      -- ==  PLAY MODE
      -- ================================================

      if ui.button('Restart Hole', {  }) then
          -- reset/restart hole 
          -- TODO: Disable in multiplayer?          
          restartHole()
      end

    end)
    uiEditorMode = ui.tab('🎨 Editor Mode', function()
      -- ================================================
      -- ==  EDITOR MODE
      -- ================================================
      ui.markdown([[### Course Editor]])

      
      --log("currTool = "..currTool)

      --ui.scrollBox("editScroll", {}, function() 
        local inOpen = 1 == currTool
        local outOpen = ui.section("🌄 Terrain Landscape", { open = inOpen  }, function()
          ui.markdown([[Choose Terrain to paint:]])
          
          --ui.box("terrain2Box", { border=currTerrainLayer==3 and "5px solid #ff00fd" or "", flexGrow=1 }, function()
          local label = 'Sand Trap'
          if currTerrainLayer==3 then label = "▶ "..label end          
          if ui.button(label, { icon = 'assets/ico-terrain-sand.png', iconOnly = false }) then
            log('set tool to sand')
            currTerrainLayer = 3
          end
            
          local label = 'Fairway/Green'
          if currTerrainLayer==2 then label = "▶ "..label end          
          if ui.button(label, { icon = 'assets/ico-terrain-green.png', iconOnly = false }) then
            log('set tool to grass')
            currTerrainLayer = 2
          end

          local label = 'Rough'
          if currTerrainLayer==1 then label = "▶ "..label end        
          if ui.button(label, { icon = 'assets/ico-terrain-rough.png', iconOnly = false }) then
            log('set tool to rough')
            currTerrainLayer = 1
          end
          
          -- Size
          terrainBrushSize = ui.slider("Size", terrainBrushSize, 1, 50, { })
          
        end) -- terrain painter section
        --log("Terrain: > inOpen = "..tostring(inOpen).." | outOpen = "..tostring(outOpen))
        if outOpen and not inOpen then
          currTool = 1  -- Terrain "painting" mode
        end
        
        local inOpen = 2 == currTool
        local outOpen = ui.section("🧱 Objects / Obstacles", {open = inOpen }, function()
          ui.markdown([[Select objects to create/edit:]])
          
        -- if ui.button('Tee/Start', { icon = 'assets/ico-start.png', iconOnly = false }) then
        --   log('set tool to PLAYER START')
        --   selectedObj = playerStart
        -- end
        
        -- if ui.button('Hole', { icon = 'assets/ico-hole.png', iconOnly = false }) then
        --   log('set tool to HOLE')
        -- end
        
        if ui.button('Wall', { icon = 'assets/ico-wall.png', iconOnly = false }) then
          log('create new WALL')
          local wall = Wall(GAME_WIDTH/2, GAME_HEIGHT/2)
          table.insert(obstacles, wall)
          selectedObj = wall
        end
        
        if ui.button('Bridge', { icon = 'assets/ico-bridge.png', iconOnly = false }) then
          log('set tool to WALL')
        end
          
          
        -- 
        -- PROPERTIES?
        -- 
        if selectedObj then
          ui.section(selectedObj.name.." Properties", { defaultOpen = true }, function()          
            if selectedObj.uiProperties then
              -- draw this object's properties
              selectedObj:uiProperties()
            else
              ui.markdown([[#### No properties]])
            end
          end) 
        end
        
      end) -- obstacles/objects section
      --log("Object: > inOpen = "..tostring(inOpen).." | outOpen = "..tostring(outOpen))
      if outOpen and not inOpen then
        currTool = 2 -- Object mode (cursor/select objects)
      end


      
      ui.section("Main Menu", { defaultOpen = true }, function()
          
        if ui.button('Save Course') then
          -- TODO: save course to Castle storage
            saveCourse()
          end
          
          if DEBUG_MODE then
            if ui.button('Export Course') then
              -- TODO: export course to local storage (disk)
              exportCourse()
            end
              if ui.button('Import Course') then
                -- TODO: export course to local storage (disk)
                importCourse()
              end
            end
            
          if ui.button('Share Course') then
            -- TODO: share course to via Castle post
            --shareCourse()
          end
          
          if ui.button('Load Course') then
            -- TODO: load course to Castle storage
            loadCourse()
          end
          
          if ui.button('Clear Course') then
              -- TODO: reset current course data
              clearCourse()
          end
          
        end) -- obstacles/objects section
        

        lastTool = currTool

    --  end) --scrollbox

    end)  -- editor tab
    
  end) -- tab control



  -- uiEditorMode = ui.toggle("Editor OFF", "Editor ON", uiEditorMode, {onToggle = function(value)
  --   log("uiEditorMode = "..tostring(value))
  --   if value then
  --     -- todo: init editor?
  --   else
      
  --   end
  -- end})

  --log("out gameMode1 = "..gameMode)
  --log("out uiEditorMode = "..tostring(uiEditorMode))

  -- set the game mode
  gameMode = uiEditorMode and GAME_MODE.EDITOR or GAME_MODE.GAME

  --log("out gameMode3 = "..gameMode)

  -- changed since last frame
  if gameMode == GAME_MODE.GAME 
   and gameMode ~= lastGameMode
  then
    -- just switched to game, so refresh level data
    -- TODO: refresh game data?
    scan_surface("courseCanvas")
  end

  lastGameMode = gameMode
end
