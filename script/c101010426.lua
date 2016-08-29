--Clarissa, Knight of Constellar Vine
function c101010426.initial_effect(c)
	--removal
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_QUICK_O)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCode(EVENT_FREE_CHAIN)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c101010426.cost)
	ae1:SetTarget(c101010426.tg)
	ae1:SetOperation(c101010426.op)
	c:RegisterEffect(ae1)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c101010426.spcon)
	e1:SetOperation(c101010426.spop)
	e1:SetValue(SUMMON_TYPE_XYZ+7150)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(function(e,se,ep,st) return bit.band(st,SUMMON_TYPE_XYZ+7150)==SUMMON_TYPE_XYZ+7150 end)
	c:RegisterEffect(e2)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
end
function c101010426.spfilter(c,v,y,z)
	local atk=c:GetAttack()
	return c:GetLevel()==v and atk>=y and atk<=z and c:IsAbleToRemoveAsCost() and (c:IsSetCard(0x785e) or c:IsSetCard(0x53))
end
function c101010426.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c101010426.spfilter,tp,LOCATION_MZONE,0,1,nil,8,2800,3600)
end
function c101010426.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c101010426.spfilter,tp,LOCATION_MZONE,0,1,1,nil,8,2800,3600)
	local fg=g:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+0x7150)
end
function c101010426.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010426.tfilter(c)
	return c101010426.filter(c,c:GetOriginalType())
end
function c101010426.filter(c,typ)
	if bit.band(typ,TYPE_MONSTER)==TYPE_MONSTER then
		return c:IsAbleToRemove()
	elseif bit.band(typ,TYPE_SPELL)==TYPE_SPELL then
		return c:IsAbleToDeck()
	else return c:IsAbleToHand() end
end
function c101010426.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c101010426.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,c101010426.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	local cat=CATEGORY_TOHAND
	if bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER then cat=CATEGORY_REMOVE elseif bit.band(g:GetFirst():GetOriginalType(),TYPE_SPELL)==TYPE_SPELL then cat=CATEGORY_TODECK end
	e:SetCategory(cat)
	Duel.SetOperationInfo(0,cat,g,1,0,0)
end
function c101010426.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsFacedown() then Duel.ConfirmCards(tp,tc) end
		if tc:IsType(TYPE_MONSTER) then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
		if tc:IsType(TYPE_SPELL) then Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) end
		if tc:IsType(TYPE_TRAP) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
	end
end
