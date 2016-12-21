--created & coded by Lyris
--Cybernet Zone
function c101010299.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101010299.actcost)
	e1:SetOperation(c101010299.activate)
	c:RegisterEffect(e1)
	--atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetRange(LOCATION_FZONE)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetTarget(c101010299.atktg)
	e0:SetValue(c101010299.atkval)
	c:RegisterEffect(e0)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCost(c101010299.cost)
	e2:SetTarget(c101010299.tg)
	e2:SetOperation(c101010299.op)
	c:RegisterEffect(e2)
end
function c101010299.atktg(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c101010299.atkval(e,c)
	local atk=c:GetBaseAttack()
	return atk/4
end
function c101010299.cfilter(c)
	local code=c:GetCode()
	return (code==12670770 or code==86686671) and c:IsAbleToGraveAsCost()
end
function c101010299.fcfilter(c)
	return c:IsLocation(LOCATION_HAND) or c:IsFacedown()
end
function c101010299.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c101010299.cfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil)
		return Duel.GetCurrentPhase()~=PHASE_MAIN2 and g:GetClassCount(Card.GetCode)>=2
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,Duel.GetTurnPlayer())
	local sg=Duel.GetMatchingGroup(c101010299.cfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsCode,nil,g:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	g:Merge(sg:Select(tp,1,1,nil))
	local fg=g:Filter(c101010299.fcfilter,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.SendtoGrave(g,REASON_COST)
end
function c101010299.filter1(c)
	return (((c:IsSetCard(0x93) or c:IsSetCard(0x94)) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT))) and c:IsAbleToHand()
end
function c101010299.filter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToDeck()
end
function c101010299.filter3(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemove()
end
function c101010299.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(c101010299.filter1,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101010299,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	local g2=Duel.GetMatchingGroup(c101010299.filter2,tp,LOCATION_GRAVE,0,nil)
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101010299,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg2,nil,2,REASON_EFFECT)
	end
	local g3=Duel.GetMatchingGroup(c101010299.filter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g3:GetCount()>0 then
		Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)
	end
end
function c101010299.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,Duel.GetTurnPlayer())
end
function c101010299.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c101010299.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c101010299.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown() and c:IsDestructable()
end
function c101010299.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local count=0
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft1>0 then
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c101010299.spfilter,tp,LOCATION_REMOVED,0,1,ft1,nil,e,tp)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
					tc=g:GetNext()
					count=count+1
				end
			end
		end
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ft2>0 then
			if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(1-tp,c101010299.spfilter,tp,0,LOCATION_REMOVED,1,ft2,nil,e,1-tp)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				while tc do
					Duel.SpecialSummonStep(tc,0,1-tp,1-tp,true,false,POS_FACEUP)
					tc=g:GetNext()
					count=count+1
				end
			end
		end
		if count>0 then
			Duel.SpecialSummonComplete()
			Duel.BreakEffect()
			local dg=Duel.GetMatchingGroup(c101010299.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
