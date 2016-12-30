--created & coded by Lyris
--モニュメント・シェル
function c101010464.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c101010464.ffilter,2,false)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101010464)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101010464.target)
	e2:SetOperation(c101010464.operation)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101010464,ACTIVITY_SPSUMMON,c101010464.cfilter)
end
function c101010464.ffilter(c)
	return c:IsLevelBelow(5) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function c101010464.cfilter(c)
	return c:IsRace(RACE_MACHINE)
end
function c101010464.filter(c,tp)
	return c:IsFaceup() and c101010464.ffilter(c) and c:IsAbleToGrave() and (c:IsLevelBelow(2) or Duel.GetCustomActivityCount(101010464,tp,ACTIVITY_SPSUMMON)==0) and Duel.IsPlayerCanDraw(tp,math.ceil(c:GetLevel()/2))
end
function c101010464.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101010464.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101010464.filter,tp,LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c101010464.filter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	local lv=math.ceil(g:GetFirst():GetLevel()/2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,lv)
end
function c101010464.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and (tc:IsLevelBelow(2) or Duel.GetCustomActivityCount(101010464,tp,ACTIVITY_SPSUMMON)==0) then
		Duel.BreakEffect()
		if Duel.Draw(tp,math.ceil(tc:GetLevel()/2),REASON_EFFECT)>=2 then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e0:SetReset(RESET_PHASE+PHASE_END)
			e0:SetTargetRange(1,0)
			e0:SetTarget(c101010464.splimit)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function c101010464.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_MACHINE
end
