--created by Shimering-Sky on Fanfiction.net
--coded by Lyris
--Dark Diamond Time Dragon Яeverse
function c101010279.initial_effect(c)
	c:EnableReviveLimit()
	--Must be Special Summoned with a "Black Ring" Spell Card, using 1 Dragon-Type monster and 1 Machine-Type monster, and cannot be Special Summoned by other ways.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_REMOVED,LOCATION_REMOVED)
	e2:SetTarget(c101010279.f3filter1)
	e2:SetValue(c101010279.efilter)
	c:RegisterEffect(e2)
	--Absolute Rewind
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c101010279.descost)
	e3:SetTarget(c101010279.destg)
	e3:SetOperation(c101010279.desop)
	c:RegisterEffect(e3)
end
function c101010279.mfilter1(c,tp)
	return not c:IsLocation(LOCATION_MZONE+LOCATION_HAND) or c:IsReleasableByEffect()
end
function c101010279.mfilter2(c,g,f1,f2)
	if not f1(c) and not f2(c) then return false end
	if f1(c) and not f2(c) then return g:IsExists(c101010279.mfilter3,1,c,f1,f2) end
	if f2(c) and not f1(c) then return g:IsExists(c101010279.mfilter3,1,c,f2,f1) end
	return g:IsExists(c101010279.mfilter3,1,c,nil,f1,f2)
end
function c101010279.mfilter3(c,f1,f2)
	return f1(c) and not f2(c)
end
function c101010279.material(tp,loc1,loc2,chk)
	local g=Duel.GetMatchingGroup(c101010279.mfilter1,tp,loc1,loc2,nil,tp)
	local f0=((c:IsOnField() and c:IsControler(tp)) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local f1=aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON)
	local f2=aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE)
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
function c101010279.f3filter1(e,c)
	return c:IsSetCard(0x5d) and c:IsType(TYPE_SPELL)
end
function c101010279.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c101010279.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c101010279.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101010279.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
