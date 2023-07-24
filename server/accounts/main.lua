---@class OxAccountProperties
---@field id number
---@field accountId string
---@field balance number
---@field isDefault boolean
---@field label? string
---@field owner? number
---@field group? string

local db = require 'server.accounts.db'

---@param id number
---@return OxAccountProperties?
function Ox.GetAccountById(id)
    return db.selectAccountById(id)
end

---@param playerId number
---@return OxAccountProperties[]?
function Ox.GetPlayerAccounts(playerId)
    local player = Ox.GetPlayer(playerId)

    if player then
        return db.selectCharacterAccounts(player.charId)
    end
end

---@param charId number
---@return OxAccountProperties[]?
function Ox.GetCharacterAccounts(charId)
    return db.selectCharacterAccounts(charId)
end

---@param group string
---@return OxAccountProperties[]
function Ox.GetGroupAccounts(group)
    return db.selectGroupAccounts(group)
end

---@param id number
---@param amount number
---@return boolean
function Ox.AddAccountBalance(id, amount)
    return db.addBalance(id, amount) == 1
end

---@param id number
---@param amount number
---@return boolean
function Ox.RemoveAccountBalance(id, amount)
    return db.removeBalance(id, amount) == 1
end

---@param fromId number
---@param toId number
---@param amount number
---@return boolean
function Ox.TransferAccountBalance(fromId, toId, amount)
    return db.performTransaction(fromId, toId, amount)
end
