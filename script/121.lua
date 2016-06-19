--ＨＥＲＯの儀式
function c101010172.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c101010172.target)
	e0:SetOperation(c101010172.activate)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c101010172.thcon)
	e1:SetCost(c101010172.thcost)
	e1:SetTarget(c101010172.thtg)
	e1:SetOperation(c101010172.thop)
	c:RegisterEffect(e1)
end
function c101010172.ritual_filter(c,e,tp,m)
	if not (c:IsSetCard(0x8) or c:IsSetCard(0x785a)) or bit.band(c:GetOriginalType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c:IsLocation(LOCATION_SZONE) and c:IsControler(1-tp) and c:IsFacedown() then return false end
	local mg=nil
	if c.mat_filter then
		mg=m:Filter(c.mat_filter,c)
	else
		mg=m:Clone()
		mg:RemoveCard(c)
	end
	local lv=c:GetLevel()
	if c:IsLocation(LOCATION_SZONE) then lv=c:GetOriginalLevel() end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,lv,1,99,c)
end
function c101010172.mfilter(c)
	return c:GetOriginalLevel()>0 and c:IsAbleToGrave()
end
function c101010172.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local lg=Duel.GetMatchingGroup(c101010172.mfilter,tp,LOCATION_SZONE,0,nil)
		mg:Merge(lg)
		return Duel.IsExistingMatchingCard(c101010172.ritual_filter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_SZONE)
end
function c101010172.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local lg=Duel.GetMatchingGroup(c101010172.mfilter,tp,LOCATION_SZONE,0,nil)
	mg:Merge(lg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c101010172.ritual_filter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc:IsFacedown() and tc:IsOnField() then Duel.ConfirmCards(1-tp,tc) end
		mg:RemoveCard(tc)
		if tc.mat_filter then
		   mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c101010172.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetHandler():GetTurnID()
end
function c101010172.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101010172.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8) and c:IsAbleToHand()
end
function c101010172.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010172.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010172.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101010172.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101010172.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_SUMMON)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(1,0)
		e4:SetTarget(c101010172.sumlimit)
		e4:SetLabel(tc:GetCode())
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e2=e4:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e4:Clone()
		e3:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e3,tp)
		local e5=e4:Clone()
		e3:SetCode(EFFECT_CANNOT_SSET)
		Duel.RegisterEffect(e5,tp)
	end
end
function c101010172.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
