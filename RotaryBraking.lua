-----------------------------------------------
--回転制動Lua v0.2 2018/12/16  製作者：huwahuwa--
-----------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------
--パラメーター設定　ここから

--Water = 0, Land = 1, Air = 2
Mode = 2

YawGain = 0.8
RollGain = 0.2
PitchGain = 1

--パラメーター設定　ここまで
--------------------------------------------------------------------------------------------------------------------------------



function Update(I)
  I:ClearLogs()

  local AngularVelocity = I:GetLocalAngularVelocity()
  local Input = {}

  for Type = 0, 5 do
    local num = I:GetInput(Mode, Type)
    Input[Type] = num ~= -1 and num ~= 1
    I:Log(Type.." : "..num)
  end

  if Input[0] and Input[1] then
    local Drive = Mathf.Min(Mathf.Max(AngularVelocity.y * YawGain, -0.99), 0.99)
    I:RequestControl(Mode, 0, Drive)
    I:RequestControl(Mode, 1, -Drive)
  end

  if Input[2] and Input[3] then
    local Drive = Mathf.Min(Mathf.Max(AngularVelocity.z * RollGain, -0.99), 0.99)
    I:RequestControl(Mode, 2, -Drive)
    I:RequestControl(Mode, 3, Drive)
  end

  if Input[4] and Input[5] then
    local Drive = Mathf.Min(Mathf.Max(AngularVelocity.x * PitchGain, -0.99), 0.99)
    I:RequestControl(Mode, 4, Drive)
    I:RequestControl(Mode, 5, -Drive)
  end
end
