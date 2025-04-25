--#region! ================================================ PRINT
--print("LOCAL Move ID: ", getLocalOldMethodMoveID())
--print("OPP Move ID: ", getOpponentOldMethodMoveID())
--print("LOCAL Prev Move ID: ", getLocalOldMethodLastMoveID())
--print("OppStun State: ", getOpponentStunnedStateBeta())
--print("Combo Count: ", getLocalComboCounter())
--print(getOpponentIsBeingCounterPunish())
--print(getOpponentDistance())
--print(getOpponentAnimationID())
--print(getLocalStockInteger())
--print(getOpponentTotalFrames())
--print(getOpponentMoveTimer())
--print(getOpponentStartUpEndFrame())

--#region input fix
if DetectIsKeyPressed(0x08)
then
EnableGameInput()
RDown()
RUp()
RToward()
RBack()
RLight()
RMedium()
RHeavy()
RSpecial()
RAssist()
ReleaseInputModernSpecialMove()
RParry()
end
--#endregion

--#region Print Stats
if DetectIsKeyPressed(0x30)
then
print("Distance: ", getOpponentDistance())
print("OPP Move ID: ", getOpponentOldMethodMoveID())
OS(2000)
end
--#endregion

--#endregion! ============================================= PRINT

--#region! ================================================ BASE FUNCTIONS 

--#region Probability
ACTION_PROBABILITY = 40  -- Set this between 0 and 100

function PROBABILITY()
    return math.random(100) <= ACTION_PROBABILITY
end
--#endregion

--#region Drive Impact (DI) Animations - Format {AnimationID, isKickDI} 
DI_AnimationIDS = {
    [1]  = {110, 854, false},  -- Ryu (MoveID 110, AnimationID 854, Not a Kick DI)
    [2]  = {118, 855, false},  -- Luke
    [3]  = {140, nil, false},  -- Kim
    [4]  = {178, nil, false},  -- Chun-Li
    [5]  = {139, nil, false},  -- Manon
    [6]  = {124, 854, false},  -- Zangief
    [7]  = {101, 855, false},  -- JP
    [8]  = {152, 854, false},  -- Dhalsim
    [9]  = {134, nil, false},  -- Cammy 
    [10] = {136, 855, false},  -- Ken
    [11] = {106, nil, false},  -- Dee Jay
    [12] = {110, 855, false},  -- Lily
    [13] = {101, 855, false},  -- Aki
    [14] = {102, nil, false},  -- Rashid
    [15] = {167, nil, false},  -- Blanka
    [16] = {118, nil, false},  -- Juri
    [17] = {161, 855, false},  -- Marisa
    [18] = {128, nil, false},  -- Guile
    [19] = {119, 855, false},  -- Ed
    [20] = {127, 855, false},  -- Honda
    [21] = {157, 858, false},  -- Jamie
    [21] = {157, 860, false},  -- Jamie
    [22] = {115, 854, false},  -- Akuma
    [26] = {nil, nil, false},  -- Bison
    [27] = {nil, nil, false},  -- Terry
    [28] = {nil, nil, false},  -- Mai
    [29] = {nil, nil, false},  -- Elena
    [30] = {55, 858, false},   -- Jamie Avatar
    [31] = {47, 855, false},   -- Luke Avatar
    [32] = {38, 855, false},   -- Manon Avatar
    [33] = {46, 855, false},   -- Kim/Ken  Avatar
    [34] = {49, 855, false},   -- Marisa Avatar
    [35] = {44, 855, false},   -- Lily/Cammy/Aki Avatar
    [36] = {45, 855, false},   -- JP/Terry Avatar
    [37] = {40, 855, false},   -- Juri Avatar
    [38] = {54, 855, false},   -- Dee Jay Avatar
    [39] = {47, 854, false},   -- Ryu/Dhalsim Avatar
    [40] = {37, 855, false},   -- Honda/Blanka Avatar
    [41] = {87, 855, false},   -- Guile Avatar
    [42] = {96, 854, false},   -- Chun-Li Avatar
    [43] = {45, 854, false},   -- Zangief Avatar
    [44] = {59, 855, false},   -- Rashid Avatar
    [45] = {61, 855, false},   -- Ed Avatar
    [46] = {44, 854, false},   -- Akuma Avatar
    [47] = {43, 855, false},   -- Bison Avatar
    [48] = {52, 854, false},   -- Mai Avatar
            }
--#endregion

--#region Check if Doing DI
function isOpponentAnimationDI()
    local opponentAnimation = getOpponentAnimationID()
    for _, di in pairs(DI_AnimationIDS) do
    if di[2] ~= nil and di[2] == opponentAnimation then
            return "Yes"
    end
    end
    return "No"
end
--#endregion        

--#region Local Definitions

-- Control Type
Modern  = (GetControlType() == 1)
Classic = (GetControlType() == 0)

-- Button Presses (M)
local PAssist  = PressInputModernAssistButton
local RAssist  = ReleaseInputHardKick
local PSpecial = PressInputModernSpecialMove
local RSpecial = ReleaseInputModernSpecialMove
local PLight   = PressInputModernLightAttack
local RLight   = ReleaseInputModernLightAttack 
local PMedium  = PressInputModernMediumAttack
local RMedium  = ReleaseInputModernMediumAttack
local PHeavy   = PressInputModernHeavyAttack
local RHeavy   = ReleaseInputModernHeavyAttack

-- Button Presses (C)
local PLP      = PressInputLightPunch
local RLP      = ReleaseInputLightPunch
local PMP      = PressInputMediumPunch
local RMP      = ReleaseInputMediumPunch
local PHP      = PressInputHardPunch
local RHP      = ReleaseInputHardPunch
local PLK      = PressInputLightKick
local RLK      = ReleaseInputLightKick
local PMK      = PressInputMediumKick
local RMK      = ReleaseInputMediumKick
local PHK      = PressInputHardKick
local RHK      = ReleaseInputHardKick


-- Button Presses (Both)
local PParry   = PressInputParryButton
local RParry   = ReleaseInputParryButton
local PToward  = PressInputRightButton
local RToward  = ReleaseInputRightButton
local PDown    = PressInputDownButton
local RDown    = ReleaseInputDownButton
local PBack    = PressInputLeftButton
local RBack    = ReleaseInputLeftButton
local PUp      = PressInputUpButton
local RUp      = ReleaseInputUpButton

-- API Calls
local opponentDistance     = getOpponentDistance()
local OpponentAnimationID  = getOpponentAnimationID()
local LocalAnimationID     = getLocalAnimationID()
local OS                   = OwlSleep 
local OSF                  = OwlSleepFrames
local opponentHealth       = getOpponentHealthMeter() 
local opponentID           = getOpponentCharacterID
local opponentAnim         = OpponentAnimationID
local opponentMove         = getOpponentOldMethodMoveID

--#endregion

--#region (local_ready) - Is Local in Ready Animation

local localAnimation = getLocalAnimationID()
local invalidLocalAnimations = {
    [17] = true, [18] = true, [162] = true, [176] = true, [181] = true,
    [232] = true, [480] = true, [481] = true, [482] = true, [483] = true,
    [484] = true, [485] = true, [341] = true, [331] = true, [340] = true,
    [182] = true, [183] = true, [160] = true, [161] = true, [155] = true,
    [153] = true, [163] = true, [174] = true, [175] = true
}
local_ready = not invalidLocalAnimations[localAnimation]

