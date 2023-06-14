-- 配置文件, 请按需求配置
Config = {}

-- 按需配置, 如果需要调用客户端, 请将指定为true
Config.Client_ClearNameTag = true
Config.Client_RestorePlayerClothes = true

-- 清理玩家名称/玩家身体头顶信息: 此方法会在客户端运行，如果您的清理玩家名称在服务端，请TriggerServerEvent
if Config.Client_ClearNameTag == true then
    print('[躲猫猫] 清理玩家名称函数将被直接呼叫')
    Config.ClearNameTag = function(source)
        -- 请在此填充您的清理名称方法和清理其他玩家身上/头顶文字信息的方法。
        -- TriggerEvent('nametag_example:clearNameTag', source, args_example[1], args_example[2]);
        TriggerServerEvent('peek-a-boo:server:testPrint', '[躲猫猫] 清理玩家名称函数: 客户端')
    end
else
    Config.ClearNameTag = function()
        local src = source
        -- 请在此填充您的清理名称方法和清理其他玩家身上/头顶文字信息的方法。
        -- TriggerServerEvent('nametag_example:clearNameTag', args_example[1], args_example[2]);
        TriggerServerEvent('peek-a-boo:server:testPrint', '[躲猫猫] 清理玩家名称函数: 服务端')
    end
end

-- 重置回玩家服饰: 此方法会在客户端运行，如果您的重置回玩家服饰在服务端，请TriggerServerEvent
Config.RestorePlayerClothes = function(source)
    -- 请在此填充您的重置回玩家服饰的方法。

    -- 如果需要在服务端清理
    -- TriggerServerEvent('skinchanger:loadClothes', args_example[1], args_example[2]);
end

-- 自定义消息: 开始游戏消息/提示/信息
Config.Message_StartGame = function()
    -- 请在此填充开始游戏消息/提示/信息，此方法会在服务端调用, 如果您的消息/提示/信息方法在客户端 请使用TriggerClientEvent
    print("[躲猫猫] 游戏已开始")
end

-- 自定义消息: 游戏结束消息/提示/信息 (建议添加: "新的游戏将在2分钟后开始报名")
Config.Message_EndGame = function()
    -- 请在此填充游戏结束消息/提示/信息，此方法会在服务端调用, 如果您的消息/提示/信息方法在客户端 请使用TriggerClientEvent
    print("[躲猫猫] 游戏已结束")
end

-- 自定义消息: 游戏满3人等待2分钟后检测不满3人 (建议添加: "由于人数不足, 游戏重新等待报名")
Config.Message_NotEnoughPlayer = function()
    -- 请在此填充消息/提示/信息，此方法会在服务端调用, 如果您的消息/提示/信息方法在客户端 请使用TriggerClientEvent
    print("[躲猫猫] 游戏满过3人, 但在开始时不够, 将重新等待报名")
end

-- 自定义消息: 全局游戏等待消息/提示/信息
Config.Message_WaitForPlayer = function()
    -- 请在此填充游戏全局等待消息/提示/信息，此方法会在服务端调用, 如果您的消息/提示/信息方法在客户端 请使用TriggerClientEvent
    print("[躲猫猫] 游戏等待中...全局游戏等待消息/提示/信息")
end

-- 自定义消息: 满足3人，但继续等待2分钟的提示 - 例如: "抓紧时间加入游戏啊!"
Config.Message_LastWaitPlayer = function()
    -- 请在此填充消息/提示/信息，此方法会在服务端调用, 如果您的消息/提示/信息方法在客户端 请使用TriggerClientEvent
    print("[躲猫猫] 游戏已满3人, 现在是最后的2分钟加入游戏")
end

-- 自定义消息: 游戏已开始
Config.Message_AlreadyStarted = function()
   -- 请在此填充消息/提示/信息，此方法会在服务端调用, 如果您的消息/提示/信息方法在客户端 请使用TriggerClientEvent
   print("[躲猫猫] 游戏正在进行中, 请等待结束")
end