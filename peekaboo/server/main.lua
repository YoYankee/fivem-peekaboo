local server_gameState = false -- 游戏的状态
local server_playerCount = {
    value = 0,
    onChange = nil
}

-- 设置人数meta
local function setPlayerCount(count)
    server_playerCount.value = count
    if server_playerCount.onChange then
        server_playerCount.onChange(server_playerCount.value)
    end
end

local function getPlayerCount()
    return server_playerCount.value
end

local function handleOnChange(value)
    print("[躲猫猫] 目前玩家数量变化为:"..value)
    TriggerClientEvent('peek-a-boo:client:updatePlayerCount', source, getPlayerCount())
end

server_playerCount.onChange = handleOnChange

local function setGameState(state)
    server_gameState = state
    TriggerClientEvent('peek-a-boo:client:updateGameState', source, server_gameState)
end

function startGame()
    if getPlayerCount() < 1 then
        Config.Message_NotEnoughPlayer()
        WaitForPlayers()
    else 
        setGameState(true)
        print("[躲猫猫] 游戏开始, 在10分钟后会自动结束, 或在游戏目的达成提前结束")
        -- Citizen.Wait(600000) -- 10分钟
        Citizen.Wait(60000)
        endGame('正常结束')
        -- Citizen.Wait(120000) -- 2分钟
        Citizen.Wait(12000) -- 2分钟
        WaitForPlayers()
    end
end

function endGame(reason)
    setGameState(false)
    TriggerClientEvent('peek-a-boo:client:updateGameState', source, server_gameState)
    setPlayerCount(0)
    for _, player in ipairs(GetPlayers()) do
        TriggerClientEvent('peek-a-boo:client:endGame', player)
    end
    Config.Message_EndGame()
    -- 踢出所有游戏内的玩家并重置会正常状态
    print("[躲猫猫] 游戏"..reason)
    WaitForPlayers()
end

function WaitForPlayers()
    print("[躲猫猫] 等待玩家加入(目前未满3人)...")
    Config.Message_WaitForPlayer()
    while true do
        Citizen.Wait(1000)  -- 每秒检查一次玩家数量
        if getPlayerCount() >= 1 then
            print("[躲猫猫] 参与人数已满足游戏开始条件, 但还是会等待2分钟让更多玩家有时间加入")
            Config.Message_LastWaitPlayer()
            -- Citizen.Wait(120000)
            Citizen.Wait(12000)  -- 2分钟
            startGame()
            break
        end
    end
end

RegisterNetEvent("peek-a-boo:server:testPrint", function(text)
    print(text)
end)

RegisterCommand("peekaboo", function(source, args, rawCommand)
    TriggerClientEvent('peek-a-boo:client:showMenu', source)
end)

RegisterCommand("updatepeek", function(source, args, rawCommand)
    local text = ""
    for _,v in ipairs(args) do 
        text = text .. " " .. v
    end

    if text:len() == 0 then 
        return
    end
    TriggerClientEvent('peek-a-boo:client:updatePlayerCount', source, text)
end)

RegisterNetEvent("peek-a-boo:server:tryJoinGame", function()
    local src = source
    if server_gameState then
        -- 游戏已经开始
        Config.Message_AlreadyStarted();
        print("[躲猫猫] 游戏已经开始了, 无法中途加入")
    else
        TriggerClientEvent('peek-a-boo:client:joinGame', source, true)
        setPlayerCount(getPlayerCount() + 1)
    end
end)

RegisterNetEvent("peek-a-boo:server:quitGame", function()
    local src = source
    TriggerClientEvent('peek-a-boo:client:quitGame', source)
    setPlayerCount(getPlayerCount() - 1)
end)

local hitCount = {} -- 用于跟踪每个玩家的击中次数

RegisterServerEvent('peek-a-boo:server:playerHit')
AddEventHandler('peek-a-boo:server:playerHit', function()
    local src = source
    if hitCount[source] then
        hitCount[source] = hitCount[source] + 1
    else
        hitCount[source] = 1
    end

    if hitCount[source] >= 3 then
        TriggerClientEvent('playerHitThreeTimes', source)
        hitCount[source] = nil
    end
end)

RegisterCommand("testgame", function(source, args, rawCommand)
    WaitForPlayers()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print("[躲猫猫] 成功加载 - 作者: YoYankee");
end)