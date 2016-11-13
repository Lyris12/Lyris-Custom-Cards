--created & coded by Lyris
--ファントム・ペンデュレーディ　ドラコ・旋風
function c101010422.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(aux.SynCondition(nil,aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1,99))
	e0:SetTarget(aux.SynTarget(nil,aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1,99))
	e0:SetOperation(c101010422.sprop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c101010422.efilter)
	c:RegisterEffect(e6)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101010422,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(0)
	e4:SetCost(c101010422.spcost)
	e4:SetTarget(c101010422.sptg)
	e4:SetOperation(c101010422.spop)
	c:RegisterEffect(e4)
	--While you control a Token, this card cannot be destroyed by battle or card effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c101010422.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--You can Tribute 1 "Senpu Bunshin Token" OR shuffle 1 other "Senpu" monster you control into the Main Deck, then target 1  on the field; shuffle that target into its owner's deck. This card cannot attack during the turn you activate this effect.
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101010422,2))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,101010422)
	e5:SetCost(c101010422.tdcost)
	e5:SetTarget(c101010422.tdtg)
	e5:SetOperation(c101010422.tdop)
	c:RegisterEffect(e5)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010422,3))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101010422)
	e1:SetCost(c101010422.tdcost2)
	e1:SetTarget(c101010422.tdtg2)
	e1:SetOperation(c101010422.tdop)
	c:RegisterEffect(e1)
end
function c101010422.spfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)  and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToDeck()
end
function c101010422.spfilter2(c)
	return c:IsFaceup() and c:IsCode(160000895) and c:IsAbleToDeck()
end
function c101010422.sprcon(e,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c101010422.efilter(e,te)
	local c=te:GetHandler()
	return c:IsCode(503) or c:IsCode(539)
end
function c101010422.indcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function c101010422.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,ft,nil)
	-- local rg=g:FilterSelect(tp,Card.IsAbleToDeck,1,ft,nil)
	e:SetLabel(g:GetCount())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c101010422.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
	and Duel.IsPlayerCanSpecialSummonMonster(tp,101010080,0x1d5d,0x4011,1100,1700,3,RACE_WINDBEAST,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c101010422.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,101010080,0x1d5d,0x4011,1100,1700,3,RACE_WINDBEAST,ATTRIBUTE_WIND) then
		for i=1,ct do
		local token=Duel.CreateToken(tp,101010080)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
	end
end
function c101010422.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0
		and Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,101010080) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,101010080)
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c101010422.cfilter(c)
	return c:IsSetCard(0x1d5d) and c:IsAbleToDeckAsCost()
end
function c101010422.tdcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0
	and Duel.IsExistingMatchingCard(c101010422.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c101010422.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if Duel.SendtoDeck(g,nil,2,REASON_COST)==0 then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c101010422.filter(c)
	return c:IsType(TYPE_PENDULUM) or bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and c:IsAbleToDeck()
end
function c101010422.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101010422.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010422.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101010422.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101010422.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101010422.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
