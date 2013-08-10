--------------------------------------------------------------------------------
--
--  Proposed Command ID Ranges:
--
--    all negative:  Engine (build commands)
--       0 -   999:  Engine
--    1000 -  9999:  Group AI
--   10000 - 19999:  LuaUI
--   20000 - 29999:  LuaCob
--   30000 - 39999:  LuaRules
--

-- if you add a command, please order it by ID!

CMD_RETREAT =	10000
CMD_RETREAT_ZONE = 10001
CMD_SETHAVEN = CMD_RETREAT_ZONE
CMD_RESETFIRE = 10003
CMD_RESETMOVE = 10004

CMD_MORPH = 31210
CMD_STEALTH = 32100
CMD_CLOAK_SHIELD = 32101
CMD_MINE = 32105	-- easymetal2
CMD_REARM = 32768	-- bomber control
CMD_FIND_PAD = 32769	-- bomber control
CMD_SET_ATTACK_SPEED = 33000
CMD_UNIT_SET_TARGET = 34923 -- unit_target_on_the_move
CMD_UNIT_CANCEL_TARGET = 34924
CMD_UNIT_SET_TARGET_CIRCLE = 34925
CMD_ONECLICK_WEAPON = 35000
CMD_UNIT_AI = 36214
CMD_JUMP = 38521
CMD_TURN = 38530