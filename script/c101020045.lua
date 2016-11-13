--created by LionHeartKIng
--coded by Lyris
--リベリオン・ファントム
function c101020045.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--revive
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,101020045)
	e6:SetCost(c101020045.cost)
	e6:SetTarget(c101020045.tg)
	e6:SetOperation(c101020045.op)
	c:RegisterEffect(e6)
	--dragonify
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c101020045.drgcon)
	e5:SetTarget(c101020045.drgtg)
	e5:SetOperation(c101020045.drgop)
	c:RegisterEffect(e5)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,101020045)
	e4:SetTarget(c101020045.thtg)
	e4:SetOperation(c101020045.thop)
	c:RegisterEffect(e4)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return r==REASON_XYZ end)
	e3:SetOperation(c101020045.efop)
	c:RegisterEffect(e3)
	--change scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c101020045.sctg)
	e2:SetOperation(c101020045.scop)
	c:RegisterEffect(e2)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101020045.spcon)
	e1:SetOperation(c101020045.spop)
	c:RegisterEffect(e1)
end
function c101020045.scale(c)
	return c:IsCode(45627618) and c:GetLeftScale()<12 and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c101020045.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101020045.scale(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020045.scale,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101020045.scale,tp,LOCATION_SZONE,0,1,1,nil)
end
function c101020045.scop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
	end
end
function c101020045.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101020045.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,e:GetHandler())
end
function c101020045.spfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0xbad) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end
function c101020045.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101020045.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101020045.thfilter(c)
	return c:IsSetCard(0xbad) and not c:IsCode(101020045) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c101020045.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020045.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101020045.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101020045.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101020045.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e2=Effect.CreateEffect(rc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	rc:RegisterEffect(e2,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e1,true)
	end
end
function c101020045.cfilter(c,e,tp)
	return c:IsSetCard(0xbad) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
		and (not e or c:IsRelateToEffect(e))
end
function c101020045.drgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101020045.cfilter,1,nil,nil,tp)
end
function c101020045.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbad)
end
function c101020045.drgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101020045.afilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020045.afilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101020045.afilter,tp,LOCATION_MZONE,0,2,2,nil)
end
function c101020045.drgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
		if tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_DRAGON)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function c101020045.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() end
	Duel.Destroy(c,REASON_COST)
end
function c101020045.filter(c)
	return c:IsSetCard(0xbad) and c:IsFaceup() and (c:IsLocation(LOCATION_MZONE) or (c:GetSequence()==6 or c:GetSequence()==7))
end
function c101020045.dfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101020045.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101020045.dfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingTarget(c101020045.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101020045.dfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101020045.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101020045.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:RemoveCard(tc)
	local oc=g:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and oc:IsRelateToEffect(e) then
		local og=Duel.GetDecktopGroup(tp,1)
		og:Merge(Group.FromCards(oc))
		Duel.DisableShuffleCheck()
		Duel.Overlay(tc,og)
	end
end
