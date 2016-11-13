--created by LionHeartKIng
--coded by Lyris
--Rusted Dragon
function c101020108.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101020108.spcon)
	c:RegisterEffect(e1)
end
function c101020108.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
