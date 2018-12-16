---------------------------------------------------------
--無誘導ミサイル高度制御Lua v0.2 2018/12/16  製作者：huwahuwa--
---------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------
--パラメーター設定　ここから

--滑空高度　入力した数値よりミサイルの高度が高いとき、ミサイルの姿勢を水平にします
GlidingAltitude = 1

--目標高度
TargetAltitude = -0.5

--高度維持の強さ
Gain = 0.02

--パラメーター設定　ここまで
--------------------------------------------------------------------------------------------------------------------------------



MissileMemory = {}

function Update(I)
  I:ClearLogs()

  for ID, Memory in pairs(MissileMemory) do
    I:Log(ID)
    Memory.Update = false
  end

  for i = 0, I:GetLuaTransceiverCount() - 1 do
    for j = 0, I:GetLuaControlledMissileCount(i) - 1 do
      local LCMI = I:GetLuaControlledMissileInfo(i,j)

      if MissileMemory[LCMI.Id] == nil then
        local TargetVector = I:GetLuaTransceiverInfo(i).Forwards
        TargetVector.y = 0
        TargetVector = TargetVector.normalized / Gain

        MissileMemory[LCMI.Id] = {}
        MissileMemory[LCMI.Id].TargetVector = TargetVector
      end

      MissileMemory[LCMI.Id].Update = true

      local V = LCMI.Position + MissileMemory[LCMI.Id].TargetVector
      local PositionY = LCMI.Position.y
      V.y = (PositionY < GlidingAltitude) and TargetAltitude or PositionY
      I:SetLuaControlledMissileAimPoint(i,j,V.x,V.y,V.z)
    end
  end

  for ID, Memory in pairs(MissileMemory) do
    if not Memory.Update then
      MissileMemory[ID] = nil
    end
  end
end