--#endregion

--#region Chance Functions
function chance(percentage)
return math.random(1, 100) <= percentage
end
--#endregion

--#region (isCounterReady) - Is local ready to Counter
function isCounterReady(minDistance, maxDistance)
    local inAir = getLocalInAirByte()
    local distance = getOpponentDistance()

    return getOpponentStunnedStateBeta() == 0
        and getLocalStunnedStateBeta() == 0
        and getLocalOldMethodMoveID() == 0
        and (inAir == 0 or inAir == 1)
        and distance >= minDistance
        and distance <= maxDistance
        -- and getOpponentMoveTimer() == 1
        and local_ready
        and not getOpponentIsProjectileOnScreen()
end
--#endregion

--#region (PunCond) - Checks if a move is Punishable

function PunCond(charID, moveID, startup, minDistance, maxDistance, label)
    if getOpponentCharacterID() == charID
        and getOpponentOldMethodMoveID() == moveID
        and (startup == nil or getOpponentStartUpEndFrame() >= startup)
        and getOpponentDistance() >= minDistance
        and getOpponentDistance() <= maxDistance 
        and getLocalInAirByte() ~= 2
        and getLocalStunnedStateBeta() == 0
        and getOpponentMoveTimer() <= 10
        then

        print(label)
        print("PunCond Distance: ", getOpponentDistance())
        
        return true
    end

    return false
    
end
--#endregion

--#region (Health) - Checks if Opponent health is between a certain value
function Health(min, max)
    local health = getOpponentHealthMeter()
    if health >= min and health < max then
        return true
    else
        return false
    end
end
--#endregion

--#region (Meter) - Checks if Meter is greater than a certain value
function SAMeter(threshold)
    threshold = threshold or 0
    return getLocalSAMeter() >= threshold
end
--#endregion

--#region (Parry) - Presses Parry with delays
function Parry(waitBeforeP, waitBetween, waitAfter)
    DisableGameInput()
    setOpponentOldMethodMoveID(0)
    PDown()
    PBack()
    OS(waitBeforeP)
    RDown()
    PParry()
    OS(waitBetween)
    RBack()
    RParry()
    EnableGameInput()
    setOpponentOldMethodMoveID(0)
    OS(waitAfter)
end
--#endregion

--#region (HitConfirm) - Checks if Move has landed
function HitConfirm(MoveID, Distance, DriveMeter, HitType, Label)
    Distance   = Distance   or 200
    DriveMeter = DriveMeter or 0

    local isCounterHit = getOpponentIsBeingCounterHit()
    local isPunishHit  = getOpponentIsBeingCounterPunish()
    local hitTypeMatch = true

    if HitType == "Counter" then
        hitTypeMatch = isCounterHit
    elseif HitType == "Punish" then
        hitTypeMatch = isPunishHit
    elseif HitType == "Both" then
        hitTypeMatch = isCounterHit or isPunishHit
    elseif HitType == "None" then
        hitTypeMatch = (not isCounterHit and not isPunishHit)
    end

    local condition = getLocalOldMethodMoveID() == MoveID
        and getLocalComboCounter() >= 1
        --and getOpponentStunnedStateBeta() ~= 0 
        and getOpponentInAirByte() ~= 2 
        and getLocalInAirByte() ~= 2
        and getOpponentDistance() <= Distance
        --and getLocalStunnedStateBeta() == 0
        and getLocalDriveMeter() >= DriveMeter
        and isOpponentAnimationDI() == "No"
        and hitTypeMatch

    if condition and Label then
        print("===================================== " .. Label)
        print("Distance: ", getOpponentDistance())
        print("OppAnim: ", getOpponentAnimationID())
    end

    return condition
end
--#endregion

--#region (HitConfirmAirOpp) - Checks if Move has landed
function HitConfirmAirOpp(MoveID, Distance, DriveMeter, HitType, Label)
    Distance   = Distance   or 200
    DriveMeter = DriveMeter or 0

    local isCounterHit = getOpponentIsBeingCounterHit()
    local isPunishHit  = getOpponentIsBeingCounterPunish()
    local hitTypeMatch = true

    if HitType == "Counter" then
        hitTypeMatch = isCounterHit
    elseif HitType == "Punish" then
        hitTypeMatch = isPunishHit
    elseif HitType == "Both" then
        hitTypeMatch = isCounterHit or isPunishHit
    elseif HitType == "None" then
        hitTypeMatch = (not isCounterHit and not isPunishHit)
    end

    local condition = getLocalOldMethodMoveID() == MoveID
        and getOpponentStunnedStateBeta() ~= 0 
        and getOpponentInAirByte() == 2 
        and getLocalInAirByte() ~= 2
        and getOpponentDistance() <= Distance
        and getLocalStunnedStateBeta() == 0
        and getLocalDriveMeter() >= DriveMeter
        and hitTypeMatch

    if condition and Label then
        print("===================================== " .. Label)
    end

    return condition
end
--#endregion

--#region (HitConfirmAirOpp) - Checks if Move has landed
function HitConfirmAirLoc(MoveID, Distance, DriveMeter, HitType, Label)
    Distance   = Distance   or 200
    DriveMeter = DriveMeter or 0

    local isCounterHit = getOpponentIsBeingCounterHit()
    local isPunishHit  = getOpponentIsBeingCounterPunish()
    local hitTypeMatch = true

    if HitType == "Counter" then
        hitTypeMatch = isCounterHit
    elseif HitType == "Punish" then
        hitTypeMatch = isPunishHit
    elseif HitType == "Both" then
        hitTypeMatch = isCounterHit or isPunishHit
    elseif HitType == "None" then
        hitTypeMatch = (not isCounterHit and not isPunishHit)
    end

    local condition = getLocalOldMethodMoveID() == MoveID
        and getOpponentStunnedStateBeta() ~= 0 
        --and getOpponentInAirByte() == 2 
        and getLocalInAirByte() == 2
        and getOpponentDistance() <= Distance
        and getLocalStunnedStateBeta() == 0
        and getLocalDriveMeter() >= DriveMeter
        and hitTypeMatch

    if condition and Label then
        print("===================================== " .. Label)
    end

    return condition
end
--#endregion

--#region (DIHitConfirm)        - Checks if Move has landed into DI
function DIHitConfirm(MoveID, Distance, SAMeter, DriveMeter)
    Distance   = Distance   or 200
    DriveMeter = DriveMeter or 0
    SAMeter = SAMeter or 0

    return  getLocalOldMethodMoveID() == MoveID
    and getOpponentStunnedStateBeta() ~= 0
    and getOpponentDistance() <= Distance
    and getLocalStunnedStateBeta() == 0          
    and getLocalActionFlags() ~= 0
    and getLocalInAirByte() ~= 2             --if we is on the ground
    and getOpponentInAirByte() ~= 2
    and getOpponentInAirByte() ~= 3          -- not knocked down
    and getLocalSAMeter() >= SAMeter
    and getLocalDriveMeter() >= DriveMeter
    and isOpponentAnimationDI() == "Yes"
end
--#endregion

