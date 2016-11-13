--created & coded by Lyris
--Cyber Light Twin Dragon
function c101010276.initial_effect(c)
--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,101010249,2,false,true)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--extra att
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
