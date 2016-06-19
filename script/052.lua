--PSYStream River
function c101010669.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--All Psychic-Type monsters gain 300 ATK.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PSYCHO))
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	--You can banish 1 "PSYStream" monster from your Graveyard, then target 1 "PSYStream" monster you control; it becomes a Tuner until the end of this turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101010669)
	e2:SetCost(c101010669.tcost)
	e2:SetTarget(c101010669.target)
	e2:SetOperation(c101010669.operation)
	c:RegisterEffect(e2)
	--[[During either player's turn, if this card was sent to the Graveyard this turn: You can banish this card from your Graveyard, then target 1 of your banished Level 4 "PSYStream" Tuner monsters; Special Summon it in face-up Defense Position, and if you do, immediately after this effect resolves, Synchro Summon 1 "PSYStream" monster, using only that monster and your banished "PSYStream" monsters.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c101010669.regop)
	c:RegisterEffect(e3)]]
end
function c101010669.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x127)
end
function c101010669.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x127) and c:IsAbleToRemoveAsCost()
end
function c101010669.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010669.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101010669.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010669.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x127) and not c:IsType(TYPE_TUNER)
end
function c101010669.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010669.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010669.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101010669.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101010669.synfilter(c,tc,mg)
	return c:IsSynchroSummonable(tc,mg) and c:IsSetCard(0x127)
end
function c101010669.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		local mg=Group.FromCards(tc)
		mg:Merge(Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x127))
		local g=Duel.GetMatchingGroup(c101010669.synfilter,tp,LOCATION_EXTRA,0,nil,tc,mg)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),tc,mg)
		end
	end
end
--[[function c101010669.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCountLimit(1,101010669)
	e2:SetCost(c101010669.cost)
	e2:SetTarget(c101010669.sptg)
	e2:SetOperation(c101010669.activate)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function c101010669.tcfilter(c)
	return c:IsSetCard(0x127) and c:IsAbleToRemoveAsCost()
end
function c101010669.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c101010669.tcfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101010669.tcfilter,tp,LOCATION_HAND,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010669.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x127) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010669.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101010669.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010669.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010669.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010669.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE)~=0 then
		local mg=Group.FromCards(tc)
		mg:Merge(Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_REMOVED,0,nil,0x127))
		local g=Duel.GetMatchingGroup(c101010669.synfilter,tp,LOCATION_EXTRA,0,nil,tc,mg)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),tc,mg)
		end
	end
end]]