--#region (AAReady) - Checks Can be AA
function AAReady(MinDistance, MaxDistance, AnimID, Label)
    MinDistance = MinDistance or 0
    MaxDistance = MaxDistance or 300
    AnimID = AnimID

    local condition = 
        getOpponentStunnedStateBeta() == 0 
        and getOpponentInAirByte() == 2 
        and getLocalInAirByte() ~= 2
        and getOpponentAnimationID() == AnimID
        and getOpponentDistance() <= MaxDistance
        and getOpponentDistance() >= MinDistance
        and getLocalStunnedStateBeta() == 0
        --and getOpponentMoveTimer()==0 
        --and getLocalAnimationID()<=19 
        and getOpponentIsProjectileOnScreen()==false
        --and (getOpponentAnimationID() == 33 or getOpponentAnimationID() == 34)

    if condition and Label then
        print("===================================== " .. Label)
    end

    return condition
end
--#endregion

--#region (Conditions) - Conditions that must be met.
function Conditions(MinDistance, MaxDistance, DriveMeter, HitType, StunState, Label)
    MinDistance = MinDistance or 0
    MaxDistance = MaxDistance or 300
    DriveMeter  = DriveMeter  or 0

    local stunCheck
    if StunState == nil then
        -- Default: check that opponent stun state is not equal to 0.
        stunCheck = (getOpponentStunnedStateBeta() ~= 0)
    else
        stunCheck = (getOpponentStunnedStateBeta() == StunState)
    end

    local isCounterHit = getOpponentIsBeingCounterHit()
    local isPunishHit  = getOpponentIsBeingCounterPunish()
    local hitTypeMatch

    if HitType == "Counter" then
        hitTypeMatch = isCounterHit
    elseif HitType == "Punish" then
        hitTypeMatch = isPunishHit
    elseif HitType == "Both" then
        hitTypeMatch = isCounterHit or isPunishHit
    elseif HitType == "None" then
        -- If "None" is specified, ensure both are false.
        hitTypeMatch = (not isCounterHit and not isPunishHit)
    else
        hitTypeMatch = true
    end

    local result = stunCheck
           and getOpponentInAirByte() ~= 2 
           and getLocalInAirByte() ~= 2
           and getOpponentDistance() >= MinDistance
           and getOpponentDistance() <= MaxDistance
           and getLocalStunnedStateBeta() == 0
           and getLocalDriveMeter() >= DriveMeter
           and hitTypeMatch

    if result and Label then
        print("*** " .. Label)
    end

    return result
end
--#endregion

--#region (ifStun) - If Opponent is Stunned
function ifStun(action)
    if getOpponentStunnedStateBeta() ~= 0 then
        action()
        return true
    else
        EnableGameInput()
        EnableGameInput()
        RDown()
        RUp()
        RToward()
        RBack()
        RLight()
        RMedium()
        RHeavy()
        RSpecial()
        RAssist()
        ReleaseInputModernSpecialMove()
        print("Stopped! Opponent not stunned. " .. tostring(action))
        return false
    end
end
--#endregion

--#region (notStun) - If Opponent is NOT Stunned
function notStun(action)
    if getOpponentStunnedStateBeta() ~= 0 then
        EnableGameInput()
        EnableGameInput()
        RDown()
        RUp()
        RToward()
        RBack()
        RLight()
        RMedium()
        RHeavy()
        RSpecial()
        RAssist()
        ReleaseInputModernSpecialMove()
        print("Stopped! Opponent stunned. " .. tostring(action))
        return false
        
    else
        action()
        return true
    end
end
--#endregion

--#region (MoveTimer) - Checks to see if move hits normally or meaty
function MoveTimer(target, baseValue)
    local currentTimer = getLocalMoveTimer()
    local waitTime = baseValue

    if currentTimer < target then
        print("Timer < Target: Timer=" .. currentTimer .. " Target=" .. target .. " Base=" .. baseValue .. " OS=" .. baseValue - ((currentTimer - target) * 20))
        waitTime = baseValue + ((target - currentTimer) * 20)
    elseif currentTimer > target then
        print("Timer > Target: Timer=" .. currentTimer .. " Target=" .. target .. " Base=" .. baseValue .. " OS=" .. baseValue - ((currentTimer - target) * 20))
        waitTime = baseValue - ((currentTimer - target) * 20)
    else
        waitTime = baseValue  -- When target equals currentTimer, output the base value.
    end

    if waitTime <= 0 then
        waitTime = 1
    end

    print("Calculated wait time: " .. waitTime)
    --print("Current Timer: " .. currentTimer)
    OwlSleep(waitTime)
end
--#endregion

--#region (KillCheck) - Checks what super could Kill 
function KillCheck(lvl1, lvl2, lvl3)
    local health = getOpponentHealthMeter()
    if health <= lvl1 then
        KillCombo_LVL1()
    elseif health <= lvl2 then
        KillCombo_LVL2()
    elseif health <= lvl3 then
        KillCombo_LVL3()
    end
end
--#endregion

--#endregion! ============================================= BASE FUNCTIONS

--#region! ================================================ BUTTONS

--#region Standing LP
function Do_StLP()
    DisableGameInput()

    if Classic then
        PLP()
        OS(40)
        RLP()
        
    elseif Modern then
        PLight()
        OS(40)
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LP
function Do_CrLP()
    DisableGameInput()

    if Classic then
        PDown()
        PLP()
        OS(40)
        RLP()
        RDown()
        
    elseif Modern then
        PDown()
        PLight()
        OS(40)
        RLight()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MP
function Do_StMP()
    DisableGameInput()

    if Classic then
        PMP()
        OS(40)
        RMP()
        
    elseif Modern then
        PAssist()
        PMedium()
        OS(40)
        RAssist()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MP
function Do_CrMP()
    DisableGameInput()

    if Classic then
        PDown()
        PMP()
        OS(40)
        RMP()
        RDown()
        
    elseif Modern then
        ifStun(PAssist)
        ifStun(PMedium)
        OS(40)
        RAssist()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HP
function Do_StHP()
    DisableGameInput()

    if Classic then
        PHP()
        OS(40)
        RHP()
        
    elseif Modern then
        PHeavy()
        OS(40)
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HP
function Do_CrHP()
    DisableGameInput()

    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RDown()
        RToward()
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Standing LK
function Do_StLK()
    DisableGameInput()

    if Classic then
        PLK()
        OS(40)
        RLK()
        
    elseif Modern then
        PLight()
        OS(40)
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LK
function Do_CrLK()
    DisableGameInput()

    if Classic then
        PDown()
        PLK()
        OS(40)
        RLK()
        RDown()
        
    elseif Modern then
        PDown()
        PLight()
        OS(40)
        RAssist()
        RLight()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MK
function Do_StMK()
    DisableGameInput()

    if Classic then
        PMK()
        OS(40)
        RMK()
        
    elseif Modern then
        PMedium()
        OS(40)
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MK
function Do_CrMK()
    DisableGameInput()

    if Classic then
        PDown()
        PMK()
        OS(40)
        RMK()
        RDown()
        
    elseif Modern then
        PDown()
        PMedium()
        OS(40)
        RMedium()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HK
function Do_StHK()
    DisableGameInput()

    if Classic then
        PHK()
        OS(40)
        RHK()
        
    elseif Modern then
        PAssist()
        PHeavy()
        OS(40)
        RHeavy()
        RAssist()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HK
function Do_CrHK()
    DisableGameInput()

    if Classic then
        PDown()
        PHK()
        OS(40)
        RHK()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RHeavy()
        RDown()
        RToward()
    end

    EnableGameInput()
