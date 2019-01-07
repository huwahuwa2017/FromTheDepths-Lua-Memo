----------------------------------------------------
--無誘導ミサイル信管Lua v0.3 2019/1/7  製作者：huwahuwa--
----------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------
--パラメーター設定　ここから


--ミサイルの高度が設定値より低い時に起爆
Altitude = -3

--ミサイルの速度が設定値より遅い時に起爆
Speed = 10

--1フレームの間にミサイルの移動する方向の変化が設定値より大きい時に起爆
Angle = 1

--発射してから何秒経ったかの時間が設定値より長い時に起爆
Time = 60


--パラメーター設定　ここまで
--------------------------------------------------------------------------------------------------------------------------------



MissileMemory = {}

function Update(I)
  I:ClearLogs()

  for ID, Memory in pairs(MissileMemory) do
    I:Log(ID)
    Memory.Update = false
  end

  for TIndex = 0, I:GetLuaTransceiverCount() - 1 do
    for MIndex = 0, I:GetLuaControlledMissileCount(TIndex) - 1 do
      local LCMI = I:GetLuaControlledMissileInfo(TIndex, MIndex)
      local CurrentVelocity = LCMI.Velocity

      if MissileMemory[LCMI.Id] == nil then
        MissileMemory[LCMI.Id] = {}
        MissileMemory[LCMI.Id].Velocity = CurrentVelocity
      end

      if LCMI.TimeSinceLaunch > 0.1 then
        local Detonation = false

        if Altitude ~= nil and LCMI.Position.y < Altitude then
          Detonation = true
        end

        if Speed ~= nil and CurrentVelocity.magnitude < Speed then
          Detonation = true
        end

        if Angle ~= nil and I:Maths_AngleBetweenVectors(CurrentVelocity, MissileMemory[LCMI.Id].Velocity) > Angle then
          Detonation = true
        end

        if Time ~= nil and LCMI.TimeSinceLaunch > Time then
          Detonation = true
        end

        if Detonation then
          I:DetonateLuaControlledMissile(TIndex, MIndex)
        end
      end

      MissileMemory[LCMI.Id].Velocity = CurrentVelocity
      MissileMemory[LCMI.Id].Update = true
    end
  end

  for ID, Memory in pairs(MissileMemory) do
    if not Memory.Update then
      MissileMemory[ID] = nil
    end
  end
end
