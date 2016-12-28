--created & coded by Lyris
--浸透圧
function c101010065.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c101010065.disable)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetRange(LOCATION_FZONE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetTarget(c101010065.destg)
	e1:SetOperation(c101010065.desop)
	c:RegisterEffect(e1)
end
function c101010065.desfilter(c)
	local atk1=c:GetAttack() local atk2=c:GetBaseAttack()
	local def1=c:GetDefense() local def2=c:GetBaseDefense()
	return atk1<=0 or def1<=0 or math.abs(atk1-atk2)>2000 or math.abs(def1-def2)>2000
end
function c101010065.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c101010065.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101010065.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101010065.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c101010065.disable(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
end
