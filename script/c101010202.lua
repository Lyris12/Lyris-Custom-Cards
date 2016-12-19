--created & coded by Lyris
--Fate's Яeversed Dragoon
function c101010202.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--During the End Phase, if this card is attached to an Xyz Monster, send this card to the Graveyard. 
	if not c101010202.global_check then
		c101010202.global_check=true
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetOperation(c101010202.desop2)
		Duel.RegisterEffect(e2)
	end
	--If this card would be returned to the Extra Deck, shuffle 1 other monster you control into the Deck instead, and if you do, inflict damage to your opponent equal to the its ATK on the field.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c101010202.reptg)
	c:RegisterEffect(e3)
end
function c101010202.mfilter1(c,tp)
	return not c:IsLocation(LOCATION_MZONE+LOCATION_HAND) or c:IsReleasableByEffect()
end
function c101010202.mfilter2(c,g,f1,f2)
	if not f1(c) and not f2(c) then return false end
	if f1(c) and not f2(c) then return g:IsExists(c101010202.mfilter3,1,c,f1,f2) end
	if f2(c) and not f1(c) then return g:IsExists(c101010202.mfilter3,1,c,f2,f1) end
	return g:IsExists(c101010202.mfilter3,1,c,nil,f1,f2)
end
function c101010202.mfilter3(c,f1,f2)
	return f1(c) and not f2(c)
end
function c101010202.material(tp,loc1,loc2,chk)
	local g=Duel.GetMatchingGroup(c101010202.mfilter1,tp,loc1,loc2,nil,tp)
	local f0=((c:IsOnField() and c:IsControler(tp)) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local f1=aux.FilterBoolFunction(Card.IsCode,101010408) and f0
	local f2=aux.FilterBoolFunction(Card.IsSetCard,0xf7a) and f0
	if chk==0 then return g:IsExists(c101010202.mfilter2,1,nil,g,f1,f2) end
	local g1=g:FilterSelect(tp,c101010202.mfilter2,1,1,nil,g,f1,f2)
	local tc=g1:GetFirst()
	local g2=nil
	if f1(tc) and not f2(tc) then
		g2=g:FilterSelect(tp,c101010202.mfilter3,1,1,tc,f1,f2)
	elseif f2(tc) and not f1(tc) then
		g2=g:FilterSelect(tp,c101010202.mfilter3,1,1,tc,f2,f1)
	else
		g2=g:Select(tp,1,1,tc)
	end
	g1:Merge(g2)
	return g1
end
function c101010202.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_OVERLAY,LOCATION_OVERLAY,nil,101010202)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c101010202.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return re~=e and bit.band(c:GetDestination(),0x43)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_MZONE,0,1,c) end
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_MZONE,0,1,1,c):GetFirst()
	local atk=0
	if tc:IsFaceup() then atk=tc:GetAttack() end
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT+REASON_REPLACE)
	Duel.Damage(1-tp,atk,REASON_EFFECT)
	return true
end
