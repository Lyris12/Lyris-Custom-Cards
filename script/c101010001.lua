--created & coded by Lyris
--サイバー・サーペント
function c101010001.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCountLimit(1)
	e4:SetTarget(c101010001.target)
	e4:SetValue(c101010001.value)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c101010001.slcon)
	e2:SetValue(5)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e3)
end
function c101010001.slcon(e)
	local seq=e:GetHandler():GetSequence()
	if seq~=6 and seq~=7 then return false end
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or (not (tc:IsSetCard(0x93) or tc:IsSetCard(0x94)))
end
function c101010001.target(e,c)
	return c:IsSetCard(0x93) or c:IsSetCard(0x94)
end
function c101010001.value(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
