local MySQL = MySQL
local db = {}

local SELECT_ACCOUNT_BY_ID = 'SELECT * FROM `accounts` WHERE `id` = ?'

---@param id number
function db.selectAccountById(id)
    return MySQL.single.await(SELECT_ACCOUNT_BY_ID, { id })
end

local SELECT_ACCOUNTS_BY_charId = 'SELECT * FROM `accounts` WHERE `owner` = ?'

---@param charId number
function db.selectCharacterAccounts(charId)
    return MySQL.query.await(SELECT_ACCOUNTS_BY_charId, { charId })
end

local SELECT_ACCOUNTS_BY_GROUP = 'SELECT * FROM `accounts` WHERE `group` = ?'

---@param group string
function db.selectGroupAccounts(group)
    return MySQL.query.await(SELECT_ACCOUNTS_BY_GROUP, { group })
end

local SELECT_ACCOUNT_BALANCE = 'SELECT `balance` FROM `accounts` WHERE `id` = ?'

function db.selectAccountBalance(id)
    return MySQL.scalar.await(SELECT_ACCOUNT_BALANCE, { id })
end

local ADD_BALANCE = 'UPDATE `accounts` SET `balance` = `balance` + ? WHERE `id` = ?'
local REMOVE_BALANCE = 'UPDATE `accounts` SET `balance` = `balance` - ? WHERE `id` = ?'

---@param id number
---@param amount number
---@return number
function db.addBalance(id, amount)
    return MySQL.update.await(ADD_BALANCE, { amount, id })
end

---@param id number
---@param amount number
---@return number
function db.removeBalance(id, amount)
    return MySQL.update.await(REMOVE_BALANCE, { amount, id })
end

---@param fromId number
---@param toId number
---@param amount number
---@return boolean
function db.performTransaction(fromId, toId, amount)
    return MySQL.transaction.await({
        { REMOVE_BALANCE, { amount, fromId } },
        { ADD_BALANCE, { amount, toId } },
    })
end

return db
