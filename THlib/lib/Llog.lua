---=====================================
---luastg simple log system
---=====================================

----------------------------------------
--- simple MessageBox

--- 简单的警告弹窗
---@param msg string
function lstg.MsgBoxWarn(msg)
    local ret = lstg.MessageBox("程序异常警告", msg, 1 + 48)
    if ret == 2 then
        os.exit()
    end
end

--- 简单的错误弹窗
---@param msg string
function lstg.MsgBoxError(msg, title, exit)
    title = title or "程序异常终止"
    if type(exit) ~= "boolean" then
        exit = true
    end
    local ret = lstg.MessageBox(title, msg, 0 + 16)
    if ret == 1 and exit then
        os.exit()
    end
end
