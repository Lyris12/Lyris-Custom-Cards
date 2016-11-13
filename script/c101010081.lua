--created & coded by Lyris
--ＳＳーマリフレアー
function c101010081.initial_effect(c)
--direct
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e0)
end