end
--#endregion

--#region SA1
function Do_LVL1()
    DisableGameInput()
    if Classic then
        -- Missing
    elseif Modern then
        QCF()
        QCF()
        PLight()
        OS(40)
        RLight()
    end
    EnableGameInput()
end
--#endregion

--#region SA2
function Do_LVL2()
    DisableGameInput()
    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
    elseif Modern then
        QCB()
        QCB()
        PMedium()
        OS(40)
        RMedium()
    end
    EnableGameInput()
end
--#endregion

--#region SA3
function Do_LVL3()
    DisableGameInput()
    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
    elseif Modern then
        QCF()
        QCF()
        PHeavy()
        OS(40)
        RHeavy()
    end
    EnableGameInput()
end
--#endregion

--#region Block High
function BlockHigh()
    PBack()
    OS(math.random(80, 120))
    RBack()
    EnableGameInput()
end 
--#endregion

--#region Block Low
function BlockLow()
    PDown()
    PBack()
    OS(math.random(60, 120))
    RDown()
    RBack()
    OS(200)
    EnableGameInput()
end 
--#endregion

--#region Drive Rush
function DriveRush()
    PParry()
    OS(40)
    PToward()
    OS(20)
    RToward()
    OS(20)
    PToward()
    OS(20)
    RToward()
    RParry()
end
--#endregion

--#region Throw
function Throw()
    DisableGameInput()

    if Classic then
        PLP()
        PLK()
        OS(40)
        RLP()
        RLK()
        
    elseif Modern then
        PLight()
        PMedium()
        OS(40)
        RLight()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region QCF 
function QCF()
    PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	OS(30)
	RToward()
end
--#endregion

--#region QCB 
function QCB()
    PDown()
	OS(20)
	RDown()
	PDown()
	PBack()
	OS(20)
	RDown()
	RBack()
	PBack()
	OS(30)
	RBack()
end
--#endregion

--#endregion! ============================================= BUTTONS

--#region! ================================================ CHARACTER MOVES / ACTIONS

--#region MP AdFlame 
function AdFlameMP()
    DisableGameInput()
	PBack()
    PSpecial()
    OS(20)
    RBack()
    RSpecial()
    EnableGameInput()
end
--#endregion 

--#region MP AdFlame 
function AdFlameOD()
    DisableGameInput()
    PAssist()
	PBack()
    PSpecial()
    OS(20)
    RBack()
    RSpecial()
    RAssist()
    EnableGameInput()
end
--#endregion 

--#region Teleport
function Teleport()
    DisableGameInput()
    PToward()
    PLight()
    PMedium()
    PHeavy()
    OS(20)
    RToward()
    RLight()
    RMedium()
    RHeavy()
    EnableGameInput()
end
--#endregion

--#region OD Shoryuken 
function ShoryukenOD()
    DisableGameInput()
	PToward()
    PAssist()
    PSpecial()
    OS(20)
    RToward()
    RAssist()
    RSpecial()
    EnableGameInput()
end
--#endregion 

--#region LP Shoryuken 
function ShoryukenLP()
    DisableGameInput()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PLight()
    OS(20)
    RToward()
    RLight()
    EnableGameInput()
end
--#endregion 

--#region MP Shoryuken 
function ShoryukenMP()
    DisableGameInput()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PMedium()
    OS(20)
    RToward()
    RMedium()
    EnableGameInput()
end
--#endregion 

--#region HP Shoryuken 
function ShoryukenHP()
    DisableGameInput()
	PToward()
    PSpecial()
    OS(20)
    RToward()
    RSpecial()
    EnableGameInput()
end
--#endregion 

--#region LK Tatsu 
function TatsuLK()
    DisableGameInput()
	QCB()
    PLight()
    OS(20)
    RLight()
    EnableGameInput()
end
--#endregion 

--#region MK Tatsu 
function TatsuMK()
    DisableGameInput()
	QCB()
    PMedium()
    OS(20)
    RMedium()
    EnableGameInput()
end
--#endregion 

--#region HK Tatsu 
function TatsuHK()
    DisableGameInput()
	QCB()
    PHeavy()
    OS(20)
    RHeavy()
    EnableGameInput()
end
--#endregion 

--#endregion! ================================================ CHARACTER MOVES / ACTIONS

--#region! ================================================ LIGHT PUNCH

--#region Standing Light Punch
if HitConfirm(2, 150, 0, 0, "St LP") then
    DisableGameInput()
    OwlSleep(40)

    -- Counter Hit
    if getOpponentDistance() <= 150 
    and getOpponentStunnedStateBeta() ~= 0 
    and getOpponentIsBeingCounterHit() == true 
    and getOpponentIsBeingCounterPunish() == false 
    and getOpponentInAirByte() ~= 2 then

        MoveTimer(3, 20)
        --OS(100)
        if getOpponentDistance() <=130 then Do_StMP() end
        if getOpponentDistance() >=131 then PSpecial() OS(20) RSpecial() end
        
    end

    -- Punish Counter
    if getOpponentDistance() <= 150 
    and getOpponentStunnedStateBeta() ~= 0 
    and getOpponentIsBeingCounterHit() == false 
    and getOpponentIsBeingCounterPunish() == true 
    and getOpponentInAirByte() ~= 2 then

        MoveTimer(3, 150)
        ifStun(PDown)
        ifStun(PMedium)
        OS(40)
        RMedium()
        RDown()
        OS(200)
        ifStun(AdFlameMP)
        OS(1000)
        Do_StMK()
    
    end

    -- Normal Hit
    if getOpponentDistance() <= 100 
    and getOpponentStunnedStateBeta() ~= 0 
    and (getOpponentAnimationID() == 200 or getOpponentAnimationID() == 204)
    and getOpponentIsBeingCounterHit() == false 
    and getOpponentIsBeingCounterPunish() == false 
    and getOpponentInAirByte() == 0 then

        ifStun(PLight)
        OS(40)
        RLight()
        ifStun(function() OS(100) end)
        ifStun(TatsuLK)
        ifStun(function() MoveTimer(12, 280) end)
    end

    if getOpponentDistance() >= 101 
    and getOpponentStunnedStateBeta() ~= 0 
    and (getOpponentAnimationID() == 200 or getOpponentAnimationID() == 204)
    and getOpponentIsBeingCounterHit() == false 
    and getOpponentIsBeingCounterPunish() == false 
    and getOpponentInAirByte() == 0 then

        ifStun(TatsuLK)
        ifStun(function() MoveTimer(12, 280) end)
    end

    EnableGameInput()
    OwlSleep(100)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching LP (After Cr LK)
if HitConfirm(42, 200, 0, 0, "Crouching LP") then 
    DisableGameInput()
    ifStun(function() OS(100)  end)
    ifStun(PToward)
    ifStun(PSpecial)
    ifStun(function() OS(20)  end)
    RToward()
    RSpecial()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion


--#endregion! ============================================= LIGHT PUNCH

--#region! ================================================ MEDIUM PUNCH

--#region Standing MP SA1 Kill Combo 
if HitConfirm(4, 200, 30000, 0, "Standing MP SA1 Kill Combo") and SAMeter(5000) and Health(0, 2583) then 
    DisableGameInput()
    ifStun(function() OS(80)  end)
    PAssist()
    PMedium()
    OS(40)
    RAssist()
    RMedium()
    ifStun(function() OS(120)  end)
    MoveTimer(8, 100)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MP SA2 Kill Combo 
