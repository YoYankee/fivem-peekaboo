local client_playerState = false
local posVec = vector3(-1300.8, -1407.218, 3.802979)
local weapon_ball = 0x787F0BB

local client_blipRadius = nil
local client_blipCoord = nil

local client_playerCount = 0
local client_gameState = false

RegisterNUICallback("tryJoinGame",function(data,cb)
    TriggerServerEvent('peek-a-boo:server:tryJoinGame')
    cb("ok")
end)

RegisterNUICallback("quitGame",function(data,cb)
    TriggerServerEvent('peek-a-boo:server:quitGame')
    print("[躲猫猫] 已退出游戏")
    client_playerState = false
    updatePlayerCount(client_playerCount)
    -- 清理游戏状态
    cb("ok")
end)

RegisterNetEvent("peek-a-boo:client:joinGame", function(state)
    -- 设置坐标, 设置圈, 隐藏名称
    if state == true then
        client_playerState = true
        clearPlayerNameTag(source)

        SetEntityCoordsNoOffset(PlayerPedId(), posVec, true, true, true) 

        -- -1300.8, -1407.218, 3.802979
        local blip = AddBlipForRadius(posVec, 150.0)

        client_blip = blip
        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, 128)

        local blip = AddBlipForCoord(posVec)

        client_blipCoord = blip
        SetBlipSprite(blip, 362)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("躲猫猫")
        EndTextCommandSetBlipName(blip)

        GiveWeaponToPed(PlayerPedId(), weapon_ball, 9999, false, true)
        SetPedInfiniteAmmo(PlayerPedId(), true, weapon_ball)
    end
end)

RegisterNetEvent("peek-a-boo:client:quitGame", function()
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)
end)

-- function RestorePlayerClothes() 
--     Config.RestorePlayerClothes(GetPlayerServerId(PlayerId()));
-- end

RegisterNetEvent("peek-a-boo:client:showMenu", function()
    SendNUIMessage({
        action = 'show',
        playerCount = client_playerCount,
        playerState = client_playerState
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("hideMenu",function(data,cb)
    if data.hide == true then
        SetNuiFocus(false,false)
        cb("ok")
    end
end)

RegisterNetEvent("peek-a-boo:client:hideMenu", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("peek-a-boo:client:updatePlayerCount", function(count)
    updatePlayerCount(count)
end)

RegisterNetEvent("peek-a-boo:client:updateGameState", function(state)
    client_gameState = state
    SendNUIMessage({
        action = 'start',
        playerCount = client_playerCount,
        playerState = client_playerState,
        gameState = client_gameState
    })
end)


RegisterNetEvent("peek-a-boo:client:endGame", function(player)
    if client_playerState then
        print('[躲猫猫] 游戏时间已到, 游戏已结束')
    end
end)

function updatePlayerCount(count)
    client_playerCount = count
    SendNUIMessage({
        action = 'update',
        playerCount = count,
        playerState = client_playerState
    }) 
end

function clearPlayerNameTag(source)
    if Config.Client_ClearNameTag == true then
        Config.ClearNameTag(source)
    else 
        Config.ClearNameTag()
    end
end

function SetNPCResistance()
    local playerPed = PlayerPedId()

    -- 获取所有的 NPC
    local npcs = {}
    for _, ped in ipairs(GetGamePool("CPed")) do
        if not IsPedAPlayer(ped) then
            if #(GetEntityCoords(ped) - posVec) < 150 then
                table.insert(npcs, ped)
            end
        end
    end

    -- 设置 NPC 的抗性
    for _, npc in ipairs(npcs) do
        -- 忽略玩家的枪击
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetPedCanRagdollFromPlayerImpact(npc, false)
        StopCurrentPlayingSpeech(npc)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if client_playerState then
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            SetNPCResistance()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if client_playerState then
            if #(GetEntityCoords(PlayerPedId()) - posVec) > 150 then
                -- 请返回，超过10秒未返回退出游戏。               
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if client_playerState then
            if IsPedBeingDamaged(PlayerPedId()) then
                TriggerServerEvent('peek-a-boo:server:playerHit')
            end
        end
    end
end)

