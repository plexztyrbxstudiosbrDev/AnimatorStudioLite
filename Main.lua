--[[
    MORTAL PLUGINS V1
    Carregador Principal
    Para: Delta Executor + Studio Lite
]]

local baseUrl = "https://raw.githubusercontent.com/plexztyrbxstudiosbrDev/AnimatorStudioLite/main/"

local function LoadModule(name)
    local url = baseUrl .. name .. ".lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        local func, err = loadstring(result)
        if func then
            local execSuccess, execErr = pcall(func)
            if execSuccess then
                print("[MORTAL] " .. name .. " carregado!")
                return true
            else
                warn("[MORTAL] Erro ao executar " .. name .. ": " .. tostring(execErr))
                return false
            end
        else
            warn("[MORTAL] Erro ao compilar " .. name .. ": " .. tostring(err))
            return false
        end
    else
        warn("[MORTAL] Erro ao baixar " .. name .. ": " .. tostring(result))
        return false
    end
end

print("[MORTAL] Iniciando carregamento...")

LoadModule("Core")

task.wait(0.5)

LoadModule("Animator")

print("[MORTAL] Carregamento completo!")