if HitConfirm(4, 200, 30000, 0, "Standing MP SA2 Kill Combo") and SAMeter(15000) and Health(2584, 3043) then 
    DisableGameInput()
    ifStun(function() OS(80)  end)
    PAssist()
    PMedium()
    OS(40)
    RAssist()
    RMedium()
    ifStun(function() OS(120)  end)
    MoveTimer(8, 100)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MP SA3 Kill Combo 
if HitConfirm(4, 200, 30000, 0, "Standing MP SA3 Kill Combo") and SAMeter(25000) and Health(3044, 3959) then 
    DisableGameInput()
    ifStun(function() OS(80)  end)
    PAssist()
    PMedium()
    OS(40)
    RAssist()
    RMedium()
    ifStun(function() OS(120)  end)
    MoveTimer(8, 100)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MP  
if HitConfirm(4, 200, 30000, 0, "Standing MP")  then 
    DisableGameInput()
    ifStun(function() OS(80)  end)
    PAssist()
    PMedium()
    OS(40)
    RAssist()
    RMedium()
    ifStun(function() OS(120)  end)
    MoveTimer(8, 100)
    ifStun(PBack)
    ifStun(PSpecial)
    ifStun(function() OS(20)  end)
    RBack()
    RSpecial()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 


--#endregion! ============================================= MEDIUM PUNCH

--#region! ================================================ HEAVY PUNCH

--#region Standing HP SA1 Kill Combo 
if HitConfirm(6, 260, 30000, 0, "Standing HP SA1 Kill Combo") and SAMeter(5000) and Health(0, 3136) then 
    DisableGameInput()
    MoveTimer(8, 160)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing HP SA2 Kill Combo 
if HitConfirm(6, 200, 30000, 0, "Standing HP SA2 Kill Combo") and SAMeter(15000) and Health(3137, 3595) then 
    DisableGameInput()
    MoveTimer(8, 160)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing HP SA3 Kill Combo 
if HitConfirm(6, 200, 30000, 0, "Standing HP SA3 Kill Combo") and SAMeter(25000) and Health(3596, 4595) then 
    DisableGameInput()
    MoveTimer(8, 160)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing HP  
if HitConfirm(6, 200, 30000, 0, "Standing HP")  then 
    DisableGameInput()
    if getOpponentAnimationID() == 276 then  MoveTimer(8, 20) TatsuHK() end
    --if getOpponentAnimationID() == 202 then  OS(100) ifStun(TatsuLK) end
    MoveTimer(8, 160)
    ifStun(QCB)
    ifStun(PLight)
    ifStun(function() OS(20)  end)
    RLight()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Forward HP
if HitConfirm(10, 200, 0, 0, "Forward HP") then 
    DisableGameInput()
    MoveTimer(8, 160)
    PHeavy()
    OS(40)
    RHeavy()
    ifStun(function() OS(220)  end)
    PHeavy()
    OS(40)
    RHeavy()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#endregion! ============================================= HEAVY PUNCH

--#region! ================================================ LIGHT KICK

--#region Crouching LK 
if HitConfirm(16, 200, 0, 0, "Crouching LK") then 
    DisableGameInput()
    ifStun(PDown) 
    ifStun(function() OS(100)  end)
    ifStun(PLight) 
    ifStun(function() OS(100)  end)
    RLight()
    RDown()
    ifStun(function() OS(100)  end)
    ifStun(PToward)
    ifStun(PSpecial)
    ifStun(function() OS(20)  end)
    RToward()
    RSpecial()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= LIGHT KICK

--#region! ================================================ MEDIUM KICK

--#region Standing MK SA1 Kill Combo 
if HitConfirm(5, 200, 30000, 0, "Standing MK SA1 Kill Combo") and SAMeter(5000) and Health(0, 3136) then 
    DisableGameInput()
    MoveTimer(6, 100)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MK SA2 Kill Combo 
if HitConfirm(5, 200, 30000, 0, "Standing MK SA2 Kill Combo") and SAMeter(15000) and Health(3137, 3595) then 
    DisableGameInput()
    MoveTimer(6, 100)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MK SA3 Kill Combo 
if HitConfirm(5, 200, 30000, 0, "Standing MK SA3 Kill Combo") and SAMeter(25000) and Health(3596, 4595) then 
    DisableGameInput()
    MoveTimer(6, 100)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MK  
if HitConfirm(5, 200, 30000, 0, "Standing MK") then 
    DisableGameInput()
    MoveTimer(6, 100)
    ifStun(QCB)
    ifStun(PLight)
    ifStun(function() OS(20)  end)
    RLight()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Crouching MK SA1 Kill Combo 
if HitConfirm(18, 200, 30000, "Both", "Crouching MK SA1 Kill Combo") and SAMeter(5000) and Health(0, 3136) then 
    DisableGameInput()
    MoveTimer(7, 100)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Crouching MK SA2 Kill Combo 
if HitConfirm(18, 200, 30000, "Both", "Crouching MK SA2 Kill Combo") and SAMeter(15000) and Health(3137, 3595) then 
    DisableGameInput()
    MoveTimer(7, 100)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Crouching MK SA3 Kill Combo 
if HitConfirm(18, 200, 30000, "Both", "Crouching MK SA3 Kill Combo") and SAMeter(25000) and Health(3596, 4595) then 
    DisableGameInput()
    MoveTimer(7, 100)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Crouching MK  
if HitConfirm(18, 200, 30000, 0, "Crouching MK") then 
    DisableGameInput()
    ifStun(PBack)
    ifStun(PSpecial)
    ifStun(function() OS(20)  end)
    RBack()
    RSpecial()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#endregion! ============================================= MEDIUM KICK

--#region! ================================================ HEAVY KICK

if HitConfirm(7, 200, 0, 0, "Heavy Kick") then 
    DisableGameInput()
    if getOpponentAnimationID() == 276 then  MoveTimer(12, 640) TatsuHK() end
    --if getOpponentAnimationID() == 202 then  MoveTimer(12, 640) TatsuHK() end
    MoveTimer(12, 640)
    ifStun(function() OS(80)  end)
    PAssist()
    PMedium()
    OS(40)
    RAssist()
    RMedium()
    
    EnableGameInput()
    --OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end

--#endregion! ============================================= HEAVY KICK

--#region! ================================================ OVERHEAD

--#region Overhead (Punish)
if HitConfirm(38, 220) then
    DisableGameInput()

    if Classic then
        -- Nothing Yet
        
    elseif Modern then
        PLight()
        OS(20)
        RLight()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= OVERHEAD

--#region! ================================================ THROW LOOP
if getLocalIsThrowing() then
    DisableGameInput()
    OwlSleepFrame(120)
    

    local randomChoice = math.random(3)

if randomChoice == 1 and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Meaty MK
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(280)
    --PAssist()
    PMedium()
    OS(60)
    --RAssist()
    RMedium()

elseif randomChoice == 2 and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Throw Loop
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(300)
    PLight()
    PMedium()
    OS(40)
    RLight()
    RMedium()


elseif randomChoice == 3 and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Shimmy
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(300)
    PBack()
    OS(200)
    RBack()
    
end

    EnableGameInput()
end
--#endregion! ============================================= THROW LOOP

--#region! ================================================ ADFLAME

