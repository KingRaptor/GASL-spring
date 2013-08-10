--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
   return {
      name      = "No Draw Stuff",
      desc      = "Things",
      author    = "KingRaptor (L.J. Lim)",
      date      = "2013.04.23",
      license   = "Public Domain",
      layer     = 0,
      enabled   = false
   }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if gadgetHandler:IsSyncedCode() then
   return
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:Initialize()
   Spring.SetDrawWater(false)
   Spring.SetDrawGround(false)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------