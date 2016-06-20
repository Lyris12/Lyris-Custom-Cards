--ＳＳーマリフレアー
local id,ref=GIR()
function ref.start(c)
--direct
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e0)
end