--#region AdFlame
if HitConfirm(84, 300, 0, "Punish", "AdFlame MP") then 
    DisableGameInput()
    MoveTimer(18, 340)
    ifStun(Do_StHP)
    MoveTimer(8, 140)
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region AdFlame
if HitConfirm(84, 300, 0, "Counter", "AdFlame MP") then 
    DisableGameInput()
    MoveTimer(18, 140)
    PToward()
    PHeavy()
    OS(40)
    RHeavy()
    RToward()
    MoveTimer(18, 800)
    PDown()
    PSpecial()
    OS(20)
    RDown()
    RSpecial()
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region OD AdFlame
if HitConfirm(155, 300, 0, nil, "AdFlame OD") then 
    DisableGameInput()
    MoveTimer(18, 140)
    PToward()
    PHeavy()
    OS(40)
    RHeavy()
    RToward()
    MoveTimer(18, 1000)
    Teleport()
    OS(1000)
    if getOpponentDistance() > 113 then Do_StHP() end
    if getOpponentDistance() < 114 then PBack() OS(20) RBack() end
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#endregion! ============================================= ADFLAME

--#region! ================================================ TATSU

--#region Tatsu LK
if HitConfirmAirLoc(76, 300, 0, 0, "Tatsu LK") then 
    DisableGameInput()
    MoveTimer(12, 280)
    OKI_TatsuLK()
    EnableGameInput()
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#endregion! ============================================= TATSU

--#region! ================================================ COMBOS


--#region Kill Combo LVL 1
function KillCombo_LVL1()
    print("*** KillCombo_LVL1 ***")
    if Classic then
        --NA
    elseif Modern then
    DisableGameInput()
    ifStun(PParry)
    ifStun(function() OS(20)  end)
    RParry()
    ifStun(function() OS(100) end)
    ifStun(PToward)
    ifStun(PHeavy)
    ifStun(function() OS(720) end)
    RHeavy()
    RToward()
    ifStun(PDown)
    ifStun(function() OS(260) end)
    ifStun(PHeavy)
    ifStun(function() OS(20)  end)
    RHeavy()
    RDown()
    ifStun(function() OS(160) end)
    ifStun(PParry) -- Loop
    ifStun(function() OS(20)  end)
    RParry()
    ifStun(function() OS(240) end)-- DRC waitTime
    ifStun(PToward)
    ifStun(PHeavy)
    ifStun(function() OS(720) end)
    RHeavy()
    RToward() ------
    ifStun(PDown)
    ifStun(function() OS(300) end)
    ifStun(PHeavy)
    ifStun(function() OS(20)  end)
    RHeavy()
    RDown()
    ifStun(function() OS(100) end)
    ifStun(QCB) -- Start Tatsu
    ifStun(PLight)
    ifStun(function() OS(20)  end)
    RLight() -- End Tatsu
    ifStun(function() OS(920) end) -- Tatsu waitTime
    ifStun(PSpecial) -- Start SA1
    ifStun(PHeavy)
    ifStun(function() OS(40)  end)
    RSpecial()
    RHeavy() -- End SA1
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
    end
end
--#endregion

--#region Kill Combo LVL 2
function KillCombo_LVL2()
    if Classic then
        --NA
    elseif Modern then
        DisableGameInput()
        ifStun(PParry)
        ifStun(function() OS(20)  end)
        RParry()
        ifStun(function() OS(100) end)
        ifStun(PToward)
        ifStun(PHeavy)
        ifStun(function() OS(720) end)
        RHeavy()
        RToward()
        ifStun(PDown)
        ifStun(function() OS(260) end)
        ifStun(PHeavy)
        ifStun(function() OS(20)  end)
        RHeavy()
        RDown()
        ifStun(function() OS(160) end)
        ifStun(PParry) -- Loop
        ifStun(function() OS(20)  end)
        RParry()
        ifStun(function() OS(240) end)-- DRC waitTime
        ifStun(PToward)
        ifStun(PHeavy)
        ifStun(function() OS(720) end)
        RHeavy()
        RToward() ------
        ifStun(PDown)
        ifStun(function() OS(300) end)
        ifStun(PHeavy)
        ifStun(function() OS(20)  end)
        RHeavy()
        RDown()
        ifStun(function() OS(100) end)
        ifStun(QCB) -- Start Tatsu
        ifStun(PLight)
        ifStun(function() OS(20)  end)
        RLight() -- End Tatsu
        ifStun(function() OS(920) end) -- Tatsu waitTime
        ifStun(PBack) -- Start SA2
        ifStun(PHeavy)
        ifStun(PSpecial)
        ifStun(function() OS(40)  end)
        RSpecial()
        RHeavy() 
        RBack() -- End SA2
        EnableGameInput()
        OwlSleep(600)
        setOpponentOldMethodMoveID(0)
    end
end
--#endregion

--#region Kill Combo LVL 3
function KillCombo_LVL3()
    if Classic then
        --NA
    elseif Modern then
        DisableGameInput()
        ifStun(PParry)
        ifStun(function() OS(20)  end)
        RParry()
        ifStun(function() OS(100) end)
        ifStun(PToward)
        ifStun(PHeavy)
        ifStun(function() OS(720) end)
        RHeavy()
        RToward()
        ifStun(PDown)
        ifStun(function() OS(260) end)
        ifStun(PHeavy)
        ifStun(function() OS(20)  end)
        RHeavy()
        RDown()
        ifStun(function() OS(160) end)
        ifStun(PParry) -- Loop
        ifStun(function() OS(20)  end)
        RParry()
        ifStun(function() OS(240) end)-- DRC waitTime
        ifStun(PToward)
        ifStun(PHeavy)
        ifStun(function() OS(720) end)
        RHeavy()
        RToward() ------
        ifStun(PDown)
        ifStun(function() OS(300) end)
        ifStun(PHeavy)
        ifStun(function() OS(20)  end)
        RHeavy()
        RDown()
        ifStun(function() OS(100) end)
        ifStun(QCB) -- Start Tatsu
        ifStun(PLight)
        ifStun(function() OS(20)  end)
        RLight() -- End Tatsu
        ifStun(function() OS(920) end) -- Tatsu waitTime
        ifStun(PToward) -- Start DP
        ifStun(PSpecial)
        ifStun(function() OS(20)  end)
        RSpecial()
        RToward()
        ifStun(function() OS(100) end)
        ifStun(PDown) -- Start SA3
        ifStun(PHeavy)
        ifStun(PSpecial)
        ifStun(function() OS(40)  end)
        RSpecial()
        RHeavy() 
        RDown() -- End SA3
        EnableGameInput()
        OwlSleep(600)
        setOpponentOldMethodMoveID(0)
    end
end
--#endregion

--#region Dizzy Combo

if getOpponentAnimationID() == 353 -- Dizzy
then
    --DisableGameInput()

    --EnableGameInput()
end

--#endregion

--#region DI Combo
if  getOpponentAnimationID() == 276 then Do_StHP() end
--#endregion 

--#endregion! ============================================= COMBOS

--#region! ================================================ PUNISH AREA


