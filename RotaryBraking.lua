-----------------------------------------------
--回転制動Lua v0.1 2018/12/16  製作者：huwahuwa--
-----------------------------------------------



--Water = 0, Land = 1, Air = 2
Mode = 2

YawGain = 0.8
RollGain = 0.2
PitchGain = 1



function Update(I)
  I:ClearLogs()

  local AngularVelocity = I:GetLocalAngularVelocity()
  local Input = {}

  for Type = 0, 5 do
    Input[Type] = I:GetInput(Mode, Type)
    I:Log(Type.." : "..Input[Type])
  end

  if Mathf.Abs(Input[0]) ~= 1 and Mathf.Abs(Input[1]) ~= 1 then
    local Drive = Mathf.Min(Mathf.Max(AngularVelocity.y * YawGain, -0.99), 0.99)
    I:RequestControl(Mode, 0, Drive)
    I:RequestControl(Mode, 1, -Drive)
  end

  if Mathf.Abs(Input[2]) ~= 1 and Mathf.Abs(Input[3]) ~= 1 then
    local Drive = Mathf.Min(Mathf.Max(AngularVelocity.z * RollGain, -0.99), 0.99)
    I:RequestControl(Mode, 2, -Drive)
    I:RequestControl(Mode, 3, Drive)
  end

  if Mathf.Abs(Input[4]) ~= 1 and Mathf.Abs(Input[5]) ~= 1 then
    local Drive = Mathf.Min(Mathf.Max(AngularVelocity.x * PitchGain, -0.99), 0.99)
    I:RequestControl(Mode, 4, Drive)
    I:RequestControl(Mode, 5, -Drive)
  end
end
