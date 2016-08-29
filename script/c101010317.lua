--
function c101010317.initial_effect(c)
--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c101010317.cost)
	e0:SetOperation(c101010317.activate)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) local c=e:GetHandler() return Duel.GetTurnPlayer()==tp end)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101010317,ACTIVITY_CHAIN,c101010317.chainfilter)
end
function c101010317.chainfilter(re,tp,cid)
	return not re:IsHasCategory(CATEGORY_DRAW)
end
function c101010317.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x93) --and (c:IsCode(70095154) or aux.IsMaterialListCode(c,70095154))
		and Duel.IsExistingMatchingCard(c101010317.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,lv,e,tp)
end
function c101010317.filter2(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c101010317.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if Duel.CheckEvent(EVENT_PREDRAW) and c:IsLocation(LOCATION_HAND) and not c:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND) then return false end
		return Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(c101010317.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	if Duel.CheckEvent(EVENT_PREDRAW) then
		Duel.ChangePosition(c,POS_FACEUP)
		local dt=Duel.GetDrawCount(tp)
		if dt~=0 then
			_replace_count=0
			_replace_max=dt
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_DRAW)
			e1:SetValue(0)
			Duel.RegisterEffect(e1,tp)
		end
		e:SetType(EFFECT_TYPE_ACTIVATE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.PayLPCost(tp,1000)
	Duel.BreakEffect()
	local g=Duel.SelectMatchingCard(tp,c101010317.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
end
function c101010317.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010317.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