--#region Shimmy Punish
if opponentDistance >= 119 and opponentDistance <= 220  
and getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(OpponentAnimationID == 715 or 
OpponentAnimationID == 717 or 
OpponentAnimationID == 700 or 
OpponentAnimationID == 701 or
OpponentAnimationID == 716 or 
OpponentAnimationID == 710 or
OpponentAnimationID == 712) 
then
DisableGameInput()
OS(60)
PHeavy()
OS(20)  
RHeavy()
EnableGameInput()
setOpponentOldMethodMoveID(0)
setOpponentAnimationID(1)
OS(300)
end
--#endregion

--[[--#region Anti Fireball
local fireballMoves = {
    [1] = {53, 54, 55, 56, 82, 83, 84, 85},   -- Ryu
    [2] = {96, 57, 58, 59},                   -- Luke
    [3] = {68, 69, 70},                       -- Kim
    [4] = {77, 79, 81},                       -- Chun
    [7] = {69, 70, 71},                       -- JP
    [8] = {62, 63, 64},                       -- Sim
    [10] = {58, 59, 60},                      -- Ken
    [11] = {74, 75},                          -- DJ
    [13] = {70},                              -- AKI
    [14] = {75},                              -- Rashid
    [16] = {73, 74},                          -- Juri
    [18] = {70, 71, 72, 73, 74, 75},          -- Guile
    [19] = {56, 58, 61},                      -- Ed
    [22] = {49, 50, 51}                       -- Akuma
}

-- Helper Function: Check if a move ID is a fireball
local function isFireballMove(characterID, moveID)
    local moves = fireballMoves[characterID]
    if not moves then return false end
    return isValueInTable(moveID, moves)
end

-- Fireball Reaction Logic
if  getLocalStunnedStateBeta() == 0           -- Ensure neutral state
    and getLocalInAirByte() ~= 2                  -- Ensure not in the air
    and getOpponentDistance() > 290 and getOpponentDistance() < 320 -- Define distance range
    and isFireballMove(getOpponentCharacterID(), getOpponentOldMethodMoveID()) then
    print("Executing Mtatsu - Opponent Distance: " .. getOpponentDistance()) -- Debugging distance before executing
    DisableGameInput()
    QCB()
    PMedium()
    OS(20)
    RMedium()
    OS(20)
    EnableGameInput()
end
--#endregion 
]]--


--#endregion! ============================================= PUNISH AREA

--#region! ================================================ OKI

--#region LK Tatsu OKI
function OKI_TatsuLK()
    DisableGameInput()

    local randomChoice = math.random(7)

    if randomChoice == 1 or randomChoice == 5 then --Throw
        Do_CrHK()
        OS(640)  
        PToward()
        OS(20)
        RToward()
        OS(40)
        PToward()
        OS(20)
        RToward()
        OS(340) -- Wait between dashes
        PToward()
        OS(20)
        RToward()
        OS(40)
        PToward()
        OS(20)
        RToward()
        OS(300) -- Wait between dashes
        PLight()
        PMedium()
        OS(20)
        RLight()
        RMedium()

    elseif randomChoice == 2 then --Strike
        Do_CrHK()
        OS(640)  
        PToward()
        OS(20)
        RToward()
        OS(40)
        PToward()
        OS(20)
        RToward()
        OS(340) -- Wait between dashes
        PToward()
        OS(20)
        RToward()
        OS(40)
        PToward()
        OS(20)
        RToward()
        OS(300) -- Wait between dashes
        PLight()
        OS(20)
        RLight()

    elseif randomChoice == 3 then -- Shroryuken with Meaty HP After
        --Do_CrHK()
        PToward()
        OS(80)  
        RToward()
        ShoryukenHP()

    elseif randomChoice == 4 then -- OD Flip
        Do_CrHK()
        OS(760)
        PDown()
        PAssist()
        PSpecial()
        OS(20)
        RDown()
        RAssist()
        RSpecial()
        OS(480) -- Wait time for Flip
        PHeavy()
        OS(20)
        RHeavy()
        OS(700) -- Wait time for Dive Kick
        if isOpponentAnimationDI() == "Yes" then PLight() PMedium() OS(20) RLight() RMedium() end
        if isOpponentAnimationDI() == "No" then ifStun(Do_StLP) end
        if isOpponentAnimationDI() == "No" then ifStun(TatsuMK) end 
        ifStun(function() OS(400) end)
        PLight()
        PMedium()
        OS(20)  
        RLight()
        RMedium()
    elseif randomChoice == 6 then -- Teleport Grab
        Do_CrHK()
        MoveTimer(31, 720)
        Teleport()
        MoveTimer(28,660) 
        PLight()
        PMedium()
        OS(20)
        RLight()
        RMedium()
    elseif randomChoice == 7 then -- Teleport 
        Do_CrHK()
        MoveTimer(31, 720)
        Teleport()
        --OS(900)
        MoveTimer(28,900)
        --print(getOpponentAnimationID())
        if getOpponentAnimationID() == 38 then PToward() OS(60) RToward() Do_StHK() OS(860) TatsuHK() end  
        if getOpponentAnimationID() == 37 then PToward() OS(120) RToward() Do_StHK() OS(860) TatsuHK() end  
        if getOpponentAnimationID() == 36 then PDown() PBack() OS(300) RDown() PHeavy() OS(20) RBack() RHeavy() end 
        PBack()
        OS(40)
        RBack()
        PSpecial()
        --print(getOpponentDistance())
        OS(880)
        RSpecial()
        MoveTimer(28, 540)
        DriveRush()
        --print(getLocalMoveTimer())
        print(getOpponentDistance())
        if getLocalMoveTimer() == 34 then MoveTimer(34, 160) end
        if getLocalMoveTimer() ~= 34 then MoveTimer(0, 160) end
        Do_StHP()
        OS(100)
        TatsuMK()
        MoveTimer(4, 1600)
        ShoryukenLP()
    end
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
    EnableGameInput()
end
--#endregion

--#endregion! ============================================= OKI

--#region! ================================================ ANTI CHARACTER
-- PunCon(charID, moveID, startup, minDistance, maxDistance, label)

--#region Anti Ryu

--#region Punches
--StartUP
if PunCond(1,  6, 9,   0, 200, "St HP")             then Do_StMP() end
--Whiff 
if PunCond(1,  4,  9,  180, 288, "St MP")           then Do_StHP()   end
if PunCond(1,  6,  9,  221, 288, "St HP")           then AdFlameMP() end
--#endregion

--#region Kicks
--StartUP
if PunCond(1, 18, 9,   0, 199, "Cr MK")             then Do_StLP() end
if PunCond(1,  7, 9,   0, 200, "St HK")             then Do_CrMK() AdFlameMP() end
--Whiff
if PunCond(1, 18,  9,  200, 288, "Cr MK")           then AdFlameMP() end
if PunCond(1, 20,  9,  209, 290, "Cr HK")           then AdFlameMP() end
--Block
if PunCond(1,  5, 9,   0, 300, "St MK")             then PBack() OS(200) RBack() end
--#endregion

--#region Unique Attacks
if PunCond(1, 12, nil, 0  , 130, "Whirl Kick")      then Do_StMP() OS(60) Do_StMP() OS(300) AdFlameMP() end
if PunCond(1, 12, nil, 131, 230, "Whirl Kick")      then PBack() OS(300) RBack() end
if PunCond(1, 12, nil, 231, 400, "Whirl Kick")      then PBack() OS(200) RBack() AdFlameMP() end
if PunCond(1,  9, nil,   0, 240, "SoloPlex")        then ShoryukenHP() end
if PunCond(1,  9, nil, 241, 440, "SoloPlex")        then OS(160) AdFlameMP() end
if PunCond(1,  8, nil,   0, 200, "Overhead")        then ShoryukenOD() end
--#endregion

--#region Anit-Air
if PunCond(1, 69, nil, 00, 230, "Air Tatsu")    then OS(200) ShoryukenHP() end
if AAReady(0,   200, 37, "F.Jump - Close AA")   then DisableGameInput() OS(500) ShoryukenLP() EnableGameInput() OS(1000) end
if AAReady(200, 260, 37, "F.Jump - Mid AA")     then DisableGameInput() OS(260) ShoryukenMP() EnableGameInput() OS(2000) end
if AAReady(0,   160, 36, "Neutral AA")          then DisableGameInput() OS(260) ShoryukenLP() EnableGameInput() OS(2000) end
--#endregion

--#region DriveRush
if PunCond(1, 92, nil, 120, 220, "DR") then Do_StMP()  Do_StMP() end
if PunCond(1, 92, nil, 220, 300, "DR") then Do_StHK()   end
--#endregion

--#region Fireballs 
--Far
if PunCond(1, 53, nil, 250, 350, "Fireball LP") then Parry(400, 300, 400) end
if PunCond(1, 82, nil, 250, 350, "Fireball LP") then Parry(400, 300, 400) end
if PunCond(1, 54, nil, 250, 350, "Fireball MP") then Parry(400, 400, 400) end
if PunCond(1, 83, nil, 250, 350, "Fireball MP") then Parry(400, 400, 400) end
if PunCond(1, 55, nil, 253, 400, "Fireball HP") then Parry(400, 400, 600) end
if PunCond(1, 84, nil, 253, 400, "Fireball HP") then Parry(400, 400, 600) end
if PunCond(1, 56, nil, 250, 350, "Denjin Fireball") then Parry(200, 300, 400) end
--Close
if PunCond(1, 53, nil, 75, 249, "Fireball LP") then Parry(180, 20, 300) Do_StHP() end
if PunCond(1, 82, nil, 75, 249, "Fireball LP") then Parry(180, 20, 300) Do_StHP() end
if PunCond(1, 54, nil, 75, 249, "Fireball MP") then Parry(160, 20, 300) Do_StHP() end -- 160 is way too strong
if PunCond(1, 83, nil, 75, 249, "Fireball MP") then Parry(160, 20, 300) Do_StHP() end -- 160 is way too strong
if PunCond(1, 55, nil, 75, 252, "Fireball HP") then Parry(120, 20, 300) Do_StHP() end
if PunCond(1, 84, nil, 75, 252, "Fireball HP") then Parry(120, 20, 300) Do_StHP() end
if PunCond(1, 56, nil, 75, 249, "Denjin Fireball") then Parry(120, 20, 300) Do_StHP() end
--#endregion

--#region Denjin Charge
if PunCond(1, 48, nil, 300, 500, "Denjin Charge LP") then DisableGameInput() PSpecial() OS(20) RSpecial() OS(400) EnableGameInput() end
--#endregion

--#region Hashogeki
--StartUP
if PunCond(1, 73, nil,   0, 250, "Hashogeki MP")    then Do_StHP() end -- this can be beat.. maybe EXDP?
if PunCond(1, 74, nil,   0, 160, "Hashogeki HP")    then Do_StHP() end
--Whiff 
if PunCond(1, 72, nil, 160, 300, "Hashogeki LP")    then AdFlameMP() end
if PunCond(1, 73, nil, 250, 300, "Hashogeki MP")    then OS(160) AdFlameMP() end
if PunCond(1, 74, nil, 160, 300, "Hashogeki HP")    then AdFlameMP() end
--#endregion

--#region Blade Kick

--Startup 
if PunCond(1, 64, nil, 0, 200, "Blade Kick LK")     then Do_StHP() end
if PunCond(1, 65, nil, 0, 200, "Blade Kick MK")     then Do_StHP() end
if PunCond(1, 66, nil, 0, 160, "Blade Kick HK")     then Do_StHP() end
--MidRange
if PunCond(1, 64, nil, 201, 250, "Blade Kick LK")     then Parry(100, 20, 300) Do_StHP() end
if PunCond(1, 65, nil, 201, 270, "Blade Kick MK")     then Parry(100, 20, 300) Do_StHP() end
if PunCond(1, 66, nil, 161, 270, "Blade Kick HK")     then Parry(300, 20, 300) Do_StHP() end
--Whiff 
if PunCond(1, 64, nil, 250, 350, "Blade Kick LK")   then OS(80)  AdFlameMP() end
if PunCond(1, 65, nil, 271, 350, "Blade Kick MK")   then OS(240) AdFlameMP() end
if PunCond(1, 66, nil, 271, 450, "Blade Kick HK")   then OS(340) AdFlameMP() end

--#endregion

--#region Tatsu LK
--Whiff
if PunCond(1, 59, nil, 236, 400, "Tatsu LK")  then 
    PBack() 
    OS(200) 
    RBack() 
    AdFlameMP() 
    ifStun(function()  OS(20) end)  Do_StHP()
    setOpponentOldMethodMoveID(0) 
end
--Blocked
if PunCond(1, 59, nil, 0, 230, "Tatsu LK")  then 
    DisableGameInput()
    PBack() 
    OS(200) 
    RBack() 
    OS(500)
    Do_StHK() 
    EnableGameInput()
    setOpponentOldMethodMoveID(0) 
end
--#endregion

--#region Tatsu MK
--Whiff
if PunCond(1, 60, nil, 301, 400, "Tatsu MK")  then 
    PBack() 
    OS(200) 
    RBack() 
    OS(200)
    AdFlameMP() 
    ifStun(function()  OS(20) end)  Do_StHP()
    setOpponentOldMethodMoveID(0) 
end
--Blocked
if PunCond(1, 60, nil, 0, 300, "Tatsu MK")  then 
    DisableGameInput()
    PBack() 
    OS(200) 
    RBack() 
    OS(1000)
    Do_StHK()
    EnableGameInput()
    setOpponentOldMethodMoveID(0) 
end
--#endregion

--#region Tatsu HK
--Whiff
if PunCond(1, 61, nil, 301, 400, "Tatsu HK")  then 
    PBack() 
    OS(800) 
    RBack() 
    OS(200)
    AdFlameMP() 
    ifStun(function()  OS(20) end)  Do_StHP()
    setOpponentOldMethodMoveID(0) 
end
--Blocked
if PunCond(1, 61, nil, 0, 300, "Tatsu HK")  then 
    DisableGameInput()
    PBack() 
    OS(800) 
    RBack() 
    OS(1000)
    Do_StHK()
    EnableGameInput()
    setOpponentOldMethodMoveID(0) 
end
--#endregion

--#endregion Anti Ryu

--#endregion! ============================================= ANTI CHARACTER

--#region! ================================================ AUTO BLOCKING

--#region Generic Block Close Range with MoveID 
if  getOpponentOldMethodMoveID() > 2 and getOpponentOldMethodMoveID() < 8 and getOpponentDistance() < 150  
then
    BlockLow()
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Generic Block Medium Range with MoveID 
if  getOpponentOldMethodMoveID() >= 8 and getOpponentOldMethodMoveID() < 25 and getOpponentDistance() < 200  
then
   BlockLow()
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= AUTO BLOCKING